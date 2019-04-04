//
//  ChatViewController.swift
//  SnapchatClone
//
//  Created by Alsharif Abdullah M on 3/16/19.
//  Copyright © 2019 Alsharif Abdullah M. All rights reserved.
//

import UIKit
import AVFoundation

class ChatViewController: UIViewController, UINavigationControllerDelegate {

    var chatInfoArray: [chatInfo] = []
    var chatInfoNSArray = NSArray()

    var captureSession : AVCaptureSession?
    var stillImageOutput : AVCaptureStillImageOutput?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var currentIndexPath: IndexPath?

    var delegate: didSelectChatDelegate?

    lazy var insideView: InsideChatViewController = {
        return InsideChatViewController()
    }()

    lazy var mainView: ViewController = {
        return ViewController()
    }()
    lazy var collectionView: UICollectionView = {
        let collection = UI.instance.collectionView2
        collection.delegate = self
        collection.dataSource = self
        collection.isUserInteractionEnabled = false 
        collection.translatesAutoresizingMaskIntoConstraints = false 
        collection.register(UINib(nibName: "ChatNib", bundle: nil), forCellWithReuseIdentifier: "ChatCollectionViewCell")
        collection.clipsToBounds = true
        collection.layer.cornerRadius = 20
        collection.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        collection.backgroundColor = .white
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collection.collectionViewLayout = layout
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.00, green:0.64, blue:1.00, alpha:1.0)
        view.addSubview(collectionView)
        view.pinEdges(to: collectionView)
        getDataFromChatInfo()
        ViewController().navigationController?.delegate = self
    }

    func getDataFromChatInfo(){
        for info in chatData {
            self.chatInfoNSArray = info["data"]! as NSArray
        }
        for data in self.chatInfoNSArray {
            let info = data as! [String: String]
            let userName = info["userName"]
            let userThumb = info["userImage"]
            let status = info["statusImage"]
            let recivedTime = info["recivedTime"]
            self.chatInfoArray.append(chatInfo(userName: userName, userThumb: userThumb, status: status,recivedTime:recivedTime))
        }
         UI.instance.collectionView.reloadData()
    }
    
    private var customInteractor : CustomInteractor?
    private var selectedFrame : CGRect?
    
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let ci = customInteractor else { return nil }
        return ci.transitionInProgress ? customInteractor : nil
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let frame = self.selectedFrame else { return nil }
 //       guard let song = self.selectedSong else { return nil }
        
        switch operation {
        case .push:
            self.customInteractor = CustomInteractor(attachTo: toVC)
            return CustomAnimator(duration: TimeInterval(UINavigationController.hideShowBarDuration), isPresenting: true, originFrame: frame)
        default:
            return CustomAnimator(duration: TimeInterval(UINavigationController.hideShowBarDuration), isPresenting: false, originFrame: frame)
        }
    }
    
}
extension ChatViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatInfoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatCollectionViewCell", for: indexPath) as? ChatCollectionViewCell else {return UICollectionViewCell()}
        let info = chatInfoArray[indexPath.row]
        cell.userName.text = info.userName
        cell.userImage.image = UIImage(named: info.userThumb!)
        cell.cellStatusImage.image = UIImage(named: info.status!)
        cell.timeRecived.text = info.recivedTime
      
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width , height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("O")
        delegate?.push(view: self)
//        mainView.navigationController?.pushViewController(DiscoverViewController(), animated: true)
//        let theAttributes:UICollectionViewLayoutAttributes! = collectionView.layoutAttributesForItem(at: indexPath)
//        selectedFrame = collectionView.convert(theAttributes.frame, to: collectionView.superview)
//        self.mainView.navigationController?.pushViewController(DiscoverViewController(), animated: true)
    }
}
protocol didSelectChatDelegate {
    func push(view: ChatViewController)
}
