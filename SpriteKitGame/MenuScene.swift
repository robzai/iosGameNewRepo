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
           
//            let reveal = SKTransition.doorsCloseVertical(withDuration: 1.5)
//            gameScene = GameScene(size: view.bounds.size)
//            self.view?.presentScene(gameScene, transition: reveal)
            let controller = self.view?.window?.rootViewController as! GameViewController
            controller.showGameSene()
        }
        
        
    }
    
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        
//        
//        for touch in touches {
//            let location = touch.location(in: self)
//            
//            let touchedNode = self.scene?.nodes(at: location)
//            
//            guard let nodes = touchedNode else {
//                return
//            }
//            
//            if nodes.first?.name == "playButton" {
//                let scene = GameScene(size: (view?.bounds.size)!)
//                let skView = self.view!
//                skView.showsFPS = true
//                skView.showsNodeCount = true
//                skView.ignoresSiblingOrder = true
//                scene.scaleMode = .resizeFill
//                skView.presentScene(scene, transition: SKTransition.crossFade(withDuration: 1))
//            }
//            
//            
//        }
//        
//        
//    }
 
    
    
    
    
}

