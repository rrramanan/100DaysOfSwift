//
//  GameScene.swift
//  Project29
//
//  Created by R R on 24/02/21.
//

import SpriteKit

enum CollisionTypes: UInt32{
    case banana = 1
    case building = 2
    case player = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var buildings = [BuildingNode]()
    weak var viewController: GameViewController?
    
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var banana: SKSpriteNode!
    
    var currentPlayer = 1
    
    //challenge
    var gameOver: SKLabelNode!
    var scoreLabel_player1 : SKLabelNode!
    var scoreLabel_player2: SKLabelNode!
    
    var score_player1 = 0 {
        didSet{
            scoreLabel_player1.text = "P1 Score: \(score_player1)"
        }
    }
    
    var score_player2 = 0 {
        didSet{
            scoreLabel_player2.text = "P2 Score: \(score_player2)"
        }
    }
    
   
    
    var windLabel: SKLabelNode!

    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        createBuildings()
        createPlayers()
        
        physicsWorld.contactDelegate = self
        
        //challenge
        scoreLabel_player1 = SKLabelNode(fontNamed: "chalkduster")
        scoreLabel_player1.position = CGPoint(x: 16, y: 16)
        scoreLabel_player1.horizontalAlignmentMode = .left
        scoreLabel_player1.text = "P1 Score: 0"
        scoreLabel_player1.fontColor = .blue
        scoreLabel_player1.zPosition = 1
        addChild(scoreLabel_player1)
        
        scoreLabel_player2  = SKLabelNode(fontNamed: "chalkduster")
        scoreLabel_player2.position  = CGPoint(x: 1020, y: 16)
        scoreLabel_player2.horizontalAlignmentMode = .right
        scoreLabel_player2.text = "P2 Score: 0"
        scoreLabel_player2.fontColor = .blue
        scoreLabel_player2.zPosition = 1
        addChild(scoreLabel_player2)
        
        score_player1 = UserDefaults.standard.integer(forKey: "p1score")
        score_player2 = UserDefaults.standard.integer(forKey: "p2score")
        
        windLabel  = SKLabelNode(fontNamed: "chalkduster")
        windLabel.position  = CGPoint(x: 730, y: 16)
        windLabel.horizontalAlignmentMode = .right
        windLabel.text = "Wind Strength: 0"
        windLabel.fontColor = .blue
        windLabel.fontSize = 30
        windLabel.zPosition = 1
        windLabel.numberOfLines = 0
        addChild(windLabel)
   
