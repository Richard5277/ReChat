//
//  Momentcell.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-12-08.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class Momentcell: UICollectionViewCell {
        
    var moment: Moment?
    var user : User?
    
    let momentPosterImage: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = .purple
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    let momentPosterName: UILabel = {
        let label = UILabel()
//        label.text = "Rich"
        label.textColor = MyColor.textWhite
        label.font = UIFont(name: "SourceCodePro-Regular", size: 16)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let momentImage: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = .purple
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        momentPosterName.text = moment?.fromName
        fetchUserProfileImage()
        
        addSubview(momentPosterImage)
        momentPosterImage.snp.makeConstraints { (momentPosterImage) in
            momentPosterImage.left.equalToSuperview().offset(12)
            momentPosterImage.top.equalToSuperview().offset(12)
            momentPosterImage.width.equalTo(50)
            momentPosterImage.height.equalTo(50)
        }
        
        addSubview(momentPosterName)
        momentPosterName.snp.makeConstraints { (momentPosterName) in
            momentPosterName.left.equalTo(momentPosterImage.snp.right).offset(12)
            momentPosterName.top.equalToSuperview().offset(12)
            momentPosterName.right.equalToSuperview().offset(-12)
            momentPosterName.height.equalTo(24)
        }
        
        addSubview(momentImage)
        momentImage.snp.makeConstraints { (momentImage) in
            momentImage.left.equalToSuperview().offset(74)
            momentImage.right.equalToSuperview().offset(-12)
            momentImage.top.equalToSuperview().offset(48)
            momentImage.height.equalTo(160)
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetchUserProfileImage(){
        guard let uid = moment?.fromId else{ return }
        let ref = FIRDatabase.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            let dictionary = snapshot.value as! [String: AnyObject]
            self.user?.setValuesForKeys(dictionary)
            if let url = self.user?.profileImageUrl {
                self.momentPosterImage.loadImageUsingCacheWithUrlString(urlString: url)
            }
        }, withCancel: nil)
    }
    
    // add animation to 
}




















