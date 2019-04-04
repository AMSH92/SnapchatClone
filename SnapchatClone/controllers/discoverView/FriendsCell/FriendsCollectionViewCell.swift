//
//  FriendsCollectionViewCell.swift
//  SnapchatClone
//
//  Created by Alsharif Abdullah M on 3/19/19.
//  Copyright © 2019 Alsharif Abdullah M. All rights reserved.
//

import UIKit

class FriendsCollectionView: UICollectionViewCell {
    var friendsStories: [chatInfo] = []
    var friendsInfoNSArray = NSArray()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "FriendsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FriendsCollectionViewCell")
        collectionView.clipsToBounds = true
        collectionView.backgroundColor = .white
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        getDataFromChatInfo()
    }
    func getDataFromChatInfo(){
        for f in chatData {
            self.friendsInfoNSArray = f["data"]! as NSArray
        }
        for data in self.friendsInfoNSArray {
            let info = data as! [String: String]
            let userName = info["userName"]
            let userThumb = info["userImage"]
            let status = info["statusImage"]
            let recivedTime = info["recivedTime"]
            self.friendsStories.append(chatInfo(userName: userName, userThumb: userThumb, status: status,recivedTime:recivedTime))
        }
        collectionView.reloadData()
    }
}
extension FriendsCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friendsStories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsCollectionViewCell", for: indexPath) as? FriendsCollectionViewCell else {return UICollectionViewCell()}
        let info = friendsStories[indexPath.row]
        cell.userName.text = info.userName
        cell.userImage.image = UIImage(named: info.userThumb!)

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 113, height: 125)
    }

}

class FriendsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib() {
        self.userImage.clipsToBounds = true
        self.userImage.layer.cornerRadius = self.userImage.frame.width / 2
        self.backView.layer.cornerRadius = self.backView.frame.width / 2
        self.backView.layer.borderColor = UIColor.purple.cgColor
        self.backView.layer.borderWidth = 3
    }
    
}
