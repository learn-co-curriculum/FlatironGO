//
//  AppDelegate.swift
//  FlatironGo
//
//  Created by Jim Campagno on 7/13/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GeoFire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var locations: [String] = []

    //var mapViewController = MapViewController()
    var navBarController: UINavigationController!


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        setupMapView()
        FIRApp.configure()
        
        return true
    }
    
    // Set new location to Firebase
    func setNewLocationToFirebase(lat lat: Double, long: Double, key: String) {
        
        // Create CLLocation
        let location = CLLocation.init(latitude: lat, longitude: long)
        
        // Create GeoFire reference
        let geofireRef = FIRDatabase.database().referenceWithPath(FIRReferencePath.treasureLocations)
        let geoFire = GeoFire(firebaseRef: geofireRef)
        
        // Set location to Firebase DB
        geoFire.setLocation(location, forKey: key)
        
        // Test setting locations
        //        setNewLocationToFirebase(lat: 40.703277, long: -74.017028, key: "-KMrYXuGTcdgU0EmLla8")
        //        setNewLocationToFirebase(lat: 40.706876, long: -74.011265, key: "-KMrYLBBgDZCoAW29j7S")
        //        setNewLocationToFirebase(lat: 40.70528, long: -74.014025, key: "-KMrXkk5iEvaQFeyVGDp")
        //        setNewLocationToFirebase(lat: 40.70561624671299, long: -74.01340194046497, key: "-KMrX9X2cUkICtYYjS9K")
        //        setNewLocationToFirebase(lat: 40.704334, long: -74.013978, key: "-KMrY51C43P5X5L1ECdO")
        
        // Test setting profile
        //        let ref = FIRDatabase.database().reference()
        //        let key = ref.child(FIRReferencePath.treasureProfiles).childByAutoId().key
        //        let post = [key: [
        //                            "name": "Battery Park",
        //                            "imageURL": "https://i.imgur.com/EDmhR2z.jpg"]]
        //        
        //        ref.child("treasureProfiles").updateChildValues(post)
        
    }
    
    func setupMapView(){
//        window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        navBarController = UINavigationController()
//        window!.rootViewController = navBarController
//        navBarController.view.backgroundColor = UIColor.whiteColor();
//        window!.makeKeyAndVisible()
//        navBarController.viewControllers = [MapViewController()]
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

