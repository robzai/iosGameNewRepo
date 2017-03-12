//
//  MenuScene.swift
//  SpriteKitGame
//
//  Created by yao on 2017-03-06.
//  Copyright © 2017 iMac03. All rights reserved.
//

import SpriteKit
import UIKit

class MenuScene: SKScene, SKPhysicsContactDelegate{
        
    override func didMove(to view: SKView){
        
        physicsWorld.contactDelegate = self
        
        //transfer to gameScene
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            let controller = self.view?.window?.rootViewController as! GameViewController
            controller.showGameSene()
        }
    }
}

