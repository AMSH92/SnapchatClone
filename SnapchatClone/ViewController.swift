//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Alsharif Abdullah M on 3/14/19.
//  Copyright © 2019 Alsharif Abdullah M. All rights reserved.
//

import UIKit
import AVFoundation




class ViewController: UIViewController,CAAnimationDelegate {

    fileprivate var discoverConstraint: NSLayoutConstraint?
    fileprivate var chatConstraint: NSLayoutConstraint?
    fileprivate var captureButtonTop: NSLayoutConstraint?
    fileprivate var captureButtonWidth: NSLayoutConstraint?
    fileprivate var captureButtonHeight: NSLayoutConstraint?
  
    lazy var mainScrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.frame = self.view.frame
        scrollView.delegate = self
        scrollView.bounces = false
        for c in 0 ..< controllers.count {
            let xOrigin: CGFloat = self.view.frame.width * CGFloat(c)
            var contentView = UIView(frame: CGRect(x: xOrigin, y: 0, width: scrollView.frame.width, height: scrollView.frame.height))
            scrollView.contentSize.width = scrollView.frame.width * CGFloat(c + 1)
            scrollView.addSubview(contentView)
            contentView.addSubview(self.controllers[c].view)
        }
        return scrollView
    }()

    lazy var captureButton: UIButton = {
       let button = UIButton()
        button.setBackgroundImage(UIImage(named: "circle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.scrollToCamera), for: .touchUpInside)
        return button
    }()
    lazy var discoverButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "necklace"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.scrollToDiscover), for: .touchUpInside)

        return button
    }()
    lazy var chatButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "chatSet"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.scrollToChat), for: .touchUpInside)
        return button
    }()
    lazy var customInputView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(captureButton)
        view.addSubview(discoverButton)
        view.addSubview(chatButton)

        captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        discoverButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45).isActive = true
        discoverButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        discoverButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        chatButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45).isActive = true
        chatButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        chatButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        captureButtonTop = captureButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50)
        captureButtonTop?.isActive = true
        captureButtonWidth = captureButton.widthAnchor.constraint(equalToConstant: 70)
        captureButtonWidth?.isActive = true
        captureButtonHeight = captureButton.heightAnchor.constraint(equalToConstant: 70)
        captureButtonHeight?.isActive = true
        discoverConstraint = discoverButton.rightAnchor.constraint(equalTo: view.rightAnchor)
        discoverConstraint?.isActive = true
        chatConstraint = chatButton.rightAnchor.constraint(equalTo: view.leftAnchor)
        chatConstraint?.isActive = true
        return view
    }()
    
    lazy var controllers: [UIViewController] = {
        return [ChatViewController(), CameraViewController(), DiscoverViewController()]
    }()
    
    lazy var customViewButtons: [UIButton] = {
        return [captureButton,chatButton,discoverButton]
    }()

    lazy var searchBar: UISearchBar = {
        let search = UI.instance.searchBar
        search.setImage(UIImage(named: "searchBarImage"), for: .search, state: .normal)
        return search
    }()
    
    lazy var searchTextField: UITextField = {
        let searchText = (self.searchBar.value(forKey: "searchField") as? UITextField)!
        searchText.textColor = UIColor.white
        searchText.backgroundColor = UIColor.clear
        searchText.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        return searchText
    }()
    
    lazy var addMessage: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "chatSet"), for: .normal)
        return button
    }()
    
    lazy var addUserButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "addUser"), for: .normal)
        button.addTarget(self, action: #selector(self.toDiscover), for: .touchUpInside)

        return button
    }()
    
    lazy var swapButton: UIButton = {
        let swapButton = UIButton()
        swapButton.setBackgroundImage(UIImage(named: "swap"), for: .normal)
        return swapButton
    }()
    
    var captureSession : AVCaptureSession?
    var stillImageOutput : AVCaptureStillImageOutput?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var nav: InteractiveNavigation?
    
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        var frame = self.view.layer.bounds
        frame.origin.y = -navigationBarHeghit - (UIApplication.shared.statusBarView?.frame.height)! - 12.0
        frame.size.height = frame.size.height + navigationBarHeghit + (UIApplication.shared.statusBarView?.frame.height)! + 12
        self.previewLayer?.frame = frame
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepeareCamera()
        self.view.addSubview(mainScrollView)
        self.view.addSubview(customInputView)
     
        self.customInputView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        self.customInputView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        self.customInputView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: self.view.safeAreaInsets.bottom).isActive = true
        addNavBarImage()

    }

  
    
    func addNavBarImage() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "mainEmoji"))
        imageView.frame = CGRect(x: 0, y: 0, width: 35, height: 38)
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 17.5
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        imageView.clipsToBounds = true
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 38))
        titleView.addSubview(imageView)
        titleView.backgroundColor = .clear
        
        self.navigationItem.rightBarButtonItems =  [UIBarButtonItem(customView: addMessage),UIBarButtonItem(customView: addUserButton)]
        
        let button = UIBarButtonItem(customView: titleView)
        self.navigationItem.leftBarButtonItem = button
    
        navigationItem.titleView = searchBar
    }
    
   public func fadeFromColor(fromColor: UIColor, toColor: UIColor, withPercentage: CGFloat) -> UIColor {
        var fromRed: CGFloat = 0.0
        var fromGreen: CGFloat = 0.0
        var fromBlue: CGFloat = 0.0
        var fromAlpha: CGFloat = 0.0
        
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        
        var toRed: CGFloat = 0.0
        var toGreen: CGFloat = 0.0
        var toBlue: CGFloat = 0.0
        var toAlpha: CGFloat = 0.0
        
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        // calculate the actual RGBA values of the fade colour
        let red = (toRed - fromRed) * withPercentage + fromRed
        let green = (toGreen - fromGreen) * withPercentage + fromGreen
        let blue = (toBlue - fromBlue) * withPercentage + fromBlue
        let alpha = (toAlpha - fromAlpha) * withPercentage + fromAlpha
        
        // return the fade colour
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    @objc func toDiscover(){
        self.navigationController?.pushViewController(DiscoverViewController(), animated: true)
    }
    
    @objc func scrollToChat(){
        scrollToPage(page: 0, animated: true)
    }
    
    @objc func scrollToCamera(){
        scrollToPage(page: 1, animated: true)
    }
    
    @objc func scrollToDiscover(){
        scrollToPage(page: 2, animated: true)
    }
    
    func scrollToPage(page: Int, animated: Bool) {
        var frame: CGRect = self.mainScrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        self.mainScrollView.scrollRectToVisible(frame, animated: animated)
    }
    
    func prepeareCamera(){
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSession.Preset.hd1280x720
        
        guard let backCamera = AVCaptureDevice.default(for: .video) else {
            print("AVCaptureDevice backCamera is nil")
            return
        }
        
        let _ : NSError?
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            
            if (captureSession?.canAddInput(input))! {
                captureSession?.addInput(input)
                stillImageOutput = AVCaptureStillImageOutput()
                stillImageOutput?.outputSettings = [AVVideoCodecKey : AVVideoCodecType.jpeg]
                
                if (captureSession?.canAddOutput(stillImageOutput!))! {
                    captureSession?.addOutput(stillImageOutput!)
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                    previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                    self.view.layer.addSublayer(self.previewLayer!)
                    captureSession?.startRunning()
                }
            }
        }
        catch {
            //  error
        }
    }
   
}


