//
//  AppDelegate.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-11-29.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        window?.makeKeyAndVisible()
        
        let mainNav = UINavigationController(rootViewController: ReChatTabBar())
        mainNav.navigationBar.barTintColor = MyColor.mainBlack
        mainNav.navigationBar.tintColor = MyColor.textWhite
        mainNav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: MyColor.textWhite]
        
        window?.rootViewController = mainNav
        UIApplication.shared.statusBarStyle = .lightContent
        return true
    }  
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        return handled
    }
    
}
