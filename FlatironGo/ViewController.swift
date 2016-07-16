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
            pokemon.center.y = (CGFloat(quaternionX) * view.bounds.size.width - 180) * 4.0
        }
    }
    var quaternionY: Double = 0.0 {
        didSet {
            pokemon.center.x = (CGFloat(quaternionY) * view.bounds.size.height + 100) * 4.0
        }
    }
    
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
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        
        let image = UIImage(named: "BuzzLightyear")
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


extension UIViewController {
    
    private func setupGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: <#T##Selector#>)
        
        //        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
        //        gestureRecognizer.cancelsTouchesInView = NO;
        //        [self.view addGestureRecognizer:gestureRecognizer];
        
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




// MARK: - Detect Taps on Screen

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    if ([touches count] == 1) {
//        for (UITouch *touch in touches) {
//            CGPoint point = [touch locationInView:[touch view]];
//            point = [[touch view] convertPoint:point toView:nil];
//            
//            CALayer *layer = [(CALayer *)self.view.layer.presentationLayer hitTest:point];
//            
//            layer = layer.modelLayer;
//            layer.opacity = 0.5;
//        }
//    }
//}
