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
    let item = CALayer()
    var description: String { return makeDescription() }
    
    init(location: GPSLocation) {
        self.location = location
    }
    
    func makeDescription() -> String {
        return "\(location.latitude), \(location.longitude)"
    }
    
}

struct GPSLocation {
    var latitude: Float
    var longitude: Float
}
