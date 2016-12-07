//
//  MomentView.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-12-07.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit
import Firebase

class MomentView: UIViewController {
 
    var currentUser: User?
    
    let headerImage: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    lazy var profileImage: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        let imageUrl = self.currentUser?.profileImageUrl
        imageview.loadImageUsingCacheWithUrlString(urlString: imageUrl!)
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
        let imageUrl = self.currentUser?.profileImageUrl
        imageview.loadImageUsingCacheWithUrlString(urlString: imageUrl!)
        return imageview
    }()
    lazy var momentImageTwo: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        let imageUrl = self.currentUser?.profileImageUrl
        imageview.loadImageUsingCacheWithUrlString(urlString: imageUrl!)
        return imageview
    }()
    lazy var momentImageThree: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        let imageUrl = self.currentUser?.profileImageUrl
        imageview.loadImageUsingCacheWithUrlString(urlString: imageUrl!)
        return imageview
    }()
    lazy var momentImageFour: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        let imageUrl = self.currentUser?.profileImageUrl
        imageview.loadImageUsingCacheWithUrlString(urlString: imageUrl!)
        return imageview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = MyColor.mainBlack
        self.title = "Moments"
        setUpUser()
    }

    func setUpUser(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{ return }
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapShot) in
            if let dictionary = snapShot.value as? [String: AnyObject] {
//                let user = User()
//                user.setValuesForKeys(dictionary)
//                self.currentUser = user
                self.currentUser?.setValuesForKeys(dictionary)
            }
        }, withCancel: nil)

    }
    
}










