//
//  GameScene.swift
//  Project26
//
//  Created by R R on 16/02/21.
//

import CoreMotion
import SpriteKit

enum CollisionTypes: UInt32{
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case teleport = 32  //challenge
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    
    var motionManager: CMMotionManager!
    var isGameOver = false
    
    var scoreLabel: SKLabelNode!
    var score = 0{
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    //challenge
    var teleportFlag = false
    var teleportPosition: CGPoint?
    var level = 1{
        didSet{
            levelLabel.text = "Level: \(level)"
        }
    }
    var gameOver: SKLabelNode!
    var levelLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
       startup()
    }
    
    func startup(){
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: \(score)" //changed
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        levelLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelLabel.text = "Level: \(level)" //changed
        levelLabel.horizontalAlignmentMode = .right
        levelLabel.position = CGPoint(x: 1020, y: 16)
        levelLabel.zPosition = 2
        addChild(levelLabel)
        
        loadLevel()
        createPlayer()
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
    }
    
    
    func loadLevel(){

        //challenge
        guard let levelURL = Bundle.main.url(forResource: "level" + String(level), withExtension: "txt") else {
            fatalError("Could not find level1.txt in the app bundle.")
        }
        guard let levelString = try? String(contentsOf: levelURL)  else {
            fatalError("Could not load level1.txt from the app bundle.")
        }
      
        let lines = levelString.components(separatedBy: "\n")
       
        for (row, line) in lines.reversed().enumerated(){
            for (column, letter) in line.enumerated(){

                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                //challenge
                if letter == "x"{
                    loadBlock(position)
                }else if letter == "v"{
                    loadVortex(position)
                }else if letter == "s"{
                    loadStar(position)
                }else if letter == "f"{
                    loadFinish(position)
                }else if letter == " "{
                    //this is an empty space - do nothing!
                }else if letter == "t"{
                    //challenge
                    loadTeleport(position)
                }else if letter == "m"{
                    //challenge
                    teleportPosition = position
                }else{
                    fatalError("Unknown level letter: \(letter)")
                }
                
            }
        }
        
    }
    
    func playerPosition(for level: Int){
        switch level {
        case 1:
            player.position = CGPoint(x: 96, y: 672)
        case 2:
            player.position = CGPoint(x: 96, y: 72)
        default:
            player.position = CGPoint(x: 96, y: 672)
        }
    }
    
    func createPlayer(){
        physicsWorld.gravity = .zero
        
        player = SKSpriteNode(imageNamed: "player")
       
        //challenge
        if teleportFlag{
            guard let position = teleportPosition else { return }
            player.position = position
            teleportFlag = false
        }else{
            playerPosition(for: level)
        }
      
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        #if targetEnvironment(simulator)
        if let lastTouchPosition = lastTouchPosition{
            let diff = CGPoint(x: lastTouchPosition.x - player.position.x, y: lastTouchPosition.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelerometerData = motionManager?.accelerometerData{
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50 , dy:  accelerometerData.acceleration.x * 50)
        }
        #endif
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    
    func playerCollided(with node:SKNode){
        if node.name == "vortex"{
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(by: 0.0001, duration:0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move,scale,remove])
            
            player.run(sequence){ [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        }else if node.name == "star"{
            node.removeFromParent()
            score += 1
        }else if node.name == "teleport"{
            //challenge
            player.physicsBody?.isDynamic = false
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(by: 0.0001, duration:0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move,scale,remove])
            
            player.run(sequence){ [weak self] in
                self?.teleportFlag = true
                self?.createPlayer()
            }
        }else if node.name == "finish"{
            //challenge
            player.physicsBody?.isDynamic = false
            isGameOver = true
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(by: 0.0001, duration:0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move,scale,remove])
            
            player.run(sequence){ [weak self] in
                if self?.level == 2{
                    self?.gameover()
                }else{
                    self?.isGameOver = false
                    self?.level += 1
                    self?.removeAllChildren()
                    self?.startup()
                }
            }
        }
        
    }
    
    func gameover() {
        gameOver = SKLabelNode(fontNamed: "chalkduster")
        gameOver.position = CGPoint(x: 495, y: 384)
        gameOver.fontSize = 104
        gameOver.fontColor = .green
        gameOver.zPosition = 3
        gameOver.text = "🏆 Winner 🎉"
        addChild(gameOver)
    }
    
    
    func loadBlock(_ position: CGPoint){
        let node = SKSpriteNode(imageNamed: "block")
        node.position = position

        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        node.physicsBody?.isDynamic = false
        addChild(node)
    }
    
    func loadVortex(_ position: CGPoint){
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "vortex"
        node.position = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    
    func loadStar(_ position: CGPoint){
        let node = SKSpriteNode(imageNamed: "star")
        node.name = "star"
        node.position = position
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    
    func loadFinish(_ position: CGPoint){
        let node = SKSpriteNode(imageNamed: "finish")
        node.name = "finish"
        node.position = position
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    
    func loadTeleport(_ position: CGPoint){
        let node = SKSpriteNode(imageNamed: "teleport")
        node.name = "teleport"
        node.position = position
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.teleport.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    
    
}
