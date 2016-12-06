//
//  contactDetailViwe.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-12-05.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit

class contactDetailViwe: UIViewController{
    
    var currentUser: User?
    var chatView: NewMessageController?

    init(user: User){
        self.currentUser = user
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let profileContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .clear
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    let albumContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .yellow
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    lazy var profielImge: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        let imageUrl = self.currentUser?.profileImageUrl
        imageView.loadImageUsingCacheWithUrlString(urlString: imageUrl!)
        return imageView
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.textColor = MyColor.textWhite
        label.font = UIFont(name: "SourceCodePro-Regular", size: 16)
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.textColor = MyColor.textWhite
        label.font = UIFont(name: "SourceCodePro-Regular", size: 16)
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var sendMessageButton: UIButton = {
        let button = UIButton(type: UIButtonType.roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = MyColor.mainRed
        button.tintColor = MyColor.textWhite
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont(name: "SourceCodePro-Regular", size: 20)
        button.setTitle("Message", for: UIControlState.normal)
        button.addTarget(self, action: #selector(snedMessage), for: .touchUpInside)
        return button
    }()
    
    let callMessageButton: UIButton = {
        let button = UIButton(type: UIButtonType.roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = MyColor.mainRed
        button.tintColor = MyColor.textWhite
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont(name: "SourceCodePro-Regular", size: 20)
        button.setTitle("Free Call", for: UIControlState.normal)
        return button
    }()
    
    
    override func viewDidLoad() {
//        title = currentUser?.name
        title = "Profile"
        nameLabel.text = currentUser?.name
        emailLabel.text = currentUser?.email
        //MARK: Custom NavBar
        let navigationBar = navigationController!.navigationBar
        navigationBar.tintColor = MyColor.textWhite
        navigationBar.barTintColor = MyColor.mainRed
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: MyColor.textWhite]
        let leftButton =  UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelMessage))
        
        navigationItem.leftBarButtonItem = leftButton
        view.backgroundColor = MyColor.mainBlack
        
        view.addSubview(profileContainer)
        profileContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        profileContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        profileContainer.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        view.addSubview(albumContainer)
        albumContainer.topAnchor.constraint(equalTo: profileContainer.bottomAnchor, constant: 12).isActive = true
        albumContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        albumContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        albumContainer.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        view.addSubview(sendMessageButton)
        sendMessageButton.topAnchor.constraint(equalTo: albumContainer.bottomAnchor, constant: 12).isActive = true
        sendMessageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sendMessageButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        sendMessageButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        view.addSubview(callMessageButton)
        callMessageButton.topAnchor.constraint(equalTo: sendMessageButton.bottomAnchor, constant: 12).isActive = true
        callMessageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        callMessageButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        callMessageButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        profileContainer.addSubview(profielImge)
        profielImge.leftAnchor.constraint(equalTo: profileContainer.leftAnchor, constant: 12).isActive = true
        profielImge.topAnchor.constraint(equalTo: profileContainer.topAnchor, constant: 8).isActive = true
        profielImge.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profielImge.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        profileContainer.addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: profielImge.rightAnchor, constant: 12).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileContainer.topAnchor, constant: 6).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 160).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        profileContainer.addSubview(emailLabel)
        emailLabel.leftAnchor.constraint(equalTo: profielImge.rightAnchor, constant: 12).isActive = true
        emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3).isActive = true
        emailLabel.widthAnchor.constraint(equalToConstant: 160).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func cancelMessage(){
        dismiss(animated: true, completion: nil)
    }
    
    func snedMessage(){
        dismiss(animated: true, completion: { () in
            print("Show Chat")
        })
        self.chatView?.showChatControllerRorUser(user: self.currentUser!)
    }
}

