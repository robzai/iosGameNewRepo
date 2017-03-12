//
//  DrawingView.swift
//  SpriteKitGame
//
//  Created by leo  luo on 2017-03-04.
//  Copyright © 2017 iMac03. All rights reserved.
//

import UIKit



// special view to draw the circles
class DrawingView: UIView {
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    private var path: CGPath?
//    private var fitResult: CircleResult?
    private var isCircle = false
    
    var drawDebug = false // set to true show additional information about the fit
    
    
    
    func updatePath(p: CGPath?) {
        path = p
        setNeedsDisplay()
    }
    
    func clear() {
        //print("clear drawing")
        //updateFit(fit: nil, madeCircle: false)
        updatePath(p: nil)
    }
    
    override func draw(_ rect: CGRect) {
        if let path = path { // draw a thick yellow line for the user touch path
            let context = UIGraphicsGetCurrentContext()
            context!.addPath(path)
            context!.setStrokeColor(UIColor.yellow.cgColor)
            context!.setLineWidth(10)
            context?.setLineCap(CGLineCap.round)
            context?.setLineJoin(CGLineJoin.round)
            context!.strokePath()
        }
    }
}
