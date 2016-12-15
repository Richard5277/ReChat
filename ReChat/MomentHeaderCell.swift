//
//  MomentHeaderCell.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-12-14.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit

class MomentHeaderCell: UICollectionViewCell {
    
    var user: User?
    
    let headerImage: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "leaf")
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
        imageview.backgroundColor = .clear
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        nameLabel.text = user?.name
        
        addSubview(headerImage)
        headerImage.snp.makeConstraints { (headerImage) in
            headerImage.width.equalToSuperview()
            headerImage.height.equalTo(120)
            headerImage.centerX.equalToSuperview()
            headerImage.top.equalToSuperview()
        }
        
        headerImage.addSubview(profileImage)
        profileImage.snp.makeConstraints { (profileImage) in
            profileImage.right.equalToSuperview().offset(-12)
            profileImage.bottom.equalToSuperview().offset(12)
            profileImage.width.equalTo(50)
            profileImage.height.equalTo(50)
        }
        
        headerImage.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (nameLabel) in
            nameLabel.centerX.equalToSuperview()
            nameLabel.bottom.equalToSuperview().offset(-12)
            nameLabel.width.equalTo(160)
            nameLabel.height.equalTo(35)
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
