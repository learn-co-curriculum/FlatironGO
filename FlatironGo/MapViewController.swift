//
//  MapViewController.swift
//  FlatironGo
//
//  Created by You on 7/15/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import UIKit
import SnapKit
import Mapbox
import FirebaseDatabase
import GeoFire

final class MapViewController: UIViewController  {
    
    var annotations: [String: Treasure] = [:]
    var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setCenterCoordinateOnMapView()
        generateDummyData()
    }
    
}

// MARK: - Dummy Data
extension MapViewController {
    
    private func generateDummyData() {
        // let buzzLocation = GPSLocation(latitude: 40.7032775878906, longitude: -74.0170288085938)
        let bullLocation = GPSLocation(latitude: 40.7033342590332, longitude: -74.0139770507812)
        let funnyLocation = GPSLocation(latitude: 40.7082803039551, longitude: -74.0140228271484)
        let nyseLocation = GPSLocation(latitude: 40.7056159973145, longitude: -74.0184048461914)
        let polarLocation = GPSLocation(latitude: 40.7068748474121, longitude: -74.0112686157227)
        
        // let buzz = Treasure(location: buzzLocation, name: "Buzz Lightyear", imageURLString: "")
        let bull = Treasure(location: bullLocation, name: "Charging Bull", imageURLString: "")
        let funny = Treasure(location: funnyLocation, name: "Not Snorlax", imageURLString: "")
        let nyse = Treasure(location: nyseLocation, name: "NYSE", imageURLString: "")
        let polar = Treasure(location: polarLocation, name: "Hairy Harry", imageURLString: "")
        
        // buzz.image = UIImage(imageLiteral: "BuzzLightyear")
        bull.image = UIImage(imageLiteral: "ChargingBull")
        funny.image = UIImage(imageLiteral: "FunnyPhoto")
        nyse.image = UIImage(imageLiteral: "NYSE")
        polar.image = UIImage(imageLiteral: "PolarBear")
        
        let treasureObjects = [bull, funny, nyse, polar]
        
        for treasure in treasureObjects {
            treasure.createItem()
            generateAnnotationWithTreasure(treasure)
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
        
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        mapView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        mapView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        mapView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
    }
    
    private func setCenterCoordinateOnMapView() {
        let lat: CLLocationDegrees = 40.706697302800182
        let lng: CLLocationDegrees = -74.014699650804047
        let downtownManhattan = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        mapView.setCenterCoordinate(downtownManhattan, zoomLevel: 15, direction: 25.0, animated: false)
    }
    
}

// MARK: - MapView Delegate Methods
extension MapViewController: MGLMapViewDelegate {
    
    func mapView(mapView: MGLMapView, viewForAnnotation annotation: MGLAnnotation) -> MGLAnnotationView? {
        
        guard annotation is MGLPointAnnotation else { return nil }
        
        let reuseIdentifier = String(annotation.coordinate.longitude)
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier) as? TreasureAnnotationView
        
        if annotationView == nil {
            annotationView = TreasureAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.frame = CGRectMake(0, 0, 100, 100)
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
        handleTapOfAnnotationView(annotationView)
    }
    
    func mapView(mapView: MGLMapView, didSelectAnnotation annotation: MGLAnnotation) {
        // TODO: User is in radius of tapped treasure.
    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapViewDidFinishLoadingMap(mapView: MGLMapView) {
        let camera = MGLMapCamera(lookingAtCenterCoordinate: mapView.centerCoordinate, fromDistance: 200, pitch: 60, heading: 0)
        mapView.setCamera(camera, withDuration: 2, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        mapView.resetNorth()
    }
    
}

// MARK: - Annotation Methods
extension MapViewController {
    
    private func generateAnnotationWithTreasure(treasure: Treasure) {
        let newAnnotation = MGLPointAnnotation()
        let lat = Double(treasure.location.latitude)
        let long = Double(treasure.location.longitude)
        newAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        newAnnotation.title = treasure.name
        let key = String(newAnnotation.coordinate.latitude) + String(newAnnotation.coordinate.longitude)
        annotations[key] = treasure
        mapView.addAnnotation(newAnnotation)
        
    }
    
}

// MARK: - Segue Method
extension MapViewController {
    
    private func handleTapOfAnnotationView(annotationView: MGLAnnotationView) {
        if let annotation = annotationView as? TreasureAnnotationView {
            performSegueWithIdentifier("TreasureSegue", sender: annotation)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard segue.identifier == "TreasureSegue" else { return }
        guard let destVC = segue.destinationViewController as? ViewController else { return }
        
        if let annotation = sender as? TreasureAnnotationView {
            destVC.treasure = annotation.treasure
        }
    }
}



