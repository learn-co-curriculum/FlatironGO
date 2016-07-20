//
//  MapViewController.swift
//  FlatironGo
//
//  Created by Your Mom on 7/15/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import UIKit
import SnapKit
import Mapbox
import FirebaseDatabase
import GeoFire


//var mapView : MGLMapView!
class MapViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate  {
    
    let backpackButton = UIButton()
    var locationManager = CLLocationManager()
    var userStartLocation = CLLocation()
    var treasureLocations: [String: GPSLocation] = [:]
    var treasures: [String: Treasure] = [:]
    var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MGLMapView(frame: view.bounds,
                                 styleURL: NSURL(string: "mapbox://styles/ianrahman/ciqodpgxe000681nm8xi1u1o9"))
        
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        mapView.delegate = self
//        mapView.zoomEnabled = false
        
        // Create Point at Flatiron Building location
        let flatironSchool = MGLPointAnnotation()
        flatironSchool.coordinate = CLLocationCoordinate2D(latitude: 40.70528, longitude: -74.014025)
        flatironSchool.title = "Flatiron School"
        flatironSchool.subtitle = "Learn Love Code"
    
        
        // Add the point to the map
        mapView.addAnnotation(flatironSchool)
        
        // Make sure we follow the user's location as they move
        mapView.userTrackingMode = .Follow
        // TODO: Refactor here
        // Get user location

        
        if let location = getUserLocation() {
            self.userStartLocation = location
            print("Got you, bro: \(location)")
        }
        

        getTreasuresFor(self.userStartLocation, completion: { (result) in
            if result {
                print("Got dem tressss: \(self.treasures)")
            } else {
                print("FAILURE, treaures getting error")
            }
            
        })


        setUpConstraintsOn(mapView, withCoordinate: self.userStartLocation.coordinate)
        setUpBackpackButton()
        
