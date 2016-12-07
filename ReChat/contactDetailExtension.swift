//
//  contactDetailExtension.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-12-06.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit

extension contactDetailViwe {
    func setUpView() {
        
        // MARK:Profile Container
        view.addSubview(profileContainer)
        profileContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        profileContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileContainer.widthAnchor.constraint(equalToConstant: 260).isActive = true
        profileContainer.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
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

        // MARK: Mark Container
        view.addSubview(markContainer)
        markContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        markContainer.topAnchor.constraint(equalTo: profileContainer.bottomAnchor, constant: 12).isActive = true
        markContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -12).isActive = true
        markContainer.heightAnchor.constraint(lessThanOrEqualToConstant: 50).isActive = true
        
        markContainer.addSubview(markLabel)
        markLabel.leftAnchor.constraint(equalTo: markContainer.leftAnchor).isActive = true
        markLabel.topAnchor.constraint(equalTo: markContainer.topAnchor).isActive = true
        markLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 80).isActive = true
        markLabel.heightAnchor.constraint(equalTo: markContainer.heightAnchor).isActive = true
        
        markContainer.addSubview(markLabelContent)
        markLabelContent.leftAnchor.constraint(equalTo: markLabel.rightAnchor, constant: 8).isActive = true
        markLabelContent.heightAnchor.constraint(equalTo: markContainer.heightAnchor).isActive = true
        markLabelContent.rightAnchor.constraint(equalTo: markContainer.rightAnchor).isActive = true
        markLabelContent.topAnchor.constraint(equalTo: markContainer.topAnchor).isActive = true
        
        // MRAK: Album Container
        view.addSubview(albumContainer)
        albumContainer.topAnchor.constraint(equalTo: markContainer.bottomAnchor, constant: 12).isActive = true
        albumContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        albumContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        albumContainer.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        // MARK: Message Button
        view.addSubview(sendMessageButton)
        sendMessageButton.topAnchor.constraint(equalTo: albumContainer.bottomAnchor, constant: 12).isActive = true
        sendMessageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sendMessageButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        sendMessageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Call Button
        view.addSubview(callMessageButton)
        callMessageButton.topAnchor.constraint(equalTo: sendMessageButton.bottomAnchor, constant: 12).isActive = true
        callMessageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        callMessageButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        callMessageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
            }
}
