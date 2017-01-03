//
//  SettingView.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-12-05.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

class SettingView: UIViewController {
    var user: User?
    
    let rechatIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "rechat")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let profileContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    let profileLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile Photo"
        label.textColor = MyColor.textWhite
        label.font = UIFont(name: "SourceCodePro-Regular", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .purple
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    lazy var changeProfileImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = MyColor.textWhite
        button.backgroundColor = UIColor(r: 255, g: 255, b: 255, a: 0.1)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Change", for: .normal)
        button.addTarget(self, action: #selector(changeProfielImageForCurrentUser), for: .touchUpInside)
        return button
    }()
    
    let nameContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = MyColor.textWhite
        label.font = UIFont(name: "SourceCodePro-Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let nameLabelContent: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = MyColor.textWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let genderContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    let genderLabel: UILabel = {
        let label = UILabel()
        label.text = "Gender"
        label.textColor = MyColor.textWhite
        label.font = UIFont(name: "SourceCodePro-Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let genderLabelContent: UILabel = {
        let label = UILabel()
        label.text = "Female"
        label.textAlignment = .right
        label.font = UIFont(name: "SourceCodePro-Regular", size: 16)
        label.textColor = MyColor.textWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let regionContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    let regionLabel: UILabel = {
        let label = UILabel()
        label.text = "Region"
        label.textColor = MyColor.textWhite
        label.font = UIFont(name: "SourceCodePro-Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let regionLabelContent: UILabel = {
        let label = UILabel()
        label.text = "Canada"
        label.textAlignment = .right
        label.textColor = MyColor.textWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    let separatorOne: UIView = {
        let separator = UIView()
        separator.backgroundColor = MyColor.mainRed
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    let separatorTwo: UIView = {
        let separator = UIView()
        separator.backgroundColor = MyColor.mainRed
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    let separatorThree: UIView = {
        let separator = UIView()
        separator.backgroundColor = MyColor.mainRed
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    let separatorFour: UIView = {
        let separator = UIView()
        separator.backgroundColor = MyColor.mainRed
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = MyColor.mainBlack
        self.title = "Setting"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchUser()
        setUpView()
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
    
    func setUpView(){
        
        let containerMargin: Int = 3
        let containerHeight: Int = 80
        let labelWidth: Int = 150
        let labelHeight: Int = 60
        let labelMargin: Int = 30
        
        // MARK: Profile Container
        view.addSubview(profileContainer)
        profileContainer.snp.makeConstraints { (profileContainer) in
            profileContainer.top.equalToSuperview().offset(8)
            profileContainer.centerX.equalToSuperview()
            profileContainer.width.equalToSuperview()
            profileContainer.height.equalTo(210)
        }
        profileContainer.addSubview(rechatIcon)
        rechatIcon.snp.makeConstraints { (rechatIcon) in
            rechatIcon.top.equalToSuperview().offset(80)
            rechatIcon.left.equalToSuperview().offset(20)
            rechatIcon.width.equalTo(100)
            rechatIcon.height.equalTo(40)
        }
        profileContainer.addSubview(profileLabel)
        profileLabel.snp.makeConstraints { (profileLabel) in
            profileLabel.left.equalToSuperview().offset(labelMargin)
            profileLabel.top.equalToSuperview().offset(130)
            profileLabel.width.equalTo(labelWidth)
            profileLabel.height.equalTo(labelHeight)
        }
        profileContainer.addSubview(profileImage)
        profileImage.snp.makeConstraints { (profileImage) in
            profileImage.right.equalToSuperview().offset(-labelMargin)
            profileImage.top.equalToSuperview().offset(80)
            profileImage.width.equalTo(80)
            profileImage.height.equalTo(80)
        }
        profileContainer.addSubview(changeProfileImageButton)
        changeProfileImageButton.snp.makeConstraints { (changeProfileImageButton) in
            changeProfileImageButton.top.equalTo(profileImage.snp.bottom).offset(12)
            changeProfileImageButton.centerX.equalTo(profileImage.snp.centerX)
            changeProfileImageButton.width.equalTo(70)
            changeProfileImageButton.height.equalTo(24)
        }
        profileContainer.addSubview(separatorOne)
        separatorOne.snp.makeConstraints { (separatorOne) in
            separatorOne.bottom.equalToSuperview()
            separatorOne.width.equalToSuperview().offset(-30)
            separatorOne.height.equalTo(1)
            separatorOne.centerX.equalToSuperview()
        }
        
        // MARK: Name
        view.addSubview(nameContainer)
        nameContainer.snp.makeConstraints { (nameContainer) in
            nameContainer.top.equalTo(profileContainer.snp.bottom).offset(8)
            nameContainer.width.equalToSuperview()
            nameContainer.height.equalTo(containerHeight)
            nameContainer.centerX.equalToSuperview()
        }
        nameContainer.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (nameLabel) in
            nameLabel.left.equalToSuperview().offset(labelMargin)
            nameLabel.centerY.equalToSuperview()
            nameLabel.width.equalTo(labelWidth)
            nameLabel.height.equalTo(labelHeight)
        }
        nameContainer.addSubview(nameLabelContent)
        nameLabelContent.snp.makeConstraints { (nameLabelContent) in
            nameLabelContent.right.equalToSuperview().offset(-labelMargin)
            nameLabelContent.centerY.equalToSuperview()
            nameLabelContent.width.equalTo(labelWidth)
            nameLabelContent.height.equalTo(labelHeight)
        }
        nameContainer.addSubview(separatorTwo)
        separatorTwo.snp.makeConstraints { (separatorTwo) in
            separatorTwo.bottom.equalToSuperview()
            separatorTwo.width.equalToSuperview().offset(-30)
            separatorTwo.height.equalTo(1)
            separatorTwo.centerX.equalToSuperview()
        }
        
        // MARK: Gender
        view.addSubview(genderContainer)
        genderContainer.snp.makeConstraints { (genderContainer) in
            genderContainer.top.equalTo(nameContainer.snp.bottom).offset(containerMargin)
            genderContainer.width.equalToSuperview()
            genderContainer.height.equalTo(containerHeight)
            genderContainer.centerX.equalToSuperview()
        }
        genderContainer.addSubview(genderLabel)
        genderLabel.snp.makeConstraints { (genderLabel) in
            genderLabel.left.equalToSuperview().offset(labelMargin)
            genderLabel.centerY.equalToSuperview()
            genderLabel.width.equalTo(labelWidth)
            genderLabel.height.equalTo(labelHeight)
        }
        genderContainer.addSubview(genderLabelContent)
        genderLabelContent.snp.makeConstraints { (genderLabelContent) in
            genderLabelContent.right.equalToSuperview().offset(-labelMargin)
            genderLabelContent.centerY.equalToSuperview()
            genderLabelContent.width.equalTo(labelWidth)
            genderLabelContent.height.equalTo(labelHeight)
        }
        genderContainer.addSubview(separatorThree)
        separatorThree.snp.makeConstraints { (separatorThree) in
            separatorThree.bottom.equalToSuperview()
            separatorThree.width.equalToSuperview().offset(-30)
            separatorThree.height.equalTo(1)
            separatorThree.centerX.equalToSuperview()
        }

        // MARK: Region
        view.addSubview(regionContainer)
        regionContainer.snp.makeConstraints { (regionContainer) in
            regionContainer.top.equalTo(genderContainer.snp.bottom).offset(containerMargin)
            regionContainer.width.equalToSuperview()
            regionContainer.height.equalTo(containerHeight)
            regionContainer.centerX.equalToSuperview()
        }

        regionContainer.addSubview(regionLabel)
        regionLabel.snp.makeConstraints { (regionLabel) in
            regionLabel.left.equalToSuperview().offset(labelMargin)
            regionLabel.centerY.equalToSuperview()
            regionLabel.width.equalTo(labelWidth)
            regionLabel.height.equalTo(labelHeight)
        }

        regionContainer.addSubview(regionLabelContent)
        regionLabelContent.snp.makeConstraints { (regionLabelContent) in
            regionLabelContent.right.equalToSuperview().offset(-labelMargin)
            regionLabelContent.centerY.equalToSuperview()
            regionLabelContent.width.equalTo(labelWidth)
            regionLabelContent.height.equalTo(labelHeight)
        }
        regionContainer.addSubview(separatorFour)
        separatorFour.snp.makeConstraints { (separatorFour) in
            separatorFour.bottom.equalToSuperview()
            separatorFour.width.equalToSuperview().offset(-30)
            separatorFour.height.equalTo(1)
            separatorFour.centerX.equalToSuperview()
        }

        // MARK: Logout Button
        view.addSubview(logOutButton)
        logOutButton.snp.makeConstraints { (logOutButton) in
            logOutButton.centerX.equalToSuperview()
            logOutButton.width.equalToSuperview().offset(-30)
            logOutButton.height.equalTo(60)
            logOutButton.bottom.equalToSuperview().offset(-66)
        }
    }
    func fetchUser(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{ return }
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapShot) in
            if let dictionary = snapShot.value as? [String: AnyObject] {
                let user = User()
                user.setValuesForKeys(dictionary)
                self.user = user
                self.setupViewWithUser(user: user)
            }
        }, withCancel: nil)
        
    }
    
    func setupViewWithUser(user: User){
        self.profileImage.loadImageUsingCacheWithUrlString(urlString: user.profileImageUrl!)
        self.nameLabelContent.text = user.name!
    }

}
