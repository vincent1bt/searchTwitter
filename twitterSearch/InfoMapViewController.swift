//
//  InfoMapViewController.swift
//  twitterSearch
//
//  Created by vicente rodriguez on 2/25/16.
//  Copyright © 2016 vicente rodriguez. All rights reserved.
//

import UIKit
import MapKit

enum MapType: Int {
    case Standard = 0
    case Hybrid = 1
    case Satellite = 2
}


class InfoMapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var locations = [Location]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self

        for i in locations {
            self.mapView.addAnnotation(i)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func changeMapType(sender: AnyObject) {
        let map = MapType(rawValue: sender.selectedSegmentIndex)
        
        switch(map!) {
        case .Standard:
            mapView.mapType = MKMapType.Standard
        case .Hybrid:
            mapView.mapType = MKMapType.Hybrid
        case .Satellite:
            mapView.mapType = MKMapType.Satellite
        }
        
    }

}
