//
//  ChatViewControllerExtension.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-11-27.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleSendImage(){
        let imagePicker = UIImagePickerController()
        present(imagePicker, animated: true, completion: nil)
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Picker Cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? NSURL{
            // MARK: Process Chat Video
            handleVideoSelectedForUrl(videoUrl)
        }else{
            // MARK: Process Chat Image
            handleImageSelectedForInto(info as [String : AnyObject])
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func handleVideoSelectedForUrl(_ videoUrl: NSURL){
        let fileName = NSUUID().uuidString + ".mov"
        let uploadTask = FIRStorage.storage().reference().child("message_videos").child(fileName).putFile(videoUrl as URL, metadata: nil, completion: { (metadata, error) in
            if error != nil{
                print("Uploading Video Failed")
                return
            }
            if let storageUrl = metadata?.downloadURL()?.absoluteString{
                // MARK: Send Video to Chat
                if let thumbnailImage = self.thumbnailImageForVideoFielUrl(videoUrl){
                    // Add thumbnailImage to storage
                    self.sendVideoWithVideoProperties(storageUrl, videoUrl: videoUrl, thumbnailImage: thumbnailImage)
                }
            }
        })
        
        uploadTask.observe(.progress, handler: {(snapshot) in
            // MARK: Improve - Progress Bar
            if let completedUnitCount =  snapshot.progress?.completedUnitCount {
                self.navigationItem.title = String(completedUnitCount)
            }
        })
            
        uploadTask.observe(.success, handler: {(snapshot) in
            self.navigationItem.title = self.user?.name
        })
    }
    
    private func sendVideoWithVideoProperties(_ storageUrl: String, videoUrl: NSURL, thumbnailImage: UIImage){
        if let thumbnailImage = self.thumbnailImageForVideoFielUrl(videoUrl){
            // Add thumbnailImage to storage
            let imageName = NSUUID().uuidString as String
            let storageRef = FIRStorage.storage().reference().child("message_videos").child("message_videos_thumbnailImage").child(imageName)
            
            if let uploadData = UIImageJPEGRepresentation(thumbnailImage, 0.2){
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print("Faild to Upload Image: \(error)")
                        return
                    }
                    
                    if let imageUrl = metadata?.downloadURL()?.absoluteString {
                        let properties: [String : Any] = ["videoUrl": storageUrl, "imageUrl": imageUrl, "imageWidth": thumbnailImage.size.width, "imageHeight": thumbnailImage.size.height]
                        self.sendMessageWithProperties(properties: properties as [String : AnyObject])
                    }
                })
            }
        }
    }
    
    private func thumbnailImageForVideoFielUrl(_ videoFileUrl: NSURL) -> UIImage?{
        let asset = AVAsset(url: videoFileUrl as URL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        }catch let err{
            print(err)
        }
        return nil
    }
    
    private func handleImageSelectedForInto(_ info: [String: AnyObject]){
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        }else if let origionalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = origionalImage
        }
        if let selectedImage = selectedImageFromPicker {
            // send image
            uploadImageToFirebaseStorage(selectedImage, completion: {(imageUrl) in
                self.sendImageWithImageUrl(imageUrl, image: selectedImage)
            })
        }
    }
    
    private func uploadImageToFirebaseStorage(_ image: UIImage, completion: @escaping (_ imageUrl: String) -> ()){
        let imageName = NSUUID().uuidString as String
        let storageRef = FIRStorage.storage().reference().child("message_images").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2){
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("Faild to Upload Image: \(error)")
                    return
                }
                
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    completion(imageUrl)
                }
            })
        }
    }

    
    private func sendMessageWithProperties(properties: [String: AnyObject]){
        let ref = FIRDatabase.database().reference().child("messages")
        let toId = user!.id!
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let timestamp: NSNumber = NSNumber(integerLiteral: Int(NSDate().timeIntervalSince1970))
        
        let childRef = ref.childByAutoId()
        var values = ["toId": toId, "fromId": fromId, "time": timestamp] as [String : Any] // constant properties
        
        // MARK: Adding additional properties into values dictionary
        // key: $0, value: $1
        properties.forEach({values[$0] = $1})
        
        childRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil {
                print(error ?? "Sending Image Error")
                return
            }
            
            let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(fromId).child(toId)
            
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessageRef = FIRDatabase.database().reference().child("user-messages").child(toId).child(fromId)
            recipientUserMessageRef.updateChildValues([messageId: 1])
            self.inputContainerView.messageTextField.text = nil
        })
    }
    
    private func sendImageWithImageUrl(_ imageUrl: String, image: UIImage){
        let properties: [String : Any] = ["imageUrl": imageUrl, "imageWidth": image.size.width, "imageHeight": image.size.height]
        sendMessageWithProperties(properties: properties as [String : AnyObject])
        
    }
    
    func handelSendMessage() {
        let properties = ["message": inputContainerView.messageTextField.text!] as [String : Any]
        sendMessageWithProperties(properties: properties as [String : AnyObject])
    }

}

