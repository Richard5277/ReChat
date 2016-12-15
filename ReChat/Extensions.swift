//
//  Extensions.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-11-21.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>() // <NSString, UIImage>

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String){
        self.image = nil // prevent the flashing of loading image
        
        // check cache for image first
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            
            self.image = cacheImage
            return
        }else {
            // otherwise, download image
            let url = URL(string: urlString)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil{
                    print(error ?? "Image Download Error")
                    return
                }
                DispatchQueue.main.async {
                    
                    if let downloadedImage = UIImage(data: data!){
                        imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                        self.image = downloadedImage
                    }
                }
            }).resume()
        }
 
    }
}

extension UIImage {
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

}

extension UIColor{
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
}

struct MyColor {
    static var mainRed: UIColor = UIColor(r: 168, g: 29, b: 32, a: 1)
    static var mainBlack: UIColor = UIColor(r: 0, g: 0, b: 0, a: 1)
    static var textWhite: UIColor = UIColor(r: 255, g: 255, b: 255, a: 1)
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

