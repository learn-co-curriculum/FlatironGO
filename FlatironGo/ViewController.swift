//
//  ViewController.swift
//  FlatironGo
//
//  Created by Jim Campagno on 7/13/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion


final class ViewController: UIViewController {
    
    let captureSession = AVCaptureSession()
    let motionManager = CMMotionManager()
    let pokemon = CALayer()
    var quaternionX: Double = 0.0 {
        didSet {
            print("xxxxxxxxxxxxxx")
            print("quaternionX = \(quaternionX)")
            print("pokemon.center.x = \(pokemon.center.x)")
            pokemon.center.y = (CGFloat(quaternionX) * view.bounds.size.width) * 3.0
            print("NEW pokemon.center.x = \(pokemon.center.x)")
            print("xxxxxxxxxxxxxx\n\n\n")
        }
    }
    var quaternionY: Double = 0.0 {
        didSet {
            print("yyyyyyyyyyyyyy")
            print("quaternionY = \(quaternionY)")
            print("pokemon.center.y = \(pokemon.center.y)")
            pokemon.center.x = (CGFloat(quaternionY) * view.bounds.size.height) * 3.0
            print("NEW pokemon.center.y = \(pokemon.center.y)")
            print("yyyyyyyyyyyyyy\n\n\n")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("launching view controller")
        setupCaptureCameraDevice()
        setupPreviewLayer()
        setupMotionManager()
    }
    
}

// MARK: - AVFoundation Methods
extension ViewController {
    
    private func setupCaptureCameraDevice() {
        let cameraDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let cameraDeviceInput = try? AVCaptureDeviceInput(device: cameraDevice)
        guard let camera = cameraDeviceInput where captureSession.canAddInput(camera) else { return }
        captureSession.addInput(cameraDeviceInput)
        captureSession.startRunning()
    }
    
    private func setupPreviewLayer() {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        
        let image = UIImage(named: "BuzzLightyear")
        pokemon.contents = image?.CGImage
        pokemon.bounds = CGRectMake(0.0, 0.0, 100.0, 200.0)
        pokemon.position = CGPointMake(view.bounds.size.height / 2, view.bounds.size.width / 2)
        previewLayer.addSublayer(pokemon)
        
        view.layer.addSublayer(previewLayer)
    }
    
}

// MARK: - Detect Movements
extension ViewController {
    
    private func setupMotionManager() {
        
        if motionManager.deviceMotionAvailable && motionManager.accelerometerAvailable {
            motionManager.deviceMotionUpdateInterval = 2.0 / 60.0
            motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue()!) { [unowned self] motion, error in
                
                if error != nil { print("wtf. \(error)"); return }
                guard let motion = motion else { print("Couln't unwrap motion"); return }
                
                self.quaternionX = motion.attitude.quaternion.x
                self.quaternionY = motion.attitude.quaternion.y
            }
        }
    }
}

// MARK: - Center Point to CALayer
extension CALayer {
    
    var center: CGPoint {
        get {
            return CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        }
        
        set {
            self.frame.origin.x = newValue.x - (self.frame.size.width / 2)
            self.frame.origin.y = newValue.y - (self.frame.size.height / 2)
        }
    }
    
}
