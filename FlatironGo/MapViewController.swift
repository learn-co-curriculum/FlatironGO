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

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MGLMapView!
    var locationManager = CLLocationManager()
    //var mapView : MGLMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: 40.70528, longitude: -74.014025)
        point.title = "Flatiron School"
        point.subtitle = "Learn Love Code"
        self.mapView.addAnnotation(point)
        //self.mapView.pitchEnabled = true
        self.createConstraints()
        self.mapView.userTrackingMode = .Follow
        print("lanching")
        
        print(getUserLocation())
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func createConstraints(){
        self.mapView.snp_makeConstraints{(make) -> Void in
            make.edges.equalTo(self.view)
      
        }
    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
