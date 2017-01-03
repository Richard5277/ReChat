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
            
    var momentPosterImage: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = .purple
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    var momentPosterName: UILabel = {
        let label = UILabel()
        label.textColor = MyColor.textWhite
        label.font = UIFont(name: "SourceCodePro-Regular", size: 16)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var momentImage: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = .purple
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
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
    
}




















