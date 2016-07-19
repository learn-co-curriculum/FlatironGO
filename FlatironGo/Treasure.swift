//
//  Treasure.swift
//  FlatironGo
//
//  Created by Haaris Muneer on 7/15/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

final class Treasure: CustomStringConvertible {
    let location: GPSLocation
    var name: String
    var item = CALayer()
    var description: String { return makeDescription() }
    var image: UIImage?
    let imageURL: String
    
    init(location: GPSLocation, name: String, imageURLString: String) {
        self.location = location
        self.name = name
        imageURL = imageURLString
    }
    
    func makeDescription() -> String {
        return "\(location.latitude), \(location.longitude)"
    }
    
     func createItem() {
        guard let image = image else {print("fix this later"); return }
        item.contents = image.CGImage
    }
    
     func makeImage(withCompletion completion: (Bool) -> ()) {
        guard let imageURL = NSURL(string: imageURL) else { print("Couldnt convert URL"); completion(false); return }
        
        print("Image url is \(imageURL)")
        
        let session = NSURLSession.sharedSession()
        
        session.dataTaskWithURL(imageURL) { data, response, error in
            guard let data = data else { print("data came back nil"); completion(false); return }
            
            if let image = UIImage(data: data) {
                self.image = image
                print("Image is what now???? \(image)")
            }
            
            print("did we make an image dude: \(self.image)")
            
            completion(true)
        }.resume()
        
    }
}

struct GPSLocation {
    var latitude: Float
    var longitude: Float
}

struct TreasureLocation {
    var location: CLLocation
}