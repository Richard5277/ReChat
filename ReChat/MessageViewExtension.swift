//
//  MessageViewExtension.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-12-04.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit
import Firebase

extension MessageView {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //MARK: message delete function
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        let message = allMessages[indexPath.row]
        if let chatpartnerId = message.checkPartnerId(){
            FIRDatabase.database().reference().child("user-messages").child(uid).child(chatpartnerId).removeValue(completionBlock: { (error, ref) in
                if error != nil{
                    print("Failed to delete message: \(error)")
                    return
                }
                self.allMessagesDictionary.removeValue(forKey: chatpartnerId)
                self.attemptReloadTable()
            })
        }
    }
 
    func observeUserMessages(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            print("Unknow User")
            return
        }
        let ref = FIRDatabase.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: {( snapshot ) in
            
            let chatPartnerId = snapshot.key
            
            FIRDatabase.database().reference().child("user-messages").child(uid).child(chatPartnerId).observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
                
                self.fetchMessageWithMessageId(messageId) // wraping into a seperate fun when its too long
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        
        ref.observe(.childRemoved, with: {(snapshot) in
            self.allMessagesDictionary.removeValue(forKey: snapshot.key)
            self.attemptReloadTable()
        }, withCancel: nil)
    }
    
    private func fetchMessageWithMessageId(_ messageId: String){
        let messageRef = FIRDatabase.database().reference().child("messages").child(messageId)
        
        messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                
                if let chatParterId = message.checkPartnerId() { // MARK: have to use chatPartnerId cuz chat is double way, both send and from has to appear in the same chat
                    
                    self.allMessagesDictionary[chatParterId] = message
                }
                // fixing bug, control the times we refreshing table data
                self.attemptReloadTable()
                
            }
        }, withCancel: nil)
    }
    private func attemptReloadTable(){
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    func handleReloadTable(){
        // Doesnt have to reconstruct the data every time we got a new message
        self.allMessages = Array(self.allMessagesDictionary.values)
        self.allMessages.sort(by: { (message1, message2) -> Bool in
            return (message1.time?.intValue)! > (message2.time?.intValue)!
        })
        
        // call dispatch aysc, or app will crash because of the background thread
        DispatchQueue.main.async {
            self.chatTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMessages.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected: \(indexPath.row)")
        let message = allMessages[indexPath.row]
        guard let chatPartnerId = message.checkPartnerId() else { return }
        
        let partnerRef = FIRDatabase.database().reference().child("users").child(chatPartnerId)
        partnerRef.observeSingleEvent(of: .value, with: {(snapshot) in
            guard let userDictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User()
            user.setValuesForKeys(userDictionary)
            user.id = chatPartnerId
            self.showChatControllerRorUser(user: user)
        }, withCancel: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

    func checkIfUserLogedIn(){
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }else{
            fetchUserAndSetupNavBarTitle()
        }
        
    }
    
    func handleLogout(){
        do {
            try FIRAuth.auth()?.signOut()
        }catch let logoutError {
            print(logoutError)
        }
        
        let loginRegisterVC = LoginRegisterViewController()
        self.present(loginRegisterVC, animated: true, completion: nil)
    }

    func fetchUserAndSetupNavBarTitle(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapShot) in
            if let dictionary = snapShot.value as? [String: AnyObject] {
                let user = User()
                user.setValuesForKeys(dictionary)
            }
        }, withCancel: nil)
    }

    func showChatControllerRorUser(user: User){
        
        let chatViewController = ChatViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatViewController.user = user
        self.navigationController?.pushViewController(chatViewController, animated: true)
        
    }
}






