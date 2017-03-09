//
//  HorizentalFit.swift
//  SpriteKitGame
//
//  Created by iMac03 on 2017-03-07.
//  Copyright © 2017 iMac03. All rights reserved.
//

import Foundation
import UIKit

//struct HorizontalResult {
//    var begin: CGPoint
//    var end: CGPoint
//    var error: Double
//    //var numOfIteration: Int
//    var isHLine = false
//    
//    init() {
//        begin = CGPoint(x: 0,y :0)
//        end = CGPoint(x: 0,y :0)
//        error = 0
//        //numOfIteration = 0
//    }
//}

func fitHorizontal(points: [CGPoint]) -> Bool {
    let dataLength: CGFloat = CGFloat(points.count)
//    var horizontal = HorizontalResult()
    if (dataLength < 10 ){
        return false
    }

    var mean: CGPoint = CGPoint(x: 0,y :0)
    
    let beginPoint: CGPoint = points[0]
    let endPoint: CGPoint = points[ Int(dataLength - 1) ]
    
    for p in points {
        mean.x += p.x
        mean.y += p.y
    }
    
    mean.x = mean.x / dataLength
    mean.y = mean.y / dataLength
    
    //get ten points out
    let gap = Int(dataLength / 3)
    let arrayOfPoints: [CGPoint] = [points[0], points[gap], points[gap*2]]
    let firstGap = arrayOfPoints[1].y - beginPoint.y
    let secondGap = endPoint.y - arrayOfPoints[1].y
    let totalGap = endPoint.y - beginPoint.y
    
    
    
    if( firstGap < 5 && firstGap > -5 && secondGap < 5 && secondGap > -5 && totalGap < 5 && totalGap > -5) {
        return true
    }
    
    return false
}