        print("Self treasure locations \(self.treasureLocations.count)")
        print(self.treasures.count)
        
    }
    
    func createAnnotations(){
    
        if let annotationArray = self.mapView.annotations{
            self.mapView.removeAnnotations(annotationArray)
        }
        
        for annot in self.treasures{
            let newAnnotation = MGLPointAnnotation()
            let latitude = Double(annot.1.location.latitude)
            let longitude = Double(annot.1.location.longitude)
            newAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude as CLLocationDegrees, longitude: longitude as CLLocationDegrees)
            newAnnotation.title = annot.1.name
            self.mapView.addAnnotation(newAnnotation)
        }
        
    }
    
    func getTreasuresFor(location: CLLocation, completion: (Bool) -> ()) {
        
        print("Let's get some trez")
        
        let geofireRef = FIRDatabase.database().referenceWithPath(FIRReferencePath.treasureLocations)
        let geoFire = GeoFire(firebaseRef: geofireRef)
        let geoQuery = geoFire.queryAtLocation(location, withRadius: 10.0)
        
        _ = geoQuery.observeEventType(.KeyEntered) { (key: String?, location: CLLocation?) in
            
            if let geoKey = key, geoLocation = location {
                
                let lat = Float((geoLocation.coordinate.latitude))
                let long = Float((geoLocation.coordinate.longitude))
                
                self.treasureLocations[geoKey] = (GPSLocation.init(latitude: lat, longitude: long))

                self.getTreasureProfileFor(geoKey, completion: { (result) in
                    if result {
                        completion(true)
                        self.createAnnotations()
                    } else {
                        completion(false)
                    }
                })
            }
            
        }
     
    }
    
    func getTreasureProfileFor(key: String, completion: (Bool) -> ()) {
        
        let profileRef = FIRDatabase.database().referenceWithPath(FIRReferencePath.treasureProfiles + "/" + key)
        
        _ = profileRef.observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
            //TODO : Comment
            
            if let profile = snapshot.value as? [String: AnyObject] {
                
                if let treasureLocation = self.treasureLocations[snapshot.key] {
                    let name = profile["name"] as! String
                    let imageURL = profile["imageURL"] as! String
                    let treasure = Treasure.init(location: treasureLocation, name: name, imageURLString: imageURL)
                    self.treasures[snapshot.key] = treasure
                    
                    completion(true)
                } else {
                    completion(false)
                }
            }
        })
    }
    
    func setUpConstraintsOn(mapView: MGLMapView, withCoordinate: CLLocationCoordinate2D) {
        
        mapView.snp_makeConstraints{(make) -> Void in
            
            mapView.pitchEnabled = true
            mapView.setCenterCoordinate(withCoordinate, zoomLevel: 15, direction: 150, animated: false)
            
            view.addSubview(mapView)
            
            mapView.snp_makeConstraints{(make) -> Void in
                make.edges.equalTo(self.view)
            }
            
        }
    }
    
    func getUserLocation() -> CLLocation?   {
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startMonitoringSignificantLocationChanges()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways)
        {
            return self.locationManager.location
            
        } else {
            return nil
        }
        
    }
    
    func mapView(mapView: MGLMapView, viewForAnnotation annotation: MGLAnnotation) -> MGLAnnotationView? {
        // This example is only concerned with point annotations.
        guard annotation is MGLPointAnnotation else { return nil }
        
        // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
        let reuseIdentifier = "\(annotation.coordinate.longitude)"
        
        
        // For better performance, always try to reuse existing annotations.
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier)
        
        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.frame = CGRectMake(0, 0, 100, 100)
            
            let imageView = UIImageView(image: UIImage(named: "treasure"))
            imageView.contentMode = .ScaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            annotationView!.addSubview(imageView)
            imageView.topAnchor.constraintEqualToAnchor(annotationView?.topAnchor).active = true
            imageView.bottomAnchor.constraintEqualToAnchor(annotationView?.bottomAnchor).active = true
            imageView.leftAnchor.constraintEqualToAnchor(annotationView?.leftAnchor).active = true
            imageView.rightAnchor.constraintEqualToAnchor(annotationView?.rightAnchor).active = true
        }
        
        return annotationView
    }
    
    func mapView(mapView: MGLMapView, didSelectAnnotationView annotationView: MGLAnnotationView) {
        print("We selected an anootation")
        performSegueWithIdentifier("TreasureSegue", sender: annotationView)
    }
    
    func mapView(mapView: MGLMapView, didSelectAnnotation annotation: MGLAnnotation) {
        
        // if treasure is within X of user location, present camera view controller
        // else flash annotation red / show alert "too far from treasure!"
    }
    
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapViewDidFinishLoadingMap(mapView: MGLMapView) {
        // Wait for the map to load before initiating the first camera movement.
        
        // Create a camera that rotates around the same center point, rotating 180°.
        // `fromDistance:` is meters above mean sea level that an eye would have to be in order to see what the map view is showing.
        let camera = MGLMapCamera(lookingAtCenterCoordinate: mapView.centerCoordinate, fromDistance: 200, pitch: 60, heading: 180)
        
        // Animate the camera movement over 5 seconds.
        mapView.setCamera(camera, withDuration: 5, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    }
    
    func setUpBackpackButton() {
        backpackButton.backgroundColor = UIColor.flatironBlueColor()
        backpackButton.setImage(UIImage(named: "backpack"), forState: .Normal)
        view.addSubview(backpackButton)
        backpackButton.snp_makeConstraints { (make) in
            make.bottom.equalTo(view).offset(-10)
            make.right.equalTo(view).offset(-10)
            make.height.equalTo(50)
            make.width.equalTo(backpackButton.snp_height)
        }
        backpackButton.layer.cornerRadius = 25
        backpackButton.addTarget(self, action: #selector(showBackpack), forControlEvents: .TouchUpInside)
    }
    
    func showBackpack() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let backpackVC = storyboard.instantiateViewControllerWithIdentifier("backpack")
        presentViewController(backpackVC, animated: true, completion: nil)
    }
    
}

// MARK: - Segue
extension MapViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard segue.identifier == "TreasureSegue" else { return }
        guard let destVC = segue.destinationViewController as? ViewController else { return }
        
        if let annotation = sender as? MGLAnnotationView {
            
            print("YOOOOOO!!!! \n\n")
            print(annotation)
            
        }
        
        let chosenTreasure = treasures["-KMrYXuGTcdgU0EmLla8"]!
        destVC.treasure = chosenTreasure
        print(treasures)
        
    }
}

// MGLAnnotationView subclass
class CustomAnnotationView: MGLAnnotationView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // (NO LONGER) Force the annotation view to maintain a constant size when the map is tilted.
        scalesWithViewingDistance = false
        // Use CALayer’s corner radius to turn this view into a circle.
        //        layer.cornerRadius = frame.width / 2
//        layer.borderWidth = 0
//        layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        print("Selected!")
        
        // Animate the border width in/out, creating an iris effect.
//        let animation = CABasicAnimation(keyPath: "borderWidth")
//        animation.duration = 0.1
//        layer.borderWidth = selected ? frame.width / 4 : 2
//        layer.addAnimation(animation, forKey: "borderWidth")
    }
}

/* TODO:
 
 make sure flatiron logo fills annotation view
 tapping on annotation should open up some details / a little coding challenge
 succeeding on challenge should add reward to pack
 we should loop through all the locations given back to us from firebase
 
 */