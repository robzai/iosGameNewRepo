//
//  GameViewController.swift
//  SpriteKitGame
//
//  Created by iMac03 on 2017-02-06.
//  Copyright © 2017 iMac03. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    
    @IBOutlet weak var drawer: DrawingView!
    var recognizer: GestureRecognizer!
    var gameScene: GameScene!
    var gameoverScene: GameOverScene!
    var skView: SKView!
    
    // draws the user input
    //@IBOutlet weak var circlerDrawer: CircleDrawView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back")!)
        
        
//        //show gamescene first
//        gameScene = GameScene(size: view.bounds.size)
//        skView = view as! SKView
//        skView.showsFPS = true
//        skView.showsNodeCount = true
//        skView.ignoresSiblingOrder = true
//        gameScene?.scaleMode = .fill
//        skView.presentScene(gameScene)
 
        
//        //show menescene first
        let menuScene = MenuScene(fileNamed: "MenuScene")
        skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        menuScene?.scaleMode = .fill
        gameScene = GameScene(size: view.bounds.size)
        skView.presentScene(menuScene)

        
        
        recognizer = GestureRecognizer(target: self, action: #selector(GameViewController.circled))
        view.addGestureRecognizer(recognizer)
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func circled(c: GestureRecognizer){
        
        drawer.clear()
        
        if c.state == .began {
            //print("began")            
        }
        if c.state == .changed {
            drawer.updatePath(p: c.path)
        }
        if c.state == .failed {
            print("failed")
        }
        if c.state == .ended {
            //drawer.clear();
            if c.shape == "vertical"{
                print("vertical line")
                gameScene.projectileDidCollideWithMonster(name: "vline")
            }else if c.shape == "circle"{
                print("circle")
                gameScene.projectileDidCollideWithMonster(name: "circle")
            } else if c.shape == "horizontal"{
                print("horizontal line")
                gameScene.projectileDidCollideWithMonster(name: "hline")
            } else{
                print("can't recognize")
            }
        }
        if c.state == .possible{
            print("possible")
        }
        /*
         if c.state == .ended || c.state == .failed || c.state == .cancelled {
         circlerDrawer.updateFit(fit: c.fitResult, madeCircle: c.isCircle)
         }*/
    }

    func showGameSene(){
        let reveal = SKTransition.doorsCloseVertical(withDuration: 1.5)
        skView.presentScene(gameScene, transition: reveal)
    }
    
    
    func showGameOverSene(markYouGot: Int){
        gameScene = GameScene(size: view.bounds.size)
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        gameoverScene = GameOverScene(size: view.bounds.size, won: false, mark: markYouGot)
        skView.presentScene(gameoverScene, transition: reveal)
    }
}
