//
//  StaticViewController.swift
//  WunderMapAPI
//
//  Created by Gavin Wiggins on 1/14/17.
//  Copyright © 2017 Gavin Wiggins. All rights reserved.
//

import UIKit
import MapKit

class StaticViewController: UIViewController {

    @IBOutlet weak var mapview: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapview.delegate = self

        // location for Richmond, VA
        let location = CLLocationCoordinate2D(latitude: 37.531399, longitude: -77.476009)
        
        // set region spanned by the map
        let span = MKCoordinateSpanMake(2.0, 2.0)
        let region = MKCoordinateRegion(center: location, span: span)
        mapview.setRegion(region, animated: true)
        
        // coordinates for corners of bounding box
        let pts = boundingCoordinates(center: location, distance: 200.0)
        print("NW corner is \(pts[0])")
        print("NE corner is \(pts[1])")
        print("SE corner is \(pts[2])")
        print("SW corner is \(pts[3])")
        
        // add overlay to the map based on bounding box corners
        let pointNE = MKMapPointForCoordinate(pts[1])
        let pointSW = MKMapPointForCoordinate(pts[3])
        let pointX = fmin(pointNE.x, pointSW.x)
        let pointY = fmin(pointNE.y, pointSW.y)
        let rectWidth = fabs(pointNE.x - pointSW.x)
        let rectHeight = fabs(pointNE.y - pointSW.y)
        let rec = MKMapRectMake(pointX, pointY, rectWidth, rectHeight)
        let overlay = StaticOverlay(coord: location, rect: rec)
        mapview.add(overlay)

        
        // http://api.wunderground.com/api/6a1368363f37ae1e/radar/image.gif?maxlat=39.33003938866937&maxlon=-75.207698337504439&minlat=35.732758611330624&minlon=-79.744319662495585&width=600&height=600&newmaps=1
    }

}

extension StaticViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is StaticOverlay {
            let radar = UIImage(named: "richmond-static.gif")
            let overlayView = StaticOverlayView(overlay: overlay, overlayImage: radar!)
            overlayView.alpha = 0.5
            return overlayView
        } else {
            return MKPolylineRenderer()
        }
    }
    
}
