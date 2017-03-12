//
//  GameScene.swift
//  SpriteKitGame
//
//  Created by iMac03 on 2017-02-06.
//  Copyright © 2017 iMac03. All rights reserved.
//
import SpriteKit
import UIKit



struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Monster   : UInt32 = 0b1       // 1
    static let Projectile: UInt32 = 0b10      // 2
}


func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var scoreForDuration = 4
    var scoreForAddCloud = 10
    
    //add monster array
    var brownArray = [SKTexture]()
    var pinkArray = [SKTexture]()
    var greenArray = [SKTexture]()
    
    //add score label
    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    // 1
    var monstersDestroyed = 0
    var fallFrequency = 3.0
    let player = SKSpriteNode(imageNamed: "player")
    
    
    var lastPoint = CGPoint.zero
    var swiped = false
    
    var red:CGFloat = 1.0
    var green:CGFloat = 0.0
    var blue:CGFloat = 0.0
    
    var tool:UIImageView!
    var isDrawing = true
    
    //get screen size here
    let screenWidth  = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var imageView:UIImageView!
    //imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
    
    var monsterArray = ["vline" : [SKSpriteNode](),"hline" : [SKSpriteNode]()]
    var actionSequence: SKAction!
    
    override func didMove(to view: SKView) {
        
        brownArray.append(SKTexture(imageNamed: "alienBeige_walk1.png"))
        brownArray.append(SKTexture(imageNamed: "alienBeige_walk2.png"))
        
        pinkArray.append(SKTexture(imageNamed: "alienPink_jump.png"))
        pinkArray.append(SKTexture(imageNamed: "alienPink_stand.png"))
        
        greenArray.append(SKTexture(imageNamed: "alienGreen_climb1.png"))
        greenArray.append(SKTexture(imageNamed: "alienGreen_climb2.png"))
        
        
        
//         background.size = self.frame.size;
//         background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
//         addChild(background)
 
        
        // 2
        backgroundColor = UIColor(
            red: 30/255,
            green: 167/255,
            blue: 225/255,
            alpha: 1.0)
        
        //create a UIImageView
        imageView = UIImageView(frame:CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth))
        self.view?.addSubview(imageView)
        
        
        tool = UIImageView()
        tool.frame = CGRect(x: (self.view?.bounds.size.width)!, y: (self.view?.bounds.size.height)!, width: 38, height: 38)
        
        self.view?.addSubview(tool)
        
        // 3
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
        // 4
        //addChild(player)
        
        
        createActionSequence(fallFrequency: fallFrequency)
        let repeatAction = SKAction.repeatForever(actionSequence)
        run(repeatAction, withKey: "repeatAction")
        
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        
        //add score label
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 80, y: self.frame.size.height - 40)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = UIColor.lightGray
        scoreLabel.zPosition = 2
        score = 0
        
        self.addChild(scoreLabel)
        
    }
    
    /*
     * assign different methods to a SKAction obj
     */
    func createActionSequence(fallFrequency: Double){
        actionSequence = SKAction.sequence([
            SKAction.run(addMonster),
            SKAction.run(updateFrequency),
            SKAction.run(addCloud),
            SKAction.wait(forDuration: fallFrequency)
            ])
        print("fallFrequency\(fallFrequency)")
    }
    
    /*
     * change the frequency of adding monsters whenever 3 scores were earned
     */
    func updateFrequency()  {
        if monstersDestroyed >= scoreForDuration && self.fallFrequency > 1.0 {
            scoreForDuration += 3
            self.fallFrequency = self.fallFrequency - 0.5
            removeAction(forKey: "repeatAction")
            createActionSequence(fallFrequency: self.fallFrequency)
            let repeatAction = SKAction.repeatForever(actionSequence)
            run(repeatAction, withKey: "repeatAction")
        }
    }
    
    func addMonster() {
        
        // Create sprite
        let monster = SKSpriteNode(imageNamed: "alienBeige_swim1.png")
        monster.run(SKAction.repeatForever(SKAction.animate(with: brownArray, timePerFrame: 0.1)))
        
        let monster2 = SKSpriteNode(imageNamed: "alienPink_jump.png")
        //monster.run(SKAction.repeatForever(SKAction.animate(with: pinkArray, timePerFrame: 0.1)))
        
        let monster3 = SKSpriteNode(imageNamed: "alienGreen_climb1.png")
        //monster.run(SKAction.repeatForever(SKAction.animate(with: greenArray, timePerFrame: 0.1)))
        
        
        let monster_array = [monster,monster2,monster3]
        var monsterKey : String!
        
        let actualDuration_array = [3.0, 4.5, 6.5, 12.0]
        
        /*
         * Determine where to spawn the monster along the X axis
         */
        let  actualX = random(min: monster.size.width/2, max: size.width - monster.size.width/2)
        
        /* 
         * Position the monster slightly off-screen along the right edge,
         * and along a random position along the Y axis as calculated above
         */
        let index = arc4random_uniform(UInt32(monster_array.count))
        
        if index == 0 {
            monsterKey = "vline"
        } else if index == 1 {
            monsterKey = "hline"
        } else{
            monsterKey = "circle"
        }
        
        let actual_monster = monster_array[Int(index)]
        actual_monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size) // 1
        actual_monster.physicsBody?.isDynamic = true // 2
        actual_monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster // 3
        actual_monster.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile // 4
        actual_monster.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
        actual_monster.name = monsterKey
        actual_monster.position = CGPoint(x: actualX, y: size.height + actual_monster.size.height/2)
        
        //print("before \(self.children.count)")
        
        // Add the monster to the scene
        addChild(actual_monster)
        
        //print("after \(self.children.count)")
        
        // Determine speed of the monster
        let randomIndex: UInt32 = arc4random_uniform(UInt32(actualDuration_array.count))
        let actualDurationIndex: Int = Int(randomIndex)
        let actualDuration = actualDuration_array[actualDurationIndex]
        //print("actualDuration:\(actualDuration)")

        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -actual_monster.size.height/2), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        let loseAction = SKAction.run() {
            let controller = self.view?.window?.rootViewController as! GameViewController
            controller.showGameOverSene(markYouGot: self.monstersDestroyed)
            
        }
        //without lose
                actual_monster.run(SKAction.sequence([actionMove,actionMoveDone]))
        //contain lose
