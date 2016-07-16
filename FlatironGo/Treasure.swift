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
    var item = CALayer()
    var description: String { return makeDescription() }
    var image: UIImage
    
    init(location: GPSLocation, image: UIImage) {
        self.location = location
        self.image = image
        createItem()
    }
    
    func makeDescription() -> String {
        return "\(location.latitude), \(location.longitude)"
    }
    
    mutating func createItem() {
        item.contents = image.CGImage
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
