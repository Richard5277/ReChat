//
//  KeyboardAnimation.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-11-25.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit

extension ChatViewController {
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self) // MARK: Fix Memory Leak
    }
    
    func setUpKeyboardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardDidShow), name: .UIKeyboardDidShow, object: nil)
    }
    func handleKeyBoardDidShow(){
        if messages.count > 0 {
            let indexPath = NSIndexPath(item: messages.count - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
        }
    }
}
