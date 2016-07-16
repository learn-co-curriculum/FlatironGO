//
//  Treasure.swift
//  FlatironGo
//
//  Created by Haaris Muneer on 7/15/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import Foundation
import UIKit

struct Treasure: CustomStringConvertible {
    let location: GPSLocation
    var name: String
    var item = CALayer()
    var description: String { return makeDescription() }
    var image: UIImage?
    
    init(location: GPSLocation, name: String, imageURLString: String) {
        self.location = location
        self.name = name
        image = self.makeImage(imageURLString)
        createItem()
    }
    
    func makeDescription() -> String {
        return "\(location.latitude), \(location.longitude)"
    }
    
    mutating func createItem() {
        guard let image = image else {print("fix this later"); return }
        item.contents = image.CGImage
    }
    
    func makeImage(imageURLString: String) -> UIImage {
        guard let
            imageURL = NSURL(string: imageURLString),
            data = NSData(contentsOfURL: imageURL),
            image = UIImage(data: data) else { print("Error getting the image. Fix this later yo"); return UIImage()}
        return image
    }
}

struct GPSLocation {
    var latitude: Float
    var longitude: Float
    
    init(latitude: Float, longitude: Float) {
        self.latitude = latitude
        self.longitude = longitude
    }
}