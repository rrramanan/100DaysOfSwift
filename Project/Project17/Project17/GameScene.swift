//
//  GameScene.swift
//  Project17
//
//  Created by R R on 21/01/21.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starField: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var possibleEnmies = ["ball","hammer","tv"]
    var gameTimer: Timer?
    var isGameOver = false
    
    var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    //challenge
    var gameOver: SKLabelNode! //own
    var timeSec = 1.0
    var newDouble: Double?
    var enemyCount = 0
    {
        didSet{
            if enemyCount.isMultiple(of: 4){
                timeSec -= 0.1
                newDouble = Double(round(10*timeSec)/10)
                gameTimer?.invalidate()
                gameTimer = Timer.scheduledTimer(timeInterval: newDouble!, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
            }
        }
    }
    

    override func didMove(to view: SKView) {
        
        backgroundColor = .black
        
        starField = SKEmitterNode(fileNamed:"starfield")
        starField.position = CGPoint(x: 1024, y: 384)
        starField.advanceSimulationTime(10)
        starField.name = "star"
        addChild(starField)
        starField.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        player.name = "player"
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
                
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
    }
    
    @objc func createEnemy(){
        guard let enemy = possibleEnmies.randomElement() else {return}
        
        //challenge
        enemyCount += 1
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200 , y:Int.random(in: 50...736))
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.contactTestBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -550, dy: 0) //speed
        sprite.physicsBody?.angularVelocity = 1  //spin
        sprite.physicsBody?.linearDamping = 0  //never slow down
        sprite.physicsBody?.angularDamping = 0  // never stop spinning
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

        for node in children{
            if node.position.x < -300{
                node.removeFromParent()
            }
        }

        if !isGameOver{
            score += 1
        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {return}
        
        var location = touch.location(in: self)
        
        
            if location.y < 100{
                location.y = 100
            }else if location.y > 668{
                location.y = 668
            }
        
            player.position = location
       
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        isGameOver = true

        //challenge
        gameTimer?.invalidate()

        gameover()
    }
   
   //challenge
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        guard touches.first != nil else {return}

        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)

        player.removeFromParent()
        isGameOver = true

        //challenge
        gameTimer?.invalidate()

        gameover()
    
    }

    func gameover() {
        gameOver = SKLabelNode(fontNamed: "chalkduster")
        gameOver.position = CGPoint(x: 495, y: 384)
        gameOver.fontSize = 84
        gameOver.fontColor = .green
        gameOver.zPosition = 1
        gameOver.text = "GAME OVER"
        addChild(gameOver)
    }
    
}


/*
 print("enemycount \(enemyCount)")
 print("timesec \(timeSec)")
 if newDouble == 0.1 {
     print("over timwr")
     gameTimer = Timer.scheduledTimer(timeInterval: newDouble!, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: false)
     isGameOver = true
     gameover()
     return
 }
 print("ndouble \(newDouble!)")
 */
