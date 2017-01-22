//
//  BoundingCoordinates.swift
//  WunderMapAPI
//
//  Created by Gavin Wiggins on 1/15/17.
//  Copyright © 2017 Gavin Wiggins. All rights reserved.
//

// See the following article on bounding coordinates
// http://janmatuschek.de/LatitudeLongitudeBoundingCoordinates

import Foundation
import MapKit

func boundingCoordinates(center: CLLocationCoordinate2D, distance: Double) -> [CLLocationCoordinate2D] {
    
    let MinLatitude = -M_PI / 2 // -PI/2
    let MaxLatitude = M_PI / 2  // PI/2
    let MinLongitude = -M_PI    // -PI
    let MaxLongitude = M_PI     // PI
    let earthRadius = 6371.01   // radius of Earth in kilometers
    
    let radLatitude = center.latitude * M_PI / 180      // convert latitude degrees to radians
    let radLongitude = center.longitude * M_PI / 180    // convert longitude degrees to radians
    
    let radDist = distance / earthRadius    // angular distance in radians on a great circle
    
    var minLat = radLatitude - radDist  // minimum latitude
    var maxLat = radLatitude + radDist  // maximum latitude
    
    var minLon: Double, maxLon: Double  // minimum and maximum longitude
    
    if minLat > MinLatitude && maxLat < MaxLatitude {
        
        let deltaLon = asin(sin(radDist) / cos(radLatitude))
        
        minLon = radLongitude - deltaLon
        
        if minLon < MinLongitude {
            minLon += 2 * M_PI
        }
        
        maxLon = radLongitude + deltaLon
        
        if maxLon > MaxLongitude {
            maxLon -= 2 * M_PI
        }
        
    } else {
        // a pole is within the distance
        minLat = max(minLat, MinLatitude)
        maxLat = max(maxLat, MaxLatitude)
        minLon = MinLongitude
        maxLon = MaxLongitude
    }
    
    // convert radians to degrees for CLLocationCoordinate2D
    minLat = minLat * 180 / M_PI
    maxLat = maxLat * 180 / M_PI
    minLon = minLon * 180 / M_PI
    maxLon = maxLon * 180 / M_PI
    
    // coordinates for each corner of bounding box
    let nw = CLLocationCoordinate2D(latitude: maxLat, longitude: minLon)
    let ne = CLLocationCoordinate2D(latitude: maxLat, longitude: maxLon)
    let se = CLLocationCoordinate2D(latitude: minLat, longitude: maxLon)
    let sw = CLLocationCoordinate2D(latitude: minLat, longitude: minLon)
    
    // array of coordinates representing bounding box corners
    return [nw, ne, se, sw]
}
