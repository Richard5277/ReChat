//
//  MomentView.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-12-07.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

class MomentView: UIViewController {
 
    var user: User?
    
    let headerImage: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = MyColor.mainRed
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = UIFont(name: "SourceCodePro-Regular", size: 20)
        label.textColor = MyColor.textWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var profileImage: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = .yellow
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    let momentContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    let momentPosterImage: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    let momentPosterName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let momentImageContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    lazy var momentImageOne: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        
        return imageview
    }()
    lazy var momentImageTwo: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    lazy var momentImageThree: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    lazy var momentImageFour: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = MyColor.mainBlack
        self.title = "Moments"
        nameLabel.text = user?.name
        setUpView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchUser()
    }
    
    func fetchUser(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{ return }
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapShot) in
            print(snapShot)
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
        self.nameLabel.text = user.name!
    }
    
    func setUpView(){
        view.addSubview(headerImage)
        headerImage.snp.makeConstraints { (headerImage) in
            headerImage.width.equalToSuperview()
            headerImage.centerX.equalToSuperview()
            headerImage.top.equalToSuperview()
            headerImage.height.equalTo(200)
        }
        headerImage.addSubview(profileImage)
        profileImage.snp.makeConstraints { (profileImage) in
            profileImage.bottom.equalToSuperview().offset(20)
            profileImage.right.equalToSuperview().offset(-20)
            profileImage.width.equalTo(80)
            profileImage.height.equalTo(80)
        }
        headerImage.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (nameLabel) in
            nameLabel.centerX.equalToSuperview()
            nameLabel.bottom.equalToSuperview().offset(-6)
            nameLabel.width.equalTo(120)
            nameLabel.height.equalTo(50)
        }
    }
    
}










