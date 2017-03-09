//
//  CircleFit.swift
//  SpriteKitGame
//
//  Created by yao on 2017-03-07.
//  Copyright © 2017 iMac03. All rights reserved.
//

import Foundation
import UIKit

//struct CircleResult {
//    var error: Double
//    var isCircle = false
//    
//    init() {
//        error = 0
//    }
//}

func fitCircle(points: [CGPoint]) -> Bool {
    let allowanceForBeginAndEnd = 20.0
    let allowanceForCircleDifference = 20.0
    let dataLength: CGFloat = CGFloat(points.count)
//    var circle = CircleResult()
    if (dataLength < 20 ){
        return false
    }
//    if(dataLength > 0){
        var mean: CGPoint = CGPoint(x: 0,y :0)
        
        for p in points {
            mean.x += p.x
            mean.y += p.y
        }
        
        //center of the circle (mean.x, mean.y)
        mean.x = mean.x / dataLength
        mean.y = mean.y / dataLength
        
        //get ten points out
        let gap = Int(dataLength / 8)
        let arrayOfPoints: [CGPoint] = [points[0], points[gap], points[gap*2], points[gap*3], points[gap*4], points[gap*5], points[gap*6], points[gap*7]]
        
        //set distance from first point to center as radius
        let radius = Double(sqrt((mean.x-points[0].x)*(mean.x-points[0].x)+(mean.y-points[0].y)*(mean.y-points[0].y)))
        for pt in arrayOfPoints {
            let distance = Double(sqrt((mean.x-pt.x)*(mean.x-pt.x)+(mean.y-pt.y)*(mean.y-pt.y)))
//            if abs(distance-radius)<6 {
//                circle.isCircle = true
//            }else{
//                circle.isCircle = false
//            }
            if abs(distance-radius) > allowanceForBeginAndEnd {
                return false
            }
        }
       
//        circle.error = abs(Double(points[0].x) - Double(points[ Int(dataLength - 1) ].x))
        if abs(Double(points[0].x) - Double(points[ Int(dataLength - 1) ].x)) > allowanceForCircleDifference{
            return false
        }
//        return circle
//    }
    return true
}


