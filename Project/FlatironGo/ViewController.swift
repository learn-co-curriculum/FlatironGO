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
    
    var treasure: Treasure!
    var foundImageView: UIImageView!
    var dismissButton: UIButton!
    var foundTreasure = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupDismissButton()
        
        
        
    }
    
    
}












// --------- Helper Methods Provided For you ------------


// MARK: - Dismiss Button
extension ViewController {
    private func setupDismissButton() {
        dismissButton = UIButton(type: .System)
        dismissButton.setTitle("❌", forState: .Normal)
        dismissButton.titleLabel?.font = UIFont.systemFontOfSize(25.0)
        dismissButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        dismissButton.addTarget(self, action: #selector(dismiss), forControlEvents: .TouchUpInside)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.alpha = 0.0
        view.addSubview(dismissButton)
        dismissButton.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -14.0).active = true
        dismissButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func animateInDismissButton() {
        UIView.transitionWithView(dismissButton, duration: 2.5, options: .TransitionCrossDissolve, animations: {
            self.dismissButton.alpha = 1.0
            }, completion: nil)
    }
    
}

// MARK: - Found Treasure
extension ViewController {
    
    func animateInTreasure() {
        let frame = treasure.item.frame
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
        label.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        label.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        
        
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




