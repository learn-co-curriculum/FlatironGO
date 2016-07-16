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

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MGLMapView!
    //var mapView : MGLMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: 40.70528, longitude: -74.014025)
        point.title = "Flatiron School"
        point.subtitle = "Learn Love Code"
        self.mapView.addAnnotation(point)
        self.mapView.pitchEnabled = true
        
        self.createConstraints()
        print("lanching")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
