//
//  GameScene.swift
//  Project11
//
//  Created by R R on 04/01/21.
//

import SpriteKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var scoreLabel: SKLabelNode!
    var score = 0{
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    var editLabel: SKLabelNode!
    var editingMode: Bool = false{
        
        didSet{
            if editingMode{
                editLabel.text = "Done"
            }else{
                editLabel.text = "Edit"
            }
        }
    }
    
    var ballImageArray = [String]()
    var ballLabel: SKLabelNode!
    var ballCount = 5{
        didSet{
            print("ballCount \(ballCount)")
        
            ballLabel.text =  "Balls left: \(ballCount)"
        }
    }
 
    
    
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        ballLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballLabel.text = "Balls left: \(ballCount)"
        ballLabel.position = CGPoint(x: 900, y: 650)
        addChild(ballLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
        ballImageArray = ["ballBlue","ballCyan","ballGreen","ballGrey","ballPurple","ballRed","ballYellow"]

    }
    
   

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        let location = touch.location(in: self)
        
        //print(location.y)
        
//        box = SKSpriteNode(color:.red , size: CGSize(width: 14, height: 14))
//        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 14, height: 14))
//        box.position = location
//        addChild(box)
//
      
        let objects = nodes(at: location)
        
        if objects.contains(editLabel){
            editingMode.toggle()
        }else{
            if editingMode{
               
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
            
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                box.name = "randomrect"

                addChild(box)
                
            }else{
                
                if location.y >= 660 && ballCount > 0{
                    ballCount -= 1
                    
                    let ball = SKSpriteNode(imageNamed: ballImageArray.randomElement()!)
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2.0)
                    ball.physicsBody?.restitution = 0.4
                    ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                    ball.position = location
                    ball.name = "ball"
                    addChild(ball)
                    
                    
                }else{
                
                    if let fireParticles = SKEmitterNode(fileNamed: "FireParticles"){
                        fireParticles.position = location
                        addChild(fireParticles)
                    }
                }
                
            }
        }
    }
    
    func makeBouncer(at position:CGPoint){
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width/2)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode

       if isGood{
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        }else{
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }

        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
       
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
        
        addChild(slotBase)
        addChild(slotGlow)
    }

    func collision(between ball: SKNode, object: SKNode){
        if object.name == "good"{
            destroy(ball: ball)
            score += 1
            ballCount += 1
        }else if object.name == "bad"{
            destroy(ball: ball)
            score -= 1
        }
    }

    func destroy(ball: SKNode){
    
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles"){
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        
        ball.removeFromParent()
        
        if ballCount == 0{
            ballCount = 0

            if let fireParticles = SKEmitterNode(fileNamed: "Fire"){
                fireParticles.position = CGPoint(x: 500, y: 400)
                addChild(fireParticles)
            }
            
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else{ return }
        guard let nodeB = contact.bodyB.node else{ return }
       // print("node 1 \(nodeA)")
       // print("node 2 \(nodeB)")
        
//        if contact.bodyA.node?.name == "ball"{
//            collision(between: contact.bodyA.node!, object: contact.bodyB.node!)
//        }else if contact.bodyB.node?.name == "ball"{
//            collision(between: contact.bodyB.node!, object: contact.bodyA.node!)
//        }
        
        if nodeA.name == "ball"{
           // print("in A")
            collision(between: nodeA, object: nodeB)
        }else if nodeB.name == "ball"{
           // print("in B")
            collision(between: nodeB, object: nodeA)
        }
        //challenge
        
        if nodeA.name == "randomrect"{
            if nodeA == nodeA{
                print("er")
                contact.bodyA.node?.removeFromParent()
            }
        }else if contact.bodyB.node?.name == "randomrect"{
            if nodeA == contact.bodyA.node{
                print("ty")
            }
        }

        
    }
    
}
