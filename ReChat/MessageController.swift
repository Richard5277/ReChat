//
//  MessageController.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-11-15.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit
import Firebase

class MessageController: UITableViewController {

    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = MyColor.mainBlack
        tableView.backgroundColor = MyColor.mainBlack
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))

//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add-red"), landscapeImagePhone: UIImage(named: "add-red"), style: .plain, target: self, action: #selector(handleNewMessage))
        
        //set up custom add button
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage(named: "add-red"), for: .normal)
        button.addTarget(self, action: #selector(handleNewMessage), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButton
        
        checkIfUserLogedIn()
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = MyColor.mainRed
        tableView.tableFooterView = UIView() // MARK:Hide Cell Separator When No Content
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        tableView.allowsMultipleSelectionDuringEditing = true //MARK: Delete button
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        allMessages.removeAll()
        allMessagesDictionary.removeAll()
        observeUserMessages()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        fetchUserAndSetupNavBarTitle()
    }

    var allMessages = [Message]()
    var allMessagesDictionary = [String: Message]()
    
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
    
    var timer: Timer?
    func handleReloadTable(){
        // Doesnt have to reconstruct the data every time we got a new message
        self.allMessages = Array(self.allMessagesDictionary.values)
        self.allMessages.sort(by: { (message1, message2) -> Bool in
            return (message1.time?.intValue)! > (message2.time?.intValue)!
        })
        
        // call dispatch aysc, or app will crash because of the background thread
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMessages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        // Move setup Cell content to UserCell Class
        let message = allMessages[indexPath.row]
        cell.message = message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func handleNewMessage(){
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        newMessageController.messageControler = self
        present(navController, animated: true, completion: nil)
    }
    func checkIfUserLogedIn(){
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }else{
            fetchUserAndSetupNavBarTitle()
        }

    }
    
    func fetchUserAndSetupNavBarTitle(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapShot) in
            if let dictionary = snapShot.value as? [String: AnyObject] {
                let user = User()
                user.setValuesForKeys(dictionary)
                self.setupNavBarWithUser(user: user)
            }
        }, withCancel: nil)
    }
    
    func setupNavBarWithUser(user: User){
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 120, height: 40)
        
        // magic, create a container view to fill out the space
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.masksToBounds = true
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = user.name
        
        containerView.addSubview(profileImageView)
        containerView.addSubview(nameLabel)
        
        
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 1).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
    }
    
    func showChatControllerRorUser(user: User){
        
        let chatViewController = ChatViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatViewController.user = user
        navigationController?.pushViewController(chatViewController, animated: true)
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
    
}

