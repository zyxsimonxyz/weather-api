//
//  StaticOverlay.swift
//  WunderMapAPI
//
//  Created by Gavin Wiggins on 1/14/17.
//  Copyright © 2017 Gavin Wiggins. All rights reserved.
//

import UIKit
import MapKit

class StaticOverlay: NSObject, MKOverlay {

    var coordinate: CLLocationCoordinate2D
    var boundingMapRect: MKMapRect
    
    init(coord: CLLocationCoordinate2D, rect: MKMapRect) {
        self.coordinate = coord
        self.boundingMapRect = rect
    }
    
}
