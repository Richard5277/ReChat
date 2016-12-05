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
                //                self.setupNavBarWithUser(user: user)
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
//        let tabOne = MessageController()
        let tabOne = MessageView()
        let tabOneBarItem = UITabBarItem(title: "Tab 1", image: UIImage(named: "message-black"), selectedImage: UIImage(named: "message-red"))
        tabOne.tabBarItem = tabOneBarItem
        
        let tabTwo = NewMessageController()
//        tabTwo.navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(tryOMG))
        let tabTwoBarItem2 = UITabBarItem(title: "Tab 2", image: UIImage(named: "contact-black"), selectedImage: UIImage(named: "contact-red"))
        tabTwo.tabBarItem = tabTwoBarItem2
        
        let tabThree = TabThreeViewController()
        let tabThreeItem = UITabBarItem(title: "Tab 1", image: UIImage(named: "moment-black"), selectedImage: UIImage(named: "moment-red"))
        tabThree.tabBarItem = tabThreeItem

        let tabFour = TabFourViewController()
        let tabFourBarItem = UITabBarItem(title: "Tab 1", image: UIImage(named: "setting-black"), selectedImage: UIImage(named: "setting-red"))
        tabFour.tabBarItem = tabFourBarItem

        
        self.viewControllers = [tabOne, tabTwo, tabThree, tabFour]
    }
    func tryOMG(){
        print(123)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        navigationItem.title = viewController.title!
        print("Selected: \(viewController.title!)")
    }
}
class TabOneViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = MyColor.mainBlack
        self.title = "Tab 1"
    }
    
}
class TabTwoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = MyColor.mainBlack
        self.title = "Tab 2"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
 
}


class TabThreeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = MyColor.mainBlack
        self.title = "Moments"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
}

class TabFourViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = MyColor.mainBlack
        self.title = "Setting"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
}





