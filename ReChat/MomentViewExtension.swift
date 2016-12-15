//
//  MomentViewExtension.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-12-08.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit
import Firebase

extension MomentView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func postMoment(){
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
        handleImageSelectedForInto(info as [String : AnyObject])
        
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
            // save image to firestorage
            uploadImageToFirebaseStorage(selectedImage)
            
        }
    }

    private func uploadImageToFirebaseStorage(_ image: UIImage){
        let imageName = NSUUID().uuidString as String
        let storageRef = FIRStorage.storage().reference().child("moment_images").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.6){
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("Faild to Upload Image: \(error)")
                    return
                }
                // MARK: Save moment to firebase
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    let ref = FIRDatabase.database().reference().child("moments")
                    let fromId = FIRAuth.auth()!.currentUser!.uid
                    let fromName = self.user!.name! as String
                    let properties: [String : Any] = ["imageUrl": imageUrl, "fromId": fromId, "fromName": fromName]
                    let childRef = ref.childByAutoId()
                    
                    childRef.updateChildValues(properties, withCompletionBlock: { (error, ref) in
                        if error != nil {
                            print("error: \(error)")
                        }
                        print("Save Moment Success")
                        
                    })
                }
            })
        }
    }

}
