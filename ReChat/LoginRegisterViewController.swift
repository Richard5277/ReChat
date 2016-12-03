//
//  LoginRegisterViewController.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-11-15.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class LoginRegisterViewController: UIViewController, FBSDKLoginButtonDelegate {

    let ref = FIRDatabase.database().reference()
    var inputsContainerViewHightAnchor: NSLayoutConstraint?
    var nameHeightAnchor: NSLayoutConstraint?
    var emailHeightAnchor: NSLayoutConstraint?
    var passwordHeightAnchor: NSLayoutConstraint?
    var seperatorAfterNameHeightAnchor: NSLayoutConstraint?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MyColor.mainBlack
        navigationController?.navigationBar.barTintColor = MyColor.mainBlack
        setUpInputsView()
        setUpView()
        setupSegementedView()
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did Log Out of Facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print("Login Error: \(error)")
        }
        print("Successfully Login with Facebook")
        loginFirebaseWithFacebook()
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .default
//    }
    
    lazy var loginRegisterSegementController: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["LOGIN","REGISTER"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.backgroundColor = MyColor.mainBlack
        let attr = NSDictionary(object: UIFont(name: "SourceCodePro-Regular", size: 20.0)!, forKey: NSFontAttributeName as NSCopying)
        sc.setTitleTextAttributes(attr as?[AnyHashable : Any], for: .normal)
        sc.layer.cornerRadius = 5
        sc.layer.masksToBounds = true
        sc.tintColor = MyColor.mainRed
        sc.selectedSegmentIndex = 1
        
        sc.addTarget(self, action: #selector(handleLoginRegisterToggle), for: .valueChanged)
        return sc
    }()

    func handleLoginRegisterToggle(){
        let title = loginRegisterSegementController.titleForSegment(at: loginRegisterSegementController.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        // chage inputs container
        inputsContainerViewHightAnchor?.constant = loginRegisterSegementController.selectedSegmentIndex == 0 ? 90 : 160
        
        // change name input
        nameHeightAnchor?.isActive = false
        nameHeightAnchor = nameInput.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegementController.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameInput.placeholder = loginRegisterSegementController.selectedSegmentIndex == 0 ? "" : "Name"
        nameHeightAnchor?.isActive = true
        
        //change seperator after name
        seperatorAfterNameHeightAnchor?.isActive = false
        seperatorAfterNameHeightAnchor = seperatorAfterName.heightAnchor.constraint(equalToConstant: loginRegisterSegementController.selectedSegmentIndex == 0 ? 0 : 1)
        seperatorAfterNameHeightAnchor?.isActive = true
        
        // change email input
        emailHeightAnchor?.isActive = false
        emailHeightAnchor = emailInput.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegementController.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailHeightAnchor?.isActive = true
        
        // change password input
        passwordHeightAnchor?.isActive = false
        passwordHeightAnchor = passwordInput.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegementController.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordHeightAnchor?.isActive = true
    }

    lazy var profile: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "blank")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImage)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = MyColor.mainRed
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = MyColor.mainRed
        button.titleLabel?.font = UIFont(name: "SourceCodePro-Regular", size: 26)
        button.setTitleColor(MyColor.mainBlack, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle("REGISTER", for: .normal)
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    lazy var customFacebookLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.tintColor = .white
        button.setTitle("f  LOGIN WITH FACEBOOK", for: .normal)
        button.titleLabel?.font = UIFont(name: "SourceCodePro-Semibold", size: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleFacebookLogin), for: .touchUpInside)
        return button
    }()
    
        let nameInput: UITextField = {
        let input = UITextField()
        input.placeholder = "Name:"
        input.textAlignment = .left
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    let seperatorAfterName: UIView = {
        let view = UIView()
        view.backgroundColor = MyColor.mainBlack
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let emailInput: UITextField = {
        let input = UITextField()
        input.placeholder = "Email"
        input.textAlignment = .left
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    let seperatorAfterEmail: UIView = {
        let view = UIView()
        view.backgroundColor = MyColor.mainBlack
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let passwordInput: UITextField = {
        let input = UITextField()
        input.placeholder = "Password"
        input.textAlignment = .left
        input.isSecureTextEntry = true
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()

    func setupSegementedView(){
        view.addSubview(profile)
        view.addSubview(loginRegisterSegementController)
        
        // profile image
        profile.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profile.heightAnchor.constraint(equalToConstant:120).isActive = true
        profile.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -210).isActive = true
        profile.bottomAnchor.constraint(equalTo: loginRegisterSegementController.topAnchor, constant: -12).isActive = true
        
        // login register segemented
        loginRegisterSegementController.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegementController.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegementController.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        loginRegisterSegementController.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
    }
    func setUpView(){
        
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(customFacebookLoginButton)
        
        // inputs container
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHightAnchor?.isActive = true
        
        // login register button
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 6).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
 
        customFacebookLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customFacebookLoginButton.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 8).isActive = true
        customFacebookLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        customFacebookLoginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func setUpInputsView(){
        inputsContainerView.addSubview(nameInput)
        inputsContainerView.addSubview(emailInput)
        inputsContainerView.addSubview(passwordInput)
        inputsContainerView.addSubview(seperatorAfterName)
        inputsContainerView.addSubview(seperatorAfterEmail)
        
        // name
        nameHeightAnchor =  nameInput.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameHeightAnchor?.isActive = true
        nameInput.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -6).isActive = true
        nameInput.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        nameInput.topAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -3).isActive = true
        
        // line after name
        seperatorAfterNameHeightAnchor = seperatorAfterName.heightAnchor.constraint(equalToConstant: 1)
        seperatorAfterNameHeightAnchor?.isActive = true
        seperatorAfterName.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -6).isActive = true
        seperatorAfterName.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        seperatorAfterName.topAnchor.constraint(equalTo: nameInput.bottomAnchor, constant: 2).isActive = true
        
        // email
        emailHeightAnchor =  emailInput.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailHeightAnchor?.isActive = true
        emailInput.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -6).isActive = true
        emailInput.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        emailInput.topAnchor.constraint(equalTo: seperatorAfterName.bottomAnchor, constant: 2).isActive = true
        
        // line after email
        seperatorAfterEmail.heightAnchor.constraint(equalToConstant: 1).isActive = true
        seperatorAfterEmail.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -6).isActive = true
        seperatorAfterEmail.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        seperatorAfterEmail.topAnchor.constraint(equalTo: emailInput.bottomAnchor, constant: 2).isActive = true
        
        // password
        passwordHeightAnchor =  passwordInput.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordHeightAnchor?.isActive = true
        passwordInput.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -6).isActive = true
        passwordInput.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        passwordInput.topAnchor.constraint(equalTo: seperatorAfterEmail.bottomAnchor, constant: 2).isActive = true

    }
    
}