//        actual_monster.run(SKAction.sequence([actionMove, loseAction,actionMoveDone]))
        
    }
    
    
    /*
     * Remove all monsters which are match with the gesture
     */
    func projectileDidCollideWithMonster(name: String) {
        self.enumerateChildNodes(withName: name, using: {
            node, stop in
            // do something with node or stop
            node.removeFromParent()
            //add explosion effect and sound
            let explosion = SKEmitterNode(fileNamed: "Explosion")!
            explosion.position = node.position
            self.addChild(explosion)
            self.run(SKAction.playSoundFileNamed("bubbleSound.wav", waitForCompletion: false))
            self.monstersDestroyed += 1
            self.score = self.monstersDestroyed
            
            self.run(SKAction.wait(forDuration:2)){
                explosion.removeFromParent()
            }
        })
    }
    
    /*
     * If score is higher than 10, add one cloud on the screen.
     * After that add one more whenever the other 3 score was collected.
     */
    func addCloud(){
        if monstersDestroyed > scoreForAddCloud{
            let cloud = SKSpriteNode(imageNamed: "cloud.png")
            let actualX = random(min: cloud.size.width/2, max: size.width - cloud.size.width/2)
            let actualY = random(min: cloud.size.height/2 + size.height * 0.1, max: size.height - cloud.size.width/3)
            cloud.position = CGPoint(x: actualX, y: actualY)
            cloud.zPosition = 1
            addChild(cloud)
            scoreForAddCloud += 3
            //print("scoreForAddCloud:\(scoreForAddCloud)")
        }
    }
    
}
