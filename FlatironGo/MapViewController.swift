//
//  MapViewController.swift
//  FlatironGo
//
//  Created by Johann Kerr on 7/15/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import UIKit
import SnapKit
import Mapbox


//var mapView : MGLMapView!
class MapViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate  {
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MGLMapView(frame: view.bounds,
                                 styleURL: NSURL(string: "mapbox://styles/ianrahman/ciqodpgxe000681nm8xi1u1o9"))
    
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        mapView.delegate = self
        
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: 40.70528, longitude: -74.014025)
        point.title = "Flatiron School"
        point.subtitle = "Learn Love Code"
        mapView.addAnnotation(point)
        mapView.userTrackingMode = .Follow
        print("lanching")
        
        print(getUserLocation())
        
        mapView.snp_makeConstraints{(make) -> Void in
            mapView.addAnnotation(point)
            mapView.pitchEnabled = true
            
            mapView.setCenterCoordinate(point.coordinate, zoomLevel: 15, direction: 0, animated: false)
            
            view.addSubview(mapView)
            
            mapView.snp_makeConstraints{(make) -> Void in
                make.edges.equalTo(self.view)
            }
            
        }
    }
   
    
    
    func getUserLocation() -> (latitude: CLLocationDegrees, longitude: CLLocationDegrees)   {
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startMonitoringSignificantLocationChanges()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Authorized)
        {
            if let latitude = self.locationManager.location?.coordinate.latitude, longitude = self.self.locationManager.location?.coordinate.longitude {
                return (latitude,longitude)
            }
            
        } else {
            
        }
        
        return (0,0)
    }
    
    
    
        func mapViewDidFinishLoadingMap(mapView: MGLMapView) {
            // Wait for the map to load before initiating the first camera movement.
            
            // Create a camera that rotates around the same center point, rotating 180°.
            // `fromDistance:` is meters above mean sea level that an eye would have to be in order to see what the map view is showing.
            let camera = MGLMapCamera(lookingAtCenterCoordinate: mapView.centerCoordinate, fromDistance: 200, pitch: 60, heading: 180)
            
            // Animate the camera movement over 5 seconds.
            mapView.setCamera(camera, withDuration: 5, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        }
        
        func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            // Always try to show a callout when an annotation is tapped.
            return true
        }
        
}
