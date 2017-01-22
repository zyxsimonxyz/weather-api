//
//  AnimatedOverlayView.swift
//  WunderMapAPI
//
//  Created by Gavin Wiggins on 1/16/17.
//  Copyright © 2017 Gavin Wiggins. All rights reserved.
//

import UIKit
import MapKit

class AnimatedOverlayView: MKOverlayRenderer {

    var overlayImage: UIImage
    
    init(overlay: MKOverlay, overlayImage:UIImage) {
        self.overlayImage = overlayImage
        super.init(overlay: overlay)
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        
        let imageReference = overlayImage.cgImage
        let theRect = rect(for: overlay.boundingMapRect)
        
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -theRect.size.height)
        context.draw(imageReference!, in: theRect)
    }
    
}
