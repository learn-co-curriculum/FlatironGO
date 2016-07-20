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

final class MapViewController: UIViewController  {
    
    let backpackButton = UIButton()
    var locationManager = CLLocationManager()
    var userStartLocation = CLLocation()
    var treasureLocations: [String: GPSLocation] = [:]
    var treasures: [(String, Treasure)] = []
    var annotations: [String: Treasure] = [:]
    var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupCurrentLocation()
        setUpConstraintsOn(mapView, withCoordinate: self.userStartLocation.coordinate)
        setUpBackpackButton()
        getTreasuresFor(self.userStartLocation) { result in
            //TODO: Handle failure
        }
    }
    
}

// MARK: - Treasure Methods
extension MapViewController {
    
    typealias ResponseDictionary = [String: AnyObject]
    
    private func getTreasuresFor(location: CLLocation, completion: (Bool) -> ()) {
        let geoQuery = setupGeoQueryWithLocation(location)
        
        geoQuery.observeEventType(.KeyEntered) { [unowned self] key, location in
            guard let geoKey = key,
                geoLocation = location
                else { print("No Key and/or No Location"); completion(false); return }
            
            let treasureLocation = self.generateLatAndLongFromLocation(geoLocation)
            self.treasureLocations[geoKey] = (GPSLocation(latitude: treasureLocation.lat, longitude: treasureLocation.long))
            self.getTreasureProfileFor(geoKey) { [unowned self] result in
                if result == true { self.createAnnotations() }
                completion(result)
            }
        }
    }
    
    private func generateLatAndLongFromLocation(location: CLLocation) -> (lat: Float, long: Float) {
        return (Float((location.coordinate.latitude)), Float((location.coordinate.longitude)))
    }
    
    private func setupGeoQueryWithLocation(location: CLLocation) -> GFCircleQuery {
        let geofireRef = FIRDatabase.database().referenceWithPath(FIRReferencePath.treasureLocations)
        let geoFire = GeoFire(firebaseRef: geofireRef)
        let geoQuery = geoFire.queryAtLocation(location, withRadius: 10.0)
        return geoQuery
        
    }
    
    private func getTreasureProfileFor(key: String, completion: (Bool) -> ()) {
        let profileRef = FIRDatabase.database().referenceWithPath(FIRReferencePath.treasureProfiles + "/" + key)
        
        profileRef.observeEventType(FIRDataEventType.Value, withBlock: { [unowned self] snapshot in
            guard let profile = snapshot.value as? ResponseDictionary,
                treasureLocation = self.treasureLocations[snapshot.key]
                else { print("Unable to produce snapshot value or key"); completion(false); return }
            
            self.saveTreasureLocally(withResponse: profile, key: snapshot.key, andLocation: treasureLocation)
            completion(true)
            })
    }
    
    private func saveTreasureLocally(withResponse response: ResponseDictionary, key: String, andLocation location: GPSLocation) {
        let name = response["name"] as? String ?? ""
        let imageURL = response["imageURL"] as? String ?? ""
        let treasure = Treasure(location: location, name: name, imageURLString: imageURL)
        let newTreasure = (key, treasure)
        treasures.append(newTreasure)
    }
    
}

// MARK: - Current Location Methods
extension MapViewController: CLLocationManagerDelegate {
    
    func getUserLocation() -> CLLocation? {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        let weHaveAuthorization = (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways)
        
        if weHaveAuthorization { return locationManager.location } else { return nil }
    }
    
    private func setupCurrentLocation() {
        if let location = getUserLocation() {
            self.userStartLocation = location
        }
    }
    
}

// MARK: - Map View Methods
extension MapViewController {
    
    private func setupMapView() {
        mapView = MGLMapView(frame: view.bounds, styleURL: NSURL(string: "mapbox://styles/ianrahman/ciqodpgxe000681nm8xi1u1o9"))
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        mapView.delegate = self
        mapView.userTrackingMode = .Follow
        mapView.pitchEnabled = true
    }
    
    private func setUpConstraintsOn(mapView: MGLMapView, withCoordinate: CLLocationCoordinate2D) {
        mapView.setCenterCoordinate(withCoordinate, zoomLevel: 15, direction: 150, animated: false)
        
        view.addSubview(mapView)
        
        mapView.snp_makeConstraints{(make) -> Void in
            make.edges.equalTo(self.view)
        }
    }
    
}

// MARK: - MapView Delegate Methods
extension MapViewController: MGLMapViewDelegate {
    
    func mapView(mapView: MGLMapView, viewForAnnotation annotation: MGLAnnotation) -> MGLAnnotationView? {
        
        guard annotation is MGLPointAnnotation else { return nil }
        
        let reuseIdentifier = String(annotation.coordinate.longitude)
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier) as? TreasureAnnotationView
        annotationView?.scalesWithViewingDistance = false

        
        if annotationView == nil {
            annotationView = TreasureAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.frame = CGRectMake(0, 0, 200, 200)
            annotationView!.scalesWithViewingDistance = false
            annotationView!.enabled = true
            
            let imageView = UIImageView(image: UIImage(named: "treasure"))
            imageView.contentMode = .ScaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            annotationView!.addSubview(imageView)
            imageView.topAnchor.constraintEqualToAnchor(annotationView?.topAnchor).active = true
            imageView.bottomAnchor.constraintEqualToAnchor(annotationView?.bottomAnchor).active = true
            imageView.leftAnchor.constraintEqualToAnchor(annotationView?.leftAnchor).active = true
            imageView.rightAnchor.constraintEqualToAnchor(annotationView?.rightAnchor).active = true
        }
        
        let key = String(annotation.coordinate.latitude) + String(annotation.coordinate.longitude)
        if let associatedTreasure = annotations[key] {
            annotationView?.treasure = associatedTreasure
        }
        
        return annotationView
    }
    
    func mapView(mapView: MGLMapView, didSelectAnnotationView annotationView: MGLAnnotationView) {
        performSegueWithIdentifier("TreasureSegue", sender: annotationView)
    }
    
    func mapView(mapView: MGLMapView, didSelectAnnotation annotation: MGLAnnotation) {
       // TODO: User is in radius of tapped treasure.
    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapViewDidFinishLoadingMap(mapView: MGLMapView) {
        let camera = MGLMapCamera(lookingAtCenterCoordinate: mapView.centerCoordinate, fromDistance: 200, pitch: 60, heading: 180)
        mapView.setCamera(camera, withDuration: 2, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    }
    
}

// MARK: - Annotation Methods
extension MapViewController {
    
    private func createAnnotations() {
        guard let (_, treasure) = treasures.last else { print("No last treasure"); return }
        generateAnnotationWithTreasure(treasure)
    }
    
    private func generateAnnotationWithTreasure(treasure: Treasure) {
        let newAnnotation = MGLPointAnnotation()
        let lat = Double(treasure.location.latitude)
        let long = Double(treasure.location.longitude)
        newAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        newAnnotation.title = treasure.name
        mapView.addAnnotation(newAnnotation)
        
        let key = String(newAnnotation.coordinate.latitude) + String(newAnnotation.coordinate.longitude)
        annotations[key] = treasure
    }
    
}

// MARK: - Segue Method
extension MapViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard segue.identifier == "TreasureSegue" else { return }
        guard let destVC = segue.destinationViewController as? ViewController else { return }
        
        if let annotation = sender as? TreasureAnnotationView {
            destVC.treasure = annotation.treasure
        }

    }
}

// MARK: - Backpack Methods
extension MapViewController {
    private func setUpBackpackButton() {
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

