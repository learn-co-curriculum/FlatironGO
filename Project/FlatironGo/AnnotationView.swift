//
//  AnnotationView.swift
//  FlatironGo
//
//  Created by Jim Campagno on 7/20/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import Foundation
import Mapbox

class TreasureAnnotationView: MGLAnnotationView {
    
    var treasure: Treasure! = nil

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}