extension ViewController: UIScrollViewDelegate {

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
     
        let maximumOffset = scrollView.contentSize.width - scrollView.frame.width
        let currentOffset = scrollView.contentOffset.x
        let offsetPercentage = currentOffset / maximumOffset
        let sharesCount = CGFloat(controllers.count - 1)
        var currentShareIndex: CGFloat = 0
        let discoverConstraintleft = 0.0 - 80.0
        let chatConstraintRight = 0.0 + 120.0
        
        for b in customViewButtons {
            b.clipsToBounds = false
            b.layer.masksToBounds = false
            b.layer.shadowColor = UIColor.gray.cgColor
            b.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            b.layer.shadowRadius = 12.0
            b.layer.shadowOpacity = 0.7
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
            if currentOffset <= scrollView.frame.width  {
                self.discoverConstraint?.constant = offsetPercentage - 80 + (currentOffset/8)
                self.chatConstraint?.constant = offsetPercentage + 120 - (currentOffset/8)
                self.captureButtonTop?.constant = 2
                self.captureButtonHeight?.constant = 60 + currentOffset / 16
                self.captureButtonWidth?.constant = 60 + currentOffset / 16
            }
            else  {
                self.discoverConstraint?.constant = CGFloat(discoverConstraintleft)
                self.chatConstraint?.constant = CGFloat(chatConstraintRight)
                self.captureButtonTop?.constant =  2
                self.captureButtonHeight?.constant = 60
                self.captureButtonWidth?.constant = 60
            }
        }, completion: nil)

        self.view.layoutIfNeeded()
        
        switch offsetPercentage {
        case  ..<0:
            currentShareIndex = 0
        case 0..<1:
            currentShareIndex = floor(offsetPercentage * sharesCount)
        case 1... :
            currentShareIndex = sharesCount - 1
        default: break
        }

        let firstColorIndex = Int(currentShareIndex)
        let secondColorIndex = Int(currentShareIndex) + 1
        let colorPercentage = (offsetPercentage - currentShareIndex / sharesCount) * sharesCount
        let currentIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        let newAlpha: CGFloat = 1.0 - colorPercentage

        self.navigationController?.navigationBar.backgroundColor = controllers[firstColorIndex].view.backgroundColor!.interpolateRGBColorTo(end: controllers[secondColorIndex].view.backgroundColor!, fraction: colorPercentage)

        UIApplication.shared.statusBarView?.backgroundColor = controllers[firstColorIndex].view.backgroundColor!.interpolateRGBColorTo(end: controllers[secondColorIndex].view.backgroundColor!, fraction: colorPercentage)
        
        let chatView = self.controllers[0] as! ChatViewController
        chatView.view.backgroundColor = controllers[firstColorIndex].view.backgroundColor!.interpolateRGBColorTo(end: controllers[secondColorIndex].view.backgroundColor!, fraction: colorPercentage)
        
        if currentOffset <= scrollView.frame.width / 3 {

            UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
              
                if currentIndex == 0 {
                    self.navigationItem.rightBarButtonItems![0].customView?.alpha = newAlpha
                    self.searchTextField.attributedPlaceholder =  NSAttributedString(string: "Friends", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(newAlpha)])
                    self.navigationItem.rightBarButtonItems![0] = UIBarButtonItem(customView: self.addMessage)
                    let chatView = self.controllers[0] as! ChatViewController
                    chatView.view.backgroundColor = UIColor(red:0.00, green:0.64, blue:1.00, alpha:newAlpha)

                }
                else if currentIndex == 1 {
                    self.navigationController?.navigationBar.isTranslucent = false
                    self.searchTextField.attributedPlaceholder =  NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(newAlpha)])
                    self.navigationItem.rightBarButtonItems![0] = UIBarButtonItem(customView: self.swapButton)
                }
                
            }, completion: nil)
        }
        else if currentOffset <= scrollView.frame.width{
            let alpha = currentOffset/320
            if currentIndex == 0 {

                self.searchTextField.attributedPlaceholder =  NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(alpha)])
                self.navigationItem.rightBarButtonItems![0] = UIBarButtonItem(customView: self.swapButton)
                self.navigationItem.rightBarButtonItems![0].customView?.alpha = alpha
                scrollView.layer.sublayers![0].opacity = 1.0

    
            }
             if currentIndex == 1 {
                
                self.searchTextField.attributedPlaceholder =  NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(alpha)])
                self.navigationItem.rightBarButtonItems![0] = UIBarButtonItem(customView: self.swapButton)
                self.navigationItem.rightBarButtonItems![0].customView?.alpha = alpha
            }
        }
        else {
            let alpha = currentOffset/640
            if currentIndex == 1 {
                self.searchTextField.attributedPlaceholder =  NSAttributedString(string: "Discover", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(alpha)])
                
                let discoverView = self.controllers[0] as! ChatViewController
                discoverView.view.backgroundColor = controllers[firstColorIndex].view.backgroundColor!.interpolateRGBColorTo(end: controllers[secondColorIndex].view.backgroundColor!, fraction: colorPercentage)
                scrollView.layer.sublayers![0].opacity = Float(colorPercentage)
                scrollView.backgroundColor = controllers[firstColorIndex].view.backgroundColor!.interpolateRGBColorTo(end: controllers[secondColorIndex].view.backgroundColor!, fraction: colorPercentage)
            }
            if currentIndex == 2 {
                 self.searchTextField.attributedPlaceholder =  NSAttributedString(string: "Discover", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(alpha)])
            }
            
        }
        
    }
}

extension ViewController: didSelectChatDelegate {
    func push(view: ChatViewController) {
        print("OK")
    }
    
    
}
