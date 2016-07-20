//
//  FirebaseAPI.swift
//  FlatironGo
//
//  Created by Joel Bell on 7/18/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseDatabase
import GeoFire

class FirebaseAPI {
    
    func setTreasureProfileAndLocation(name name: String,
                                            imageName: String,
                                            image: UIImage,
                                            latitude: Double,
                                            longitude: Double) {
        
        
        self.store(image, name: imageName) { (success, imageURL) in
            
            if success {
                
                self.setProfile(name, imageURL: imageURL, completionHandler: { (success, key) in
                    
                    if success {
                        
                        self.setGeoFire(latitude: latitude, longitude: longitude, key: key, completionHandler: { (success) in
                            
                            if success {
                                
                            }
                        })
                    }
                })
            }
        }
    }
    
    private func store(image: UIImage, name: String, completionHandler: (success: Bool, imageURL: String) -> Void) {
        
        let storage = FIRStorage.storage()
        let storageRef = storage.referenceForURL(FIRStorageReference.storageBucket)
        let imageRef = storageRef.child("images" + "/" + name + ".png")
        let data = UIImagePNGRepresentation(image)
        
        _ = imageRef.putData(data!, metadata: nil) { metadata, error in
            
            if (error != nil) {
                print("ERROR: \(error.debugDescription)")
                completionHandler(success: false, imageURL: "")
            } else {
                let downloadURL = metadata!.downloadURL()?.absoluteString
                completionHandler(success: true, imageURL: downloadURL!)
            }
        }
    }
    
    private func setProfile(name: String, imageURL: String, completionHandler: (success: Bool, key: String) -> Void) {
        
        let ref = FIRDatabase.database().reference()
        let key = ref.child(FIRReferencePath.treasureProfiles).childByAutoId().key
        let post = [key: ["name": name, "imageURL": imageURL]]
        ref.child(FIRReferencePath.treasureProfiles).updateChildValues(post) { (error, ref) in
            
            if (error != nil) {
                print("ERROR: \(error.debugDescription)")
                completionHandler(success: false, key: "")
            } else {
                completionHandler(success: true, key: key)
            }
            
        }
    }
    
    private func setGeoFire(latitude lat: Double, longitude long: Double, key: String, completionHandler: (success: Bool) -> Void) {
        
        let location = CLLocation.init(latitude: lat, longitude: long)
        let geofireRef = FIRDatabase.database().referenceWithPath(FIRReferencePath.treasureLocations)
        let geoFire = GeoFire(firebaseRef: geofireRef)
        
        geoFire.setLocation(location, forKey: key, withCompletionBlock: { error in
            
            if (error != nil) {
                print("ERROR: \(error.debugDescription)")
                completionHandler(success: false)
            } else {
                completionHandler(success: true)
            }
        })
    }
    
}


