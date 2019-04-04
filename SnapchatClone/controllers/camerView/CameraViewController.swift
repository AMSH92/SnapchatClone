//
//  CameraViewController.swift
//  SnapchatClone
//
//  Created by Alsharif Abdullah M on 3/14/19.
//  Copyright © 2019 Alsharif Abdullah M. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    lazy var flashButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "flashOn"), for: .normal)
        return button
    }()
    
    lazy var moonButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "moon"), for: .normal)
        return button
    }()
    
    var captureSession : AVCaptureSession?
    var stillImageOutput : AVCaptureStillImageOutput?
    var previewLayer : AVCaptureVideoPreviewLayer?

    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        var frame = self.view.layer.bounds
        frame.origin.y = -navigationBarHeghit - (UIApplication.shared.statusBarView?.frame.height)! - 12.0
        frame.size.height = frame.size.height + navigationBarHeghit + (UIApplication.shared.statusBarView?.frame.height)!
            self.previewLayer?.frame = frame
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
      //  prepeareCamera()

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
                    self.view.layer.addSublayer(previewLayer!)
                    constrains()
                    captureSession?.startRunning()
                }
            }
        }
        catch {
            //  error
        }
    }
    
    func constrains() {
        // FLASH BUTTON
        self.view.addSubview(flashButton)
        self.view.addSubview(moonButton)

        self.flashButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.flashButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.flashButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.flashButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -18).isActive = true
        
        self.moonButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.moonButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.moonButton.topAnchor.constraint(equalTo: self.flashButton.bottomAnchor, constant: 7).isActive = true
        self.moonButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -14).isActive = true
    }
    

    
    
    
    
}
