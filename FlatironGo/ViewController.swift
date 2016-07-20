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
    var treasure: Treasure! = nil
    var foundImageView: UIImageView! = nil
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
        view.backgroundColor = UIColor.blackColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if treasure.image == nil {
            treasure.makeImage { [unowned self] success in
                dispatch_async(dispatch_get_main_queue(),{
                    self.setupCamera()
                })
            }
        } else {
            setupCamera()
        }
    }
    
    private func setupCamera() {
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
        
        if let treasureImage = treasure.image {
            pokemon.contents = treasureImage.CGImage
            print(treasure.image!)
            
            let height = treasure.image!.size.height
            let width = treasure.image!.size.height

            pokemon.bounds = CGRectMake(100.0, 100.0, width, height)
            pokemon.position = CGPointMake(view.bounds.size.height / 2, view.bounds.size.width / 2)
            previewLayer.addSublayer(pokemon)
            view.layer.addSublayer(previewLayer)
        }
        
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
        
        let topLeftX = Int(pokemon.origin.x)
        let topRightX = topLeftX + Int(pokemon.width)
        let topLeftY = Int(pokemon.origin.y)
        let bottomLeftY = topLeftY + Int(pokemon.height)
        
        guard topLeftX < topRightX && topLeftX < bottomLeftY else { return }
        
        let xRange = topLeftX...topRightX
        let yRange = topLeftY...bottomLeftY
        
        checkForRange(xRange, yRange, withLocation: location)
    }
    
    private func checkForRange(xRange: Range<Int>, _ yRange: Range<Int>, withLocation location: CGPoint) {
        guard foundTreasure == false else { return }
        if xRange.contains(Int(location.x)) && yRange.contains(Int(location.y)) {
            foundTreasure = true
            motionManager.stopDeviceMotionUpdates()
            captureSession.stopRunning()
            
            pokemon.springToMiddle(withDuration: 1.5, damping: 9, inView: view)
            pokemon.centerInView(view)
            
            previewLayer.fadeOutWithDuration(1.0)
            
            animateInTreasure()
            displayNameOfTreasure()
            displayDiscoverLabel()
        }
        
    }
    
}


// MARK: - Found Pokemon
extension ViewController {
    
    func animateInTreasure() {
        // TODO: Update this when we change pokemon with treasure
        let frame = pokemon.frame
        let image = treasure.image!
        foundImageView = UIImageView(image: image)
        foundImageView.alpha = 0.0
        foundImageView.frame = frame
        view.addSubview(foundImageView)
        
        UIView.animateWithDuration(1.5, delay: 0.8, options: [], animations: {
            self.foundImageView.alpha = 1.0
            }, completion: nil)
    }
    
    func displayDiscoverLabel() {
        let label = UILabel(frame: CGRectZero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Regular", size: 30.0)
        label.text = "Caught❗️"
        label.numberOfLines = 1
        label.textAlignment = .Center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.whiteColor()
        label.alpha = 0.0
        
        view.addSubview(label)
        label.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        label.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 50.0).active = true
        label.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 14.0).active = true
        label.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -14.0).active = true
        
        label.center.x -= 800
        label.alpha = 1.0
        
        UIView.animateWithDuration(1.5, delay: 0.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 4.0, options: [], animations: {
            label.center.x = self.view.center.x
            }, completion: nil)
    }
    
    func displayNameOfTreasure() {
        let label = UILabel(frame: CGRectZero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Regular", size: 45.0)
        label.text = treasure.name
        label.numberOfLines = 1
        label.textAlignment = .Center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.flatironBlueColor()
        label.alpha = 0.0
        
        view.addSubview(label)
        label.centerXAnchor.constraintEqualToAnchor(foundImageView.centerXAnchor).active = true
        label.topAnchor.constraintEqualToAnchor(foundImageView.bottomAnchor, constant: 14.0).active = true
        label.centerYAnchor.constraintEqualToAnchor(foundImageView.centerYAnchor).active = false
        
        let originalCenterY = label.center.y
        label.center.y += 400
        label.alpha = 1.0
        
        UIView.animateWithDuration(2.5, delay: 0.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: [], animations: {
            label.center.y = originalCenterY
            }, completion: nil)
    }
}





// MARK: - Spring and Fade Animations
extension CALayer {
    
    func springToMiddle(withDuration duration: CFTimeInterval, damping: CGFloat, inView view: UIView) {
        let springX = CASpringAnimation(keyPath: "position.x")
        springX.damping = damping
        springX.fromValue = self.center.x
        springX.toValue = CGRectGetMidX(view.frame)
        springX.duration = duration
        self.addAnimation(springX, forKey: nil)
        
        let springY = CASpringAnimation(keyPath: "position.y")
        springY.damping = damping
        springY.fromValue = self.center.y
        springY.toValue = CGRectGetMidY(view.frame)
        springY.duration = duration
        self.addAnimation(springY, forKey: nil)
    }
    
    func centerInView(view: UIView) {
        self.center = CGPoint(x: CGRectGetMidX(view.frame), y: CGRectGetMidY(view.frame))
    }
    
    func fadeOutWithDuration(duration: CFTimeInterval) {
        let fadeOut = CABasicAnimation(keyPath: "opacity")
        fadeOut.delegate = self
        fadeOut.duration = duration
        fadeOut.autoreverses = false
        fadeOut.fromValue = 1.0
        fadeOut.toValue = 0.6
        fadeOut.fillMode = kCAFillModeBoth
        fadeOut.removedOnCompletion = false
        self.addAnimation(fadeOut, forKey: "myanimation")
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
    
    var width: CGFloat {
        return self.bounds.width
    }
    
    var height: CGFloat {
        return self.bounds.height
    }
    
    var origin: CGPoint {
        return CGPoint(x: self.center.x - (self.width / 2), y: self.center.y - (self.height / 2))
    }
    
}

// MARK: - CGPoint Functions
extension CGPoint {
    
    func isInRangeOfTreasure(treasure: CGPoint) -> Bool {
        return true
    }
    
}




