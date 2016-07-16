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
    
    
    
    //var mapViewController = MapViewController()
    var navBarController: UINavigationController!


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        setupMapView()
        
        // Firebase Initialization
        FIRApp.configure()
        
        /*
 
        TESTING GEOFIRE
 
        */
        
        // Create GeoFire reference
        let geofireRef = FIRDatabase.database().reference()
        let geoFire = GeoFire(firebaseRef: geofireRef)
        
        // Create test location
        let location = CLLocation.init(latitude: 40.781324, longitude: -73.973988)
        
        // Set location to Firebase DB
//        geoFire.setLocation(location, forKey: "test4")
        
        // Get location for key from Firebase DB
//        geoFire.getLocationForKey("testLocation", withCallback: { (location, error) in
//            if (error != nil) {
//                print("An error occurred getting the location for \"firebase-hq\": \(error.localizedDescription)")
//            } else if (location != nil) {
//                print("Location for \"firebase-hq\" is [\(location.coordinate.latitude), \(location.coordinate.longitude)]")
//            } else {
//                print("GeoFire does not contain a location for \"firebase-hq\"")
//            }
//        })
        
        // Create radius query
        var geoQuery = geoFire.queryAtLocation(location, withRadius: 0.4)
        
        
        
        
        return true
    }
    
    func setupMapView(){
//        window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        navBarController = UINavigationController()
//        window!.rootViewController = navBarController
//        navBarController.view.backgroundColor = UIColor.whiteColor();
//        window!.makeKeyAndVisible()
//        
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

