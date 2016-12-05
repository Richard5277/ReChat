//
//  ChatViewController.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-11-22.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    var cellId = "cellId"
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
            observeMessages()
        }
    }

    var messages = [Message]()
    
    func observeMessages(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid, let toId = user?.id else {return}
        
        let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(uid).child(toId)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
                let messageId = snapshot.key
                let messagesRef = FIRDatabase.database().reference().child("messages").child(messageId)
                messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                    
                    // by using a dictionary initializer, make the data transfer safer
                    self.messages.append(Message(dictionary: dictionary))
                    // MARK: *! Important, passing the data to the controller, and dispatch the main queue
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                        // scroll the view to the last message
                        let indexPath = NSIndexPath(item: self.messages.count - 1, section: 0)
                        self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
                    }
                }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.contentInset = UIEdgeInsetsMake(8, 0, 8, 0)
        collectionView?.keyboardDismissMode = .interactive
        
        collectionView?.backgroundColor = MyColor.mainBlack
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        setUpKeyboardObserver()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView?.reloadData()
    }
    
    // MARK: Seperate View to Another Class
    lazy var inputContainerView: ChatInputContainerView = {
        let chatInputContainer = ChatInputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        chatInputContainer.chatViewController = self
        return chatInputContainer
    }()
    
    var containerViewBottomAnchor: NSLayoutConstraint?

    // MARK: Apple Default top-keyboard
    override var inputAccessoryView: UIView {
        get {
            return inputContainerView // Have to set up the view outside to keep the textfiled delegate functional
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let message = messages[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        // Transfer the TapZoom function
        cell.chatViewController = self
        cell.message = message
        
        if let text = message.message {
            cell.textView.text = text
            cell.textView.isHidden = false
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: text).width + 32
        } else if message.imageUrl != nil {
            //If chat is image
            cell.textView.isHidden = true
            cell.bubbleWidthAnchor?.constant = 200
        }
        
        cell.playButton.isHidden = (message.videoUrl == nil)
        
        // change the bubble by seperating sending msg and receiving msg
        setUpCell(message: message, cell: cell)
        return cell
    }
    
    // MARK: Custom Image TapZoomIn Function    
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    func performZoomInForStartingImageView(startingImageView: UIImageView){
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        let zoomingImageview = UIImageView(frame: startingFrame!)
        zoomingImageview.backgroundColor = .clear
        zoomingImageview.isUserInteractionEnabled = true
        zoomingImageview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow {
            self.blackBackgroundView = UIView(frame: keyWindow.frame)
            self.blackBackgroundView?.backgroundColor = .black
            self.blackBackgroundView?.alpha = 0
            keyWindow.addSubview(self.blackBackgroundView!)
            keyWindow.addSubview(zoomingImageview)
  
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
                self.blackBackgroundView?.alpha = 1
                self.inputContainerView.alpha = 0
                zoomingImageview.image = startingImageView.image
                let height = (self.startingFrame?.height)! * keyWindow.frame.width / (self.startingFrame?.width)!
                let width = (self.startingFrame?.width)! * keyWindow.frame.height / (self.startingFrame?.height)!
                if height > keyWindow.frame.height {
                    zoomingImageview.frame = CGRect(x: 0, y: 0, width: width, height: keyWindow.frame.height)
                }else{
                    zoomingImageview.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)

                }
                zoomingImageview.center = keyWindow.center
            }, completion: nil)
        }
        
    }
    
    func handleZoomOut(tapGesture: UITapGestureRecognizer){
        if let zoomoutImageView = tapGesture.view {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomoutImageView.frame = self.startingFrame!
                zoomoutImageView.layer.cornerRadius = 16
                zoomoutImageView.layer.masksToBounds = true
                zoomoutImageView.alpha = 0
                self.inputContainerView.alpha = 1
                self.blackBackgroundView?.alpha = 0
            }, completion: { (completed: Bool) in
                zoomoutImageView.removeFromSuperview()
            })
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let message = messages[indexPath.row]
        
        // how to get the text auto-height
        var cellHeight: CGFloat = 80
        if let text = message.message {
            cellHeight = estimateFrameForText(text: text).height + 20
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
            cellHeight = CGFloat(imageHeight / imageWidth * 200)
        }
        
        // MARK: Fixing the Rotaion Problem
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: cellHeight)
    }
    
    private func setUpCell(message: Message, cell: ChatMessageCell){
        
        if let messageImageUrl = message.imageUrl {
            cell.bubbleView.backgroundColor = .clear
            cell.messageImageView.isHidden = false
            cell.messageImageView.loadImageUsingCacheWithUrlString(urlString: messageImageUrl)
        }else{
            cell.messageImageView.isHidden = true
        }
        
        if message.fromId == FIRAuth.auth()?.currentUser?.uid {
            
            // MARK:Sending message, all Right
            let ref = FIRDatabase.database().reference().child("users").child(message.fromId!)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                let myImageUrl = dictionary["profileImageUrl"] as? String
                cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: myImageUrl!)
            }, withCancel: nil)
            cell.textView.textColor = .white
            cell.bubbleView.backgroundColor = ChatMessageCell.chatBubbleBlueColor
            cell.profileImageLeftAnchor?.isActive = false
            cell.bubbleLeftAnchor?.isActive = false
            cell.profileImageRightAnchor?.isActive = true
            cell.bubbleRightAnchor?.isActive = true
        } else {
            
            // MARK:Receiving message, All Left
            cell.textView.textColor = .black
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240, a: 1)
            
            cell.bubbleRightAnchor?.isActive = false
            cell.profileImageRightAnchor?.isActive = false
            cell.bubbleLeftAnchor?.isActive = true
            cell.profileImageLeftAnchor?.isActive = true
            if let chatpartnerProfileImagUrl = self.user?.profileImageUrl {
                cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: chatpartnerProfileImagUrl)
            }
        }
    }

    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
}
