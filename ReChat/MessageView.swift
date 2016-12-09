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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Rechat"
        chatTable.delegate = self
        chatTable.dataSource = self
        
        view.backgroundColor = .clear
        
        checkIfUserLogedIn()
        self.chatTable.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        view.addSubview(topContainer)
        view.addSubview(chatTable)
        
        topContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topContainer.heightAnchor.constraint(equalToConstant: 80).isActive = true
        topContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        chatTable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chatTable.topAnchor.constraint(equalTo: topContainer.bottomAnchor).isActive = true
        chatTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        chatTable.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -8).isActive = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.tintColor = .white
        allMessages.removeAll()
        allMessagesDictionary.removeAll()
        observeUserMessages()
        self.chatTable.reloadData()
    }

}
