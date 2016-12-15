//
//  Moment.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-12-11.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit
import Firebase

class Moment: NSObject {
    
    var fromId: String?
    var fromName: String?
    var imageUrl: String?
    
    // MARK: preventing fetal error when adding new property ot Message, hard to debug, in this way, whenever u include new property inside Message, it has to be initialized
    init(dictionary: [String: AnyObject]) {
        super.init()
        fromId = dictionary["fromId"] as? String
        fromName = dictionary["fromName"] as? String
        imageUrl = dictionary["imageUrl"] as? String
    }
}
