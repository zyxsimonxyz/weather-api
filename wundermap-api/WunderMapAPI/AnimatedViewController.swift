//
//  AnimatedViewController.swift
//  WunderMapAPI
//
//  Created by Gavin Wiggins on 1/16/17.
//  Copyright © 2017 Gavin Wiggins. All rights reserved.
//

import UIKit
import MapKit

class AnimatedViewController: UIViewController {

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
        
        // add overlay to the map based on bounding box corners
        let pointNE = MKMapPointForCoordinate(pts[1])
        let pointSW = MKMapPointForCoordinate(pts[3])
        let pointX = fmin(pointNE.x, pointSW.x)
        let pointY = fmin(pointNE.y, pointSW.y)
        let rectWidth = fabs(pointNE.x - pointSW.x)
        let rectHeight = fabs(pointNE.y - pointSW.y)
        let rec = MKMapRectMake(pointX, pointY, rectWidth, rectHeight)
        let overlay = AnimatedOverlay(coord: location, rect: rec)
        mapview.add(overlay)
    }

}

extension AnimatedViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is AnimatedOverlay {
            let radar = UIImage(named: "richmond-anim.gif")
            let overlayView = AnimatedOverlayView(overlay: overlay, overlayImage: radar!)
            //overlayView.alpha = 0.5
            return overlayView
        } else {
            return MKPolylineRenderer()
        }
    }
    
}
