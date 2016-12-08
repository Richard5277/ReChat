//
//  ReChatTabBar.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-12-01.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit
import Firebase

class ReChatTabBar: UITabBarController, UITabBarControllerDelegate {
    
    var currentUser: User?
    
    func checkIfUserLogedIn(){
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }else{
            print("Login As User: \(FIRAuth.auth()?.currentUser?.uid)")
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
                self.currentUser = user
            }
        }, withCancel: nil)
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


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Messages"
        checkIfUserLogedIn()
        self.delegate = self
        self.tabBar.barTintColor = MyColor.mainBlack
        self.tabBar.tintColor = MyColor.mainRed
        self.tabBar.unselectedItemTintColor = MyColor.textWhite
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let tabOne = MessageView()
        let resizedMessageWhite = UIImage().resizeImage(image: UIImage(named: "message-white")!, newWidth: 33)
        let resizedMessageRed = UIImage().resizeImage(image: UIImage(named: "message-red")!, newWidth: 33)
        let tabOneBarItem = UITabBarItem(title: "Messages", image: resizedMessageWhite.withRenderingMode(.alwaysOriginal), selectedImage: resizedMessageRed.withRenderingMode(.alwaysOriginal))
        tabOne.tabBarItem = tabOneBarItem
        
        let tabTwo = NewMessageController()
        let resizedContactWhite = UIImage().resizeImage(image: UIImage(named: "contact-white")!, newWidth: 30)
        let resizedContactRed = UIImage().resizeImage(image: UIImage(named: "contact-red")!, newWidth: 30)
        let tabTwoBarItem2 = UITabBarItem(title: "Contact", image: resizedContactWhite.withRenderingMode(.alwaysOriginal), selectedImage: resizedContactRed.withRenderingMode(.alwaysOriginal))
        tabTwo.tabBarItem = tabTwoBarItem2
        
        let tabThree = MomentView()
        let resizedMomentWhite = UIImage().resizeImage(image: UIImage(named: "moment-white")!, newWidth: 30)
        let resizedMomentRed = UIImage().resizeImage(image: UIImage(named: "moment-red")!, newWidth: 30)
        let tabThreeItem = UITabBarItem(title: "Moments", image: resizedMomentWhite.withRenderingMode(.alwaysOriginal), selectedImage: resizedMomentRed.withRenderingMode(.alwaysOriginal))
        tabThree.tabBarItem = tabThreeItem

        let tabFour = TabFourViewController()
        let resizedSettingWhite = UIImage().resizeImage(image: UIImage(named: "setting-white")!, newWidth: 30)
        let resizedSettingRed = UIImage().resizeImage(image: UIImage(named: "setting-red")!, newWidth: 30)
        let tabFourBarItem = UITabBarItem(title: "Setting", image: resizedSettingWhite.withRenderingMode(.alwaysOriginal), selectedImage: resizedSettingRed.withRenderingMode(.alwaysOriginal))
        tabFour.tabBarItem = tabFourBarItem

        
        self.viewControllers = [tabOne, tabTwo, tabThree, tabFour]
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        navigationItem.title = viewController.title
        print("Selected: \(viewController.title!)")
    }
}





