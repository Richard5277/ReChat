//
//  SettingView.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-12-05.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit
import Firebase

class TabFourViewController: UIViewController {
    
    let rechatIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "rechat")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var logOutButton: UIButton = {
        let button = UIButton(type: UIButtonType.roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = MyColor.mainRed
        button.tintColor = MyColor.textWhite
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle("Logout", for: UIControlState.normal)
        button.titleLabel?.font = UIFont(name: "SourceCodePro-Regular", size: 24)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = MyColor.mainBlack
        self.title = "Setting"
        
        view.addSubview(rechatIcon)
        view.addSubview(logOutButton)
        
        rechatIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        rechatIcon.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        rechatIcon.widthAnchor.constraint(equalToConstant: 160).isActive = true
        rechatIcon.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logOutButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        logOutButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
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
