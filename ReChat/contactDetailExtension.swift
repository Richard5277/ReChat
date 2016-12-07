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
        markContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        markContainer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        markContainer.addSubview(markLabel)
        markLabel.leftAnchor.constraint(equalTo: markContainer.leftAnchor).isActive = true
        markLabel.topAnchor.constraint(equalTo: markContainer.topAnchor).isActive = true
        markLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        markLabel.heightAnchor.constraint(equalTo: markContainer.heightAnchor).isActive = true
        
        markContainer.addSubview(markLabelContent)
        markLabelContent.leftAnchor.constraint(equalTo: markLabel.rightAnchor, constant: 8).isActive = true
        markLabelContent.heightAnchor.constraint(equalTo: markContainer.heightAnchor).isActive = true
        markLabelContent.rightAnchor.constraint(equalTo: markContainer.rightAnchor).isActive = true
        markLabelContent.topAnchor.constraint(equalTo: markContainer.topAnchor).isActive = true
        
        markContainer.addSubview(markContainerSeparator)
        markContainerSeparator.bottomAnchor.constraint(equalTo: markContainer.bottomAnchor).isActive = true
        markContainerSeparator.centerXAnchor.constraint(equalTo: markContainer.centerXAnchor).isActive = true
        markContainerSeparator.widthAnchor.constraint(equalTo: markContainer.widthAnchor).isActive = true
        markContainerSeparator.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        
        // MRAK: Album Container
        view.addSubview(albumContainer)
        albumContainer.topAnchor.constraint(equalTo: markContainer.bottomAnchor, constant: 0).isActive = true
        albumContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        albumContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        albumContainer.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        albumContainer.addSubview(albumLabel)
        albumLabel.leftAnchor.constraint(equalTo: albumContainer.leftAnchor).isActive = true
        albumLabel.centerYAnchor.constraint(equalTo: albumContainer.centerYAnchor).isActive = true
        albumLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        albumLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        albumContainer.addSubview(albumImgeOne)
        albumImgeOne.centerYAnchor.constraint(equalTo: albumContainer.centerYAnchor).isActive = true
        albumImgeOne.heightAnchor.constraint(equalToConstant: 80).isActive = true
        albumImgeOne.widthAnchor.constraint(equalToConstant: 80).isActive = true
        albumImgeOne.leftAnchor.constraint(equalTo: albumLabel.rightAnchor, constant: 9).isActive = true
        
        albumContainer.addSubview(albumImgeTwo)
        albumImgeTwo.centerYAnchor.constraint(equalTo: albumContainer.centerYAnchor).isActive = true
        albumImgeTwo.heightAnchor.constraint(equalToConstant: 80).isActive = true
        albumImgeTwo.widthAnchor.constraint(equalToConstant: 80).isActive = true
        albumImgeTwo.leftAnchor.constraint(equalTo: albumImgeOne.rightAnchor, constant: 12).isActive = true
        
        albumContainer.addSubview(albumContainerSeparator)
        albumContainerSeparator.widthAnchor.constraint(equalTo: albumContainer.widthAnchor).isActive = true
        albumContainerSeparator.bottomAnchor.constraint(equalTo: albumContainer.bottomAnchor).isActive = true
        albumContainerSeparator.heightAnchor.constraint(equalToConstant: 2).isActive = true
        albumContainerSeparator.centerXAnchor.constraint(equalTo: albumContainer.centerXAnchor).isActive = true
        
        // MARK: Region Container
        view.addSubview(regionContainer)
        regionContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        regionContainer.topAnchor.constraint(equalTo: albumContainer.bottomAnchor, constant: 0).isActive = true
        regionContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        regionContainer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        regionContainer.addSubview(regionLabel)
        regionLabel.leftAnchor.constraint(equalTo: regionContainer.leftAnchor).isActive = true
        regionLabel.topAnchor.constraint(equalTo: regionContainer.topAnchor).isActive = true
        regionLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        regionLabel.heightAnchor.constraint(equalTo: regionContainer.heightAnchor).isActive = true
        
        regionContainer.addSubview(regionLabelContent)
        regionLabelContent.leftAnchor.constraint(equalTo: regionLabel.rightAnchor, constant: 8).isActive = true
        regionLabelContent.heightAnchor.constraint(equalTo: regionContainer.heightAnchor).isActive = true
        regionLabelContent.widthAnchor.constraint(equalToConstant: 80).isActive = true
        regionLabelContent.topAnchor.constraint(equalTo: regionContainer.topAnchor).isActive = true
        
        // MARK: Message Button
        view.addSubview(sendMessageButton)
        sendMessageButton.topAnchor.constraint(equalTo: regionContainer.bottomAnchor, constant: 20).isActive = true
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
