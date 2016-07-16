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
    var previewLayer: AVCaptureVideoPreviewLayer! = nil
    let pokemon = CALayer()
    var quaternionX: Double = 0.0 {
        didSet {
            if !foundTreasure { pokemon.center.y = (CGFloat(quaternionX) * view.bounds.size.width - 180) * 4.0 }
        }
    }
    var quaternionY: Double = 0.0 {
        didSet {
            if !foundTreasure { pokemon.center.x = (CGFloat(quaternionY) * view.bounds.size.height + 100) * 4.0 }
        }
    }
    var foundTreasure = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureCameraDevice()
        setupPreviewLayer()
        setupMotionManager()
        setupGestureRecognizer()
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
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        
        let image = UIImage(named: "FlatironLogo")
        pokemon.contents = image?.CGImage
        pokemon.bounds = CGRectMake(100.0, 100.0, 100.0, 200.0)
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

// MARK: - Gesture Recognizer Methods
extension ViewController {
    
    private func setupGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.viewTapped))
        gestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    func viewTapped(gesture: UITapGestureRecognizer) {
        let location = gesture.locationInView(view)
        let treasureCenter = pokemon.center
        let treasureHeight = pokemon.bounds.height
        let treasureWidth = pokemon.bounds.width
        let treasureOrigin = CGPoint(x: treasureCenter.x - (treasureWidth / 2), y: treasureCenter.y - (treasureHeight / 2))
        let topLeftX = Int(treasureOrigin.x)
        let topRightX = topLeftX + Int(treasureWidth)
        let topLeftY = Int(treasureOrigin.y)
        let bottomLeftY = topLeftY + Int(treasureHeight)
        
        guard topLeftX < topRightX && topLeftX < bottomLeftY else { return }
        
        let xRange = topLeftX...topRightX
        let yRange = topLeftX...bottomLeftY
        
        
        if xRange.contains(Int(location.x)) && yRange.contains(Int(location.y)) {
            motionManager.stopDeviceMotionUpdates()
            captureSession.stopRunning()
            
            
            foundTreasure = true
            
            let spring = CASpringAnimation(keyPath: "position.x")
            spring.damping = 7
            spring.fromValue = pokemon.center.x
            spring.toValue = CGRectGetMidX(view.frame)
            spring.duration = 2.5
            pokemon.addAnimation(spring, forKey: nil)
            
            let springY = CASpringAnimation(keyPath: "position.y")
            springY.damping = 7
            springY.fromValue = pokemon.center.y
            springY.toValue = CGRectGetMidY(view.frame)
            springY.duration = 2.5
            pokemon.addAnimation(springY, forKey: nil)
            
            
            pokemon.center = CGPoint(x: CGRectGetMidX(self.view.frame), y: CGRectGetMidY(self.view.frame))
            
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.beginTime = 2
            animation.duration = 10
            animation.fromValue = 1
            animation.toValue = 0
            animation.removedOnCompletion = false
            animation.fillMode = kCAFillModeBoth
            animation.additive = false
            previewLayer.addAnimation(animation, forKey: "opacityOUT")
            
//            animation.beginTime = CMTimeGetSeconds(CMTimeAdd(img.passTimeRange.start, img.passTimeRange.duration));
//            animation.duration = CMTimeGetSeconds(_timeline.transitionDuration);
//            animation.fromValue = [NSNumber numberWithFloat:1.0f];
//            animation.toValue = [NSNumber numberWithFloat:0.0f];
//            animation.removedOnCompletion = NO;
//            animation.fillMode = kCAFillModeBoth;
//            animation.additive = NO;
//            [animtingLayer addAnimation:animation forKey:@"opacityOUT"];
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

// MARK: - CGPoint Functions
extension CGPoint {
    
    func isInRangeOfTreasure(treasure: CGPoint) -> Bool {
        return true
    }
    
}




