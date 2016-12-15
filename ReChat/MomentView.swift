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
            self.collectionView?.reloadData()
        }, withCancel: nil)
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        self.collectionView?.backgroundColor = MyColor.mainBlack
        self.title = "Moments"
        let cameraImage = UIImage().resizeImage(image: UIImage(named: "camera")!, newWidth: 30)
        let rightBarButton = UIBarButtonItem(image: cameraImage, style: .plain, target: self, action: #selector(postMoment))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        // MARK: Change Collection View inside a viewController
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        collectionView?.register(Momentcell.self, forCellWithReuseIdentifier: momentCellId)
        collectionView?.register(MomentHeaderCell.self, forCellWithReuseIdentifier: momentHeaderCellId)
        
        collectionView?.contentInset = UIEdgeInsetsMake(8, 0, 8, 0)
    }

    
    func fetchUser(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{ return }
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapShot) in
            if let dictionary = snapShot.value as? [String: AnyObject] {
                let user = User()
                user.setValuesForKeys(dictionary)
                self.user = user
                self.observeMoments()
            }
        }, withCancel: nil)

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.moments.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        // MARK: Adding Header Image to first cell
        if indexPath.row == 0 {
            cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: momentHeaderCellId, for: indexPath) as! MomentHeaderCell
            cell.setValue(self.user, forKey: "user")
        } else {
            let moment = moments[indexPath.row]
            cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: momentCellId, for: indexPath) as! Momentcell
            cell.setValue(moment, forKey: "moment")
            cell.setValue(self.user, forKey: "user")
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let momentCellHeigth = 210 as CGFloat
        return CGSize(width: (self.collectionView?.bounds.size.width)!, height: momentCellHeigth)
    }

}










