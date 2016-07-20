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
    var downloadingImage: Bool = false
    
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
        guard downloadingImage == false else { print("Already downloading image."); return }
        guard image == nil else { print("We already have image"); return }
        guard let imageURL = NSURL(string: imageURL) else { print("Couldnt convert URL"); completion(false); return }
        
        downloadingImage = true
        
        let session = NSURLSession.sharedSession()
        
        session.dataTaskWithURL(imageURL) { [unowned self] data, response, error in
            dispatch_async(dispatch_get_main_queue(),{
                guard let data = data else { print("data came back nil"); completion(false); return }
                if let image = UIImage(data: data) { self.image = image }
                self.downloadingImage = false
                completion(true)
            })
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