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
    
    let markContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .clear
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    let markLabel : UILabel = {
        let label = UILabel()
        label.text = "Mark"
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.textColor = MyColor.textWhite
        label.font = UIFont(name: "SourceCodePro-Regular", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let markLabelContent : UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "Friend"
        label.textAlignment = .left
        label.textColor = MyColor.textWhite
        label.font = UIFont(name: "SourceCodePro-Regular", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let markContainerSeparator: UIView = {
        let container = UIView()
        container.backgroundColor = MyColor.mainRed
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    let albumContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .clear
        container.layer.cornerRadius = 5
        container.layer.masksToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    let albumLabel : UILabel = {
        let label = UILabel()
        label.text = "Album"
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.textColor = MyColor.textWhite
        label.font = UIFont(name: "SourceCodePro-Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var albumImgeOne: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        let imageUrl = self.currentUser?.profileImageUrl
        imageView.loadImageUsingCacheWithUrlString(urlString: imageUrl!)
        return imageView
    }()

    lazy var albumImgeTwo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        let imageUrl = self.currentUser?.profileImageUrl
        imageView.loadImageUsingCacheWithUrlString(urlString: imageUrl!)
        return imageView
    }()

    
    let albumContainerSeparator: UIView = {
        let container = UIView()
        container.backgroundColor = MyColor.mainRed
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    let regionContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .clear
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    let regionLabel : UILabel = {
        let label = UILabel()
        label.text = "Region"
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.textColor = MyColor.textWhite
        label.font = UIFont(name: "SourceCodePro-Regular", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let regionLabelContent : UILabel = {
        let label = UILabel()
        label.text = "Canada"
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.textColor = MyColor.textWhite
        label.font = UIFont(name: "SourceCodePro-Regular", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.textColor = MyColor.textWhite
        label.font = UIFont(name: "SourceCodePro-Regular", size: 16)
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
        
        setUpView()
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

