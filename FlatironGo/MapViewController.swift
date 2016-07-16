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
        
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: 40.70528, longitude: -74.014025)
        point.title = "Flatiron School"
        point.subtitle = "Learn Love Code"
        //mapView.addAnnotation(point)
        //self.mapView.pitchEnabled = true
        mapView.userTrackingMode = .Follow
        print("lanching")
        mapView.delegate = self
        
        print(getUserLocation())
        // Do any additional setup after loading the view.
        
        
        mapView.snp_makeConstraints{(make) -> Void in
            mapView.addAnnotation(point)
            mapView.pitchEnabled = true
            
            
            // Optionally set a starting point.
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
            
            
        } else{
            
        }
        
        return (0,0)
    }
    
    func mapView(mapView: MGLMapView, viewForAnnotation annotation: MGLAnnotation) -> MGLAnnotationView? {
        // This example is only concerned with point annotations.
        guard annotation is MGLPointAnnotation else {
            return nil
        }
        
        // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
        let reuseIdentifier = "\(annotation.coordinate.longitude)"
        
        // For better performance, always try to reuse existing annotations.
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier)
        
        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.frame = CGRectMake(0, 0, 40, 40)
            
            // Set the annotation view’s background color to a value determined by its longitude.
            let hue = CGFloat(annotation.coordinate.longitude) / 100
            annotationView!.backgroundColor = UIColor(hue: hue, saturation: 0.5, brightness: 1, alpha: 1)
        }
        
        return annotationView
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
    
        
}



//
// MGLAnnotationView subclass
class CustomAnnotationView: MGLAnnotationView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Force the annotation view to maintain a constant size when the map is tilted.
        scalesWithViewingDistance = false
        
        // Use CALayer’s corner radius to turn this view into a circle.
        //layer.cornerRadius = frame.width / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Animate the border width in/out, creating an iris effect.
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = selected ? frame.width / 4 : 2
        layer.addAnimation(animation, forKey: "borderWidth")
    }
}
