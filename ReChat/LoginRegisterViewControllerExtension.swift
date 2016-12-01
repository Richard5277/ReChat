//
//  LoginRegisterViewControllerExtension.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-11-27.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit
import Firebase

extension LoginRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleSelectProfileImage(){
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
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        }else if let origionalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = origionalImage
        }
        if let selectedImage = selectedImageFromPicker {
            profile.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func handleRegister(){
        guard let email = emailInput.text, let password = passwordInput.text, let name = nameInput.text else {
            print("Unvalid User")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
            if error != nil {
                print(error?.localizedDescription ?? "Error")
            }
            
            guard let uid = user?.uid else{
                print("Unvalid User")
                return
            }
            
            // successfully authentiated user
            // store image into firStorage
            let imageName = NSUUID().uuidString
            let storage = FIRStorage.storage().reference().child("profileImages").child("\(imageName).jpg")
            
            // comprestion images, small size, very important, increase speed, save data
            if let profileImage = self.profile.image , let uploadData = UIImageJPEGRepresentation(profileImage, 0.1){
                // if let uploadData = UIImagePNGRepresentation(self.profile.image!){  // this save the full image
                // unsafe to force wrape a image
                storage.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil{
                        print(error ?? "Uploading Image to Storage Failed")
                        return
                    }
                    
                    if let profileImageUrl =  metadata?.downloadURL()?.absoluteString{
                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                    }
                    
                })
            }
        })
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]){
        let singleRef = self.ref.child("users").child(uid)
        singleRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil{
                print(err ?? "WRONG")
                return
            }else {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
}

