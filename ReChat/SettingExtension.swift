//
//  SettingExtension.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-12-15.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit
import Firebase

extension SettingView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func changeProfielImageForCurrentUser(_ user: User){
        self.user = user
        let imagePicker = UIImagePickerController()
        present(imagePicker, animated: true, completion: nil)
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Picker Cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        handleImageSelectedForInto(info as [String: AnyObject])
        dismiss(animated: true, completion: nil)
    }
    
    private func handleImageSelectedForInto(_ info: [String: AnyObject]){
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        }else if let origionalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = origionalImage
        }
        if let selectedImage = selectedImageFromPicker {
            
            self.profileImage.image = selectedImage
            changeUserProfileImage(selectedImage)
        }
    }
    private func changeUserProfileImage(_ image: UIImage){
        let imageName = NSUUID().uuidString as String
        let storageRef = FIRStorage.storage().reference().child("profileImages").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2){
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("Faild to Upload Image: \(error)")
                    return
                }
                // MARK: Save moment to firebase
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    if let uid = FIRAuth.auth()?.currentUser?.uid{
                        let ref = FIRDatabase.database().reference().child("users").child(uid)
                        // Update Image
                        ref.updateChildValues(["profileImageUrl": imageUrl])
                    }
                }
            })
        }
        
    }
}
