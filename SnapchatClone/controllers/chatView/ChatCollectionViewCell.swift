//
//  ChatCollectionViewCell.swift
//  SnapchatClone
//
//  Created by Alsharif Abdullah M on 3/16/19.
//  Copyright © 2019 Alsharif Abdullah M. All rights reserved.
//

import UIKit

class ChatCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var cellStatusImage: UIImageView!
    @IBOutlet weak var timeRecived: UILabel!
    
    var pan: UIPanGestureRecognizer!
    var deleteLabel1: UILabel!
    var deleteLabel2: UILabel!


    
    lazy var mainView: ViewController = {
        return ViewController()
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (pan.state == UIGestureRecognizer.State.changed) {
            let p: CGPoint = pan.translation(in: self)

            if p.x > 1 {
                let width = self.contentView.frame.width
                let height = self.contentView.frame.height
                self.contentView.frame = CGRect(x: p.x,y: 0, width: width, height: height);
                let settingsVC = DiscoverViewController()
                settingsVC.view.frame = CGRect(x: p.x - deleteLabel1.frame.size.width-10, y: 0, width: 100, height: height)
            }
        }
        
    }
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        if pan.state == UIGestureRecognizer.State.began {

        } else if pan.state == UIGestureRecognizer.State.changed {
            self.setNeedsLayout()
        } else {
            if abs(pan.velocity(in: self).x) > 500 {
                let collectionView: UICollectionView = self.superview as! UICollectionView
                let indexPath: IndexPath = collectionView.indexPathForItem(at: self.center)!
                collectionView.delegate?.collectionView!(collectionView, performAction: #selector(onPan(_:)), forItemAt: indexPath, withSender: nil)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                })
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {

        deleteLabel1 = UILabel()
        deleteLabel1.text = "delete"
        deleteLabel1.textColor = UIColor.red
        self.insertSubview(deleteLabel1, belowSubview: self.contentView)
        
        deleteLabel2 = UILabel()
        deleteLabel2.text = "delete"
        deleteLabel2.textColor = UIColor.red
        self.insertSubview(deleteLabel2, belowSubview: self.contentView)
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(onPan))
        pan.delegate = self
        self.addGestureRecognizer(pan)
    }

}
