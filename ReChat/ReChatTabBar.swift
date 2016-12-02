//
//  ReChatTabBar.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-12-01.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit

class Item1ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        self.title = "item1"
        print("item 1 loaded")
    }
}

class ReChatTabBar: UITabBarController, UITabBarControllerDelegate {
        override func viewDidLoad() {
            super.viewDidLoad()
            delegate = self
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            let item1 = Item1ViewController()
            let icon1 = UITabBarItem(title: "Title", image: UIImage(named: "sendImageIcon"), selectedImage: UIImage(named: "profileImage"))
            item1.tabBarItem = icon1
            let controllers = [item1]  //array of the root view controllers displayed by the tab bar interface
            self.viewControllers = controllers
        }
    
        //Delegate methods
        func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
            print("Should select viewController: \(viewController.title) ?")
            return true;
        }
}
