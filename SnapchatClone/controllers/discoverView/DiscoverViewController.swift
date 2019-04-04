//
//  DiscoverViewController.swift
//  SnapchatClone
//
//  Created by Alsharif Abdullah M on 3/14/19.
//  Copyright © 2019 Alsharif Abdullah M. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {

     var collectionViewHeight: NSLayoutConstraint?

    lazy var collectionView: UICollectionView = {
        let collection = UI.instance.collectionView
        collection.delegate = self
        collection.dataSource = self

        collection.register(UINib(nibName: "FriendsCollectionView", bundle: nil), forCellWithReuseIdentifier: "FriendsCollectionView")
        collection.register(UINib(nibName: "DiscoverNib", bundle: nil), forCellWithReuseIdentifier: "DiscoverCollectionViewCell")
        collection.clipsToBounds = true
        collection.layer.cornerRadius = 20
        collection.isScrollEnabled = false
        collection.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        collection.backgroundColor = .white
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .vertical
        collection.collectionViewLayout = layout

        return collection
        }()
    
    lazy var controllers: [UIViewController] = {
        return [DiscoverViewController()]
    }()
   
    var discoverStories: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.65, green:0.12, blue:0.98, alpha:1.0)
        view.addSubview(collectionView)
        collectionView.frame = view.frame
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionView.frame.size.height = height
     

    }
}

extension DiscoverViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let maximumOffset = scrollView.contentSize.height  - scrollView.frame.width
//        let currentOffset = scrollView.contentOffset.y
//        let offsetPercentage = currentOffset / maximumOffset
//        let sharesCount = CGFloat(100 - 1)
//        var currentShareIndex: CGFloat = 0
//        let colorPercentage = (offsetPercentage - currentShareIndex / sharesCount) * sharesCount
//            print(colorPercentage)
//              UIApplication.shared.statusBarView!.backgroundColor =  UIColor.clear
      
        
    }
}

extension DiscoverViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 100
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsCollectionView", for: indexPath) as? FriendsCollectionView else {return UICollectionViewCell()}
            
            
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCollectionViewCell", for: indexPath) as? DiscoverCollectionViewCell else {return UICollectionViewCell()}
        cell.layer.cornerRadius = 5

            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: self.view.frame.width, height: 127)
        }
        return CGSize(width: self.view.frame.width - 200, height: 280)
    }
    

}
