//
//  ChatInputContainerView.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-11-29.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit

class ChatInputContainerView: UIView, UITextFieldDelegate {
    
    let sendButton :UIButton = {
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        return sendButton
    }()
    
    let sendImageIconView: UIImageView = {
        let sendImageIconView = UIImageView()
        sendImageIconView.image = UIImage(named: "sendImageIcon")
        sendImageIconView.isUserInteractionEnabled = true
        sendImageIconView.translatesAutoresizingMaskIntoConstraints = false
        return sendImageIconView
    }()
    
    let seperator: UIView = {
        let seperator = UIView()
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.backgroundColor = UIColor(r: 220, g: 220, b: 220, a: 0.8)
        return seperator
    }()
    
    var chatViewController: ChatViewController? {
        didSet {
            sendButton.addTarget(chatViewController, action: #selector(chatViewController?.handelSendMessage), for: .touchUpInside)
            
            sendImageIconView.addGestureRecognizer(UITapGestureRecognizer(target: chatViewController, action: #selector(chatViewController?.handleSendImage)))
        }
    }
    
    lazy var messageTextField: UITextField = {
        let message = UITextField()
        message.translatesAutoresizingMaskIntoConstraints = false
        message.placeholder = "Enter Message..."
        message.delegate = self
        return message
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
       
        addSubview(sendImageIconView)
        addSubview(seperator)
        addSubview(messageTextField)
        addSubview(sendButton)
        
        seperator.topAnchor.constraint(equalTo: topAnchor).isActive = true
        seperator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        seperator.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        sendImageIconView.leftAnchor.constraint(equalTo: leftAnchor, constant: 2).isActive = true
        sendImageIconView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        sendImageIconView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        sendImageIconView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        self.messageTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        self.messageTextField.leftAnchor.constraint(equalTo: sendImageIconView.rightAnchor, constant: 8).isActive = true
        self.messageTextField.heightAnchor.constraint(equalTo: heightAnchor, constant: 5).isActive = true
        self.messageTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        
        sendButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chatViewController?.handelSendMessage()
        return true
    }
    
}
