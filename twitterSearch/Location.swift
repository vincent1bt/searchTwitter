//
//  Location.swift
//  twitterSearch
//
//  Created by vicente rodriguez on 2/26/16.
//  Copyright © 2016 vicente rodriguez. All rights reserved.
//

import Foundation
import MapKit

class Location: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}