        setWind()
        
    }
    
    func createBuildings(){
        var currentX: CGFloat = -15
        
        while currentX < 1024 {
            let size = CGSize(width:Int.random(in: 2...4) * 40, height: Int.random(in: 300...600))
            currentX += size.width + 2
          
            let building = BuildingNode(color: .red, size: size)
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            building.setup()
            addChild(building)
        
            buildings.append(building)
        }
    }
    
    func launch(angle:Int, velocity:Int){
        let speed = Double(velocity) / 10
        let radians = deg2rad(degrees: angle)
    
        if banana != nil {
            banana.removeFromParent()
            banana = nil
        }
    
        banana = SKSpriteNode(imageNamed: "banana")
        banana.name = "banana"
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
        banana.physicsBody?.categoryBitMask = CollisionTypes.banana.rawValue
        banana.physicsBody?.collisionBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.contactTestBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.usesPreciseCollisionDetection = true
        addChild(banana)
    
        if currentPlayer == 1{
            banana.position = CGPoint(x: player1.position.x - 30, y: player1.position.y + 40)
            banana.physicsBody?.angularVelocity = -20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            let sequence = SKAction.sequence([raiseArm,pause,lowerArm])
            player1.run(sequence)
            
            let impluse = CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impluse)
            
        }else{
            banana.position = CGPoint(x: player2.position.x + 30, y: player2.position.y + 40)
            banana.physicsBody?.angularVelocity = 20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            let sequence = SKAction.sequence([raiseArm,pause,lowerArm])
            player2.run(sequence)
            
            let impluse = CGVector(dx: cos(radians) * -speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impluse)
        }
    }
    
    func createPlayers() {
        player1 = SKSpriteNode(imageNamed: "player")
        player1.name = "player1"
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)

        player1.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player1.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.isDynamic = false

        let player1Building = buildings[1]
        player1.position = CGPoint(x: player1Building.position.x, y: player1Building.position.y + ((player1Building.size.height + player1.size.height) / 2))
        addChild(player1)


        player2 = SKSpriteNode(imageNamed: "player")
        player2.name = "player2"
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.size.width / 2)

        player2.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player2.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.isDynamic = false

        let player2Building = buildings[buildings.count - 2]
        player2.position = CGPoint(x: player2Building.position.x, y: player2Building.position.y + ((player2Building.size.height + player2.size.height) / 2))
        addChild(player2)

    }
    
    
    func deg2rad(degrees: Int) -> Double {
        return Double(degrees) * .pi / 180
    }
   
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
     
        guard let firstNode = firstBody.node else {return}
        guard let secondNode = secondBody.node else {return}
        
        if firstNode.name == "banana" && secondNode.name == "building" {
            bananaHit(building: secondNode, atPoint: contact.contactPoint)
        }
        
        if firstNode.name == "banana" && secondNode.name == "player1" {
            destroy(player: player1)
        }
        
        if firstNode.name == "banana" && secondNode.name == "player2" {
            destroy(player: player2)
        }
        
    }
    
    
    func destroy(player: SKSpriteNode){
        if let explosion = SKEmitterNode(fileNamed: "hitPlayer"){
            explosion.position = player.position
            addChild(explosion)
        }
        
        player.removeFromParent()
        banana.removeFromParent()
        
        //challenge
        if self.currentPlayer == 1{
            self.score_player1 += 1
            UserDefaults.standard.setValue(self.score_player1, forKey: "p1score")

            if self.score_player1 == 3{
                UserDefaults.standard.removeObject(forKey: "p1score")
                UserDefaults.standard.removeObject(forKey: "p2score")
                gameover()
            }
        }else{
            self.score_player2 += 1
            UserDefaults.standard.setValue(self.score_player2, forKey: "p2score")
            
            if self.score_player2 == 3{
                UserDefaults.standard.removeObject(forKey: "p1score")
                UserDefaults.standard.removeObject(forKey: "p2score")
                gameover()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            let newGame = GameScene(size: self.size)
            newGame.viewController = self.viewController
            self.viewController?.currentGame = newGame
            
            self.changePlayer()
            newGame.currentPlayer = self.currentPlayer
            
            let transition = SKTransition.doorway(withDuration: 1.5)
            self.view?.presentScene(newGame, transition: transition)
        }
        
    }
    
    func bananaHit(building: SKNode, atPoint contactPoint: CGPoint){
        guard let building = building as? BuildingNode else {return}
        let buildingLocation = convert(contactPoint, to: building)
        building.hit(at: buildingLocation)
        
        if let explosion = SKEmitterNode(fileNamed: "hitBuilding"){
            explosion.position = contactPoint
            addChild(explosion)
        }
        
        banana.name = ""
        banana.removeFromParent()
        banana = nil
        changePlayer()
    }
    
    func changePlayer(){
        
        if currentPlayer == 1{
            currentPlayer = 2
        }else{
            currentPlayer = 1
        }
        
        //challenge
        setWind()
        
        viewController?.activatePlayer(number: currentPlayer)
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard banana != nil else {return}
        
        if abs(banana.position.y) > 1000{
            banana.removeFromParent()
            banana = nil
            changePlayer()
        }
    }
 
    //challenge
    func gameover() {
        gameOver = SKLabelNode(fontNamed: "chalkduster")
        gameOver.position = CGPoint(x: 495, y: 384)
        gameOver.fontSize = 104
        gameOver.fontColor = .green
        gameOver.zPosition = 1
        gameOver.text = score_player1 == 3 ? "Player One 🎉" : "Player Two 🎉"
        addChild(gameOver)
        
        let wait = SKAction.wait(forDuration: 0.35)
        let remove = SKAction.removeFromParent()
        let seq = SKAction.sequence([wait,remove])
        run(seq)
    }
    
   
    
    //challenge
    func setWind(){
        if currentPlayer == 1{
            physicsWorld.gravity = CGVector(dx: Double.random(in: 1.0...14.0), dy: -9.8)
            windLabel.text = "Wind Strength: \(round(100 * physicsWorld.gravity.dx) / 100) m/s \n Direction: ->>>"
        }else{
            physicsWorld.gravity = CGVector(dx: Double.random(in: -14.0 ... -1.0), dy: -9.8)
                windLabel.text = "Wind Strength: \(round(100 * physicsWorld.gravity.dx) / -100) m/s \n Direction: <<<- "
        }
    }
    
    
}
