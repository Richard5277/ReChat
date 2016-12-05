//
//  NewMessageController.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-11-18.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {

    let ref = FIRDatabase.database().reference()
    let cellId = "cellId"
    var users = [User]()
    
    override func viewDidLoad() {
        title = "Contacts"
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = MyColor.mainBlack
        navigationController?.navigationBar.barTintColor = MyColor.mainBlack
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: MyColor.textWhite]
        navigationItem.title = "New Message"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancle", style: .plain, target: self, action: #selector(cancleMessage))
       fetchUser()
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        //add head shoot
        if let userProfileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: userProfileImageUrl)
        }
        return cell
    }
    
//    var messageControler: MessageController?
    var messageControler: MessageView?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: { () in
            let currentUser = self.users[indexPath.row]
            self.messageControler?.showChatControllerRorUser(user: currentUser)
        })
    }

    func cancleMessage(){
        dismiss(animated: true, completion: nil)
    }

    func fetchUser(){
        ref.child("users").observe(.childAdded, with: {(snapShot) in
            if let dictionary = snapShot.value as? [String: AnyObject]{
                let user = User()
                user.id = snapShot.key
                
                // have to make sure every value matches the User class
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                
                // has to dispatch_async
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
        
    }
}
