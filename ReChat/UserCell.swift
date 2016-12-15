//
//  UserCell.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-11-18.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    var message: Message?{
        didSet {
            
            setupNameAndProfileImage()
            
            if message?.message != nil{
                detailTextLabel?.text = message?.message
            }else{
                detailTextLabel?.text = "[image]"
            }
            
            
            if let seconds = message?.time?.doubleValue {
                let timestamp = NSDate(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                timeLabel.text = dateFormatter.string(from: timestamp as Date)
                
            }

        }
    }
    
    private func setupNameAndProfileImage(){
        
        if let chatId = message?.checkPartnerId() {
            let ref = FIRDatabase.database().reference().child("users").child(chatId)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.textLabel?.text = dictionary["name"] as? String
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                        self.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
                    }
                }
            }, withCancel: nil)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 60, y: textLabel!.frame.origin.y - 3, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 60, y: detailTextLabel!.frame.origin.y + 3, width: self.frame.width - 90, height: detailTextLabel!.frame.height)
        addSubview(profileImageView)
        addSubview(timeLabel)
        
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 48).isActive = true

    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = MyColor.textWhite
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        backgroundColor = MyColor.mainBlack
        textLabel?.textColor = MyColor.textWhite
        detailTextLabel?.textColor = MyColor.textWhite
           }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
