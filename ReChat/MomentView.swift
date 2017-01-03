//
//  MomentView.swift
//  ReChat
//
//  Created by Feihong Zhao on 2016-12-07.
//  Copyright © 2016 Feihong Zhao. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

class MomentView: UICollectionViewController,UICollectionViewDelegateFlowLayout  {
 
    var user: User?
    var momentHeaderCellId = "momentHeaderCellId"
    var momentCellId = "momentCellId"

    var moments = [Moment]()
    
    // MARK: Observe Moments from firebase
    func observeMoments(){
        
        let momentsRef = FIRDatabase.database().reference().child("moments")
        momentsRef.observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            self.moments.append(Moment(dictionary: dictionary))
//            self.collectionView?.reloadData()
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
//                let indexPath = NSIndexPath(item: self.moments.count - 1, section: 0)
//                self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
            }
        }, withCancel: nil)
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        self.collectionView?.backgroundColor = MyColor.mainBlack
        collectionView?.alwaysBounceVertical = true
        collectionView?.contentInset = UIEdgeInsetsMake(0, 0, 60, 0)

        self.title = "Moments"
        let cameraImage = UIImage().resizeImage(image: UIImage(named: "camera")!, newWidth: 30)
        let rightBarButton = UIBarButtonItem(image: cameraImage, style: .plain, target: self, action: #selector(postMoment))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        // MARK: Change Collection View inside a viewController
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        collectionView?.register(Momentcell.self, forCellWithReuseIdentifier: momentCellId)
        collectionView?.register(MomentHeaderCell.self, forCellWithReuseIdentifier: momentHeaderCellId)
    }

    // Fetch User From Database
    func fetchUser(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{ return }
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapShot) in
            if let dictionary = snapShot.value as? [String: AnyObject] {
                let user = User()
                user.setValuesForKeys(dictionary)
                self.user = user
            }
        }, withCancel: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.observeMoments()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.moments.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // MARK: Adding Header Image to first cell
        if indexPath.row == 0 {
            let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: momentHeaderCellId, for: indexPath) as! MomentHeaderCell
            cell.nameLabel.text = user?.name
            cell.profileImage.loadImageUsingCacheWithUrlString(urlString: (user?.profileImageUrl)!)
            return cell
        } else {
            let moment = moments[indexPath.row]
            let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: momentCellId, for: indexPath) as! Momentcell
            cell.momentPosterName.text = moment.fromName
            cell.momentImage.loadImageUsingCacheWithUrlString(urlString: moment.imageUrl!)
            
            if let uid = moment.fromId {
                let ref = FIRDatabase.database().reference().child("users").child(uid)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    let dictionary = snapshot.value as! [String: AnyObject]
                    if let posterProfileImageUrl = dictionary["profileImageUrl"]{
                        cell.momentPosterImage.loadImageUsingCacheWithUrlString(urlString: posterProfileImageUrl as! String)
                    }
                }, withCancel: nil)
                
            }
            return cell
        }
        
    }
    
    // Change Cell Height for Two Different Collection Cell
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0 {
            let momentHeaderCellHeight = 130 as CGFloat
            return CGSize(width: (self.collectionView?.bounds.size.width)!, height: momentHeaderCellHeight)
        } else {
            let momentCellHeigth = 210 as CGFloat
            return CGSize(width: (self.collectionView?.bounds.size.width)!, height: momentCellHeigth)
        }
        
    }

}










