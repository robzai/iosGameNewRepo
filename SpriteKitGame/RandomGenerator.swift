//
//  RandomGenerator.swift
//  SpriteKitGame
//
//  Created by leo  luo on 2017-03-12.
//  Copyright © 2017 iMac03. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}
