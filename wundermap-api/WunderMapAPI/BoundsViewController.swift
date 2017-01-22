//
//  BoundsViewController.swift
//  WunderMapAPI
//
//  Created by Gavin Wiggins on 1/15/17.
//  Copyright © 2017 Gavin Wiggins. All rights reserved.
//

import UIKit
import MapKit

class BoundsViewController: UIViewController {

    @IBOutlet weak var mapview: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapview.delegate = self
        
        let knoxville = CLLocationCoordinate2D(latitude: 35.9728, longitude: -83.9422)
        center(location: knoxville)
        
        let coords = boundingCoords(center: knoxville, distance: 90.0)      // coordinates from GeoLocation class
        
        let bnds = boundingCoordinates(center: knoxville, distance: 90.0)   // coordinates from boundingCoordinates()
        boundingPins(locations: bnds)
        boundingBox(locations: bnds)
        
        // compare GeoLocation results to boundingCoordinates() results
        print("NW corner \(coords[0])") // GeoLocation
        print("nw corner \(bnds[0])")   // boundingCoordinates()
        print("NE corner \(coords[1])")
        print("ne corner \(bnds[1])")
        print("SE corner \(coords[2])")
        print("se corner \(bnds[2])")
        print("SW corner \(coords[3])")
        print("sw corner \(bnds[3])")
    }
    
    func center(location: CLLocationCoordinate2D) {
        // set region spanned by the map
        let span = MKCoordinateSpanMake(2.0, 2.0)
        let region = MKCoordinateRegion(center: location, span: span)
        mapview.setRegion(region, animated: true)
        
        // pin for center location which is Knoxville, TN
        let center = MKPointAnnotation()
        center.coordinate = location
        center.title = "Center"
        mapview.addAnnotation(center)
    }
    
    func boundingCoords(center: CLLocationCoordinate2D, distance: Double) -> [CLLocationCoordinate2D] {
        // GeoLocation class for SW and NE bounding box coordinates
        let loc = GeoLocation.fromDegrees(latitude: center.latitude, longitude: center.longitude)
        var bounds = [GeoLocation]()
        do {
            try bounds = (loc?.boundingCoordinates(distance: distance))!
        } catch {
            print("error")
        }
        
        // coordinates for each corner of the bounding box
        let latSW = bounds[0].getLatitudeInDegree()!
        let lonSW = bounds[0].getLongitudeInDegrees()!
        let coordSW = CLLocationCoordinate2D(latitude: latSW, longitude: lonSW)
        
        let latNE = bounds[1].getLatitudeInDegree()!
        let lonNE = bounds[1].getLongitudeInDegrees()!
        let coordNE = CLLocationCoordinate2D(latitude: latNE, longitude: lonNE)
        
        let coordNW = CLLocationCoordinate2D(latitude: latNE, longitude: lonSW)
        let coordSE = CLLocationCoordinate2D(latitude: latSW, longitude: lonNE)
        
        return [coordNW, coordNE, coordSE, coordSW]
    }
    
    func boundingPins(locations: [CLLocationCoordinate2D]) {
        // pins for each corner of the bounding box
        let pinNW = MKPointAnnotation()
        pinNW.coordinate = locations[0]
        pinNW.title = "NW pin"
        mapview.addAnnotation(pinNW)
        
        let pinNE = MKPointAnnotation()
        pinNE.coordinate = locations[1]
        pinNE.title = "NE pin"
        mapview.addAnnotation(pinNE)
        
        let pinSE = MKPointAnnotation()
        pinSE.coordinate = locations[2]
        pinSE.title = "SE pin"
        mapview.addAnnotation(pinSE)
        
        let pinSW = MKPointAnnotation()
        pinSW.coordinate = locations[3]
        pinSW.title = "SW pin"
        mapview.addAnnotation(pinSW)
    }
    
    func boundingBox(locations: [CLLocationCoordinate2D]) {
        // polygon for drawing bounding box
        let nw = locations[0]
        let ne = locations[1]
        let se = locations[2]
        let sw = locations[3]
        let poly = MKPolygon(coordinates: [nw, ne, se, sw], count: 4)
        mapview.add(poly)
    }

}

extension BoundsViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // configure properties of the rendered polygon
        let poly = MKPolygonRenderer(overlay: overlay)
        poly.strokeColor = UIColor.red
        poly.lineWidth = 6
        poly.fillColor = UIColor.blue
        poly.alpha = 0.5
        return poly
    }
    
}
