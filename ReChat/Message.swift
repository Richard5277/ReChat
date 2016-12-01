//
//  Message.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-11-22.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var fromId: String?
    var toId: String?
    var message: String?
    var time: NSNumber?
    
    var imageUrl: String?
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    
    var videoUrl: String?
    
    func checkPartnerId() -> String? {
        
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
    }
    
    // MARK: preventing fetal error when adding new property ot Message, hard to debug, in this way, whenever u include new property inside Message, it has to be initialized
    init(dictionary: [String: AnyObject]) {
        super.init()
        fromId = dictionary["fromId"] as? String
        toId = dictionary["toId"] as? String
        message = dictionary["message"] as? String
        time = dictionary["time"] as? NSNumber
        imageUrl = dictionary["imageUrl"] as? String
        imageWidth = dictionary["imageWidth"] as? NSNumber
        imageHeight = dictionary["imageWidth"] as? NSNumber
        videoUrl = dictionary["videoUrl"] as? String
    }
}
