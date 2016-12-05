//
//  MessageView.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-12-02.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit
import Firebase

class MessageView: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var allMessages = [Message]()
    var allMessagesDictionary = [String: Message]()
    var timer: Timer?
    let cellId = "cellId"
    
    let topContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = MyColor.mainBlack
        return container
    }()
    
    let rechatIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "rechat")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var addButton: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage(named: "add"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    let chatTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .singleLine
        table.separatorColor = MyColor.mainRed
        table.tableFooterView = UIView(frame: .zero) // MARK:Hide Cell Separator When No Content
        table.allowsMultipleSelectionDuringEditing = true //MARK: Delete button
        table.backgroundColor = .clear
        
        return table
    }()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        // Move setup Cell content to UserCell Class
        let message = allMessages[indexPath.row]
        cell.message = message
        return cell
    }
    
//    func handleNewMessage(){
//        let newMessageController = NewMessageController()
//        let navController = UINavigationController(rootViewController: newMessageController)
//        newMessageController.messageControler = self
//        present(navController, animated: true, completion: nil)
//    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Messages"
        chatTable.delegate = self
        chatTable.dataSource = self
        
        view.backgroundColor = .clear
        
        checkIfUserLogedIn()
        self.chatTable.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        view.addSubview(topContainer)
        view.addSubview(chatTable)
        topContainer.addSubview(rechatIcon)
        topContainer.addSubview(addButton)
        
        topContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topContainer.heightAnchor.constraint(equalToConstant: 80).isActive = true
        topContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        chatTable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chatTable.topAnchor.constraint(equalTo: topContainer.bottomAnchor).isActive = true
        chatTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
//        chatTable.heightAnchor.constraint(equalToConstant: 900).isActive = true
        chatTable.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -8).isActive = true
        
        rechatIcon.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor).isActive = true
        rechatIcon.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 20).isActive = true
        rechatIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        rechatIcon.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        addButton.rightAnchor.constraint(equalTo: topContainer.rightAnchor, constant: -12).isActive = true
        addButton.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 30).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.tintColor = .white
        allMessages.removeAll()
        allMessagesDictionary.removeAll()
        observeUserMessages()
        self.chatTable.reloadData()
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
