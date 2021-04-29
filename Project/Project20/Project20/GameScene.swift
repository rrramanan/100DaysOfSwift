//
//  GameScene.swift
//  Project20
//
//  Created by R R on 01/02/21.
//

import SpriteKit


class GameScene: SKScene {

    var gameTimer: Timer?
    var fireworks = [SKNode]()

    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    //challenge
    var scoreLabel: SKLabelNode!
    var launchCount = 3{
        didSet{
            launchLabel.text = "Launches Left: \(launchCount)"
            if launchCount == 0{
                gameTimer?.invalidate()
            }
        }
    }
    var launchLabel: SKLabelNode!
    var gameOver: SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
        
        //challenge
        scoreLabel = SKLabelNode(fontNamed: "chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.text = "Score: 0"
        addChild(scoreLabel)
        
        launchLabel = SKLabelNode(fontNamed: "chalkduster")
        launchLabel.position = CGPoint(x: 1020, y: 16)
        launchLabel.horizontalAlignmentMode = .right
        launchLabel.text = "Launches Left: \(launchCount)"
        addChild(launchLabel)
    }
    
    
    func createFirework(xMovement: CGFloat, x:Int, y:Int){
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        switch Int.random(in: 0...2) {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        default:
            firework.color = .red
        }
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x:xMovement, y:1000))

        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        if let emitter = SKEmitterNode(fileNamed: "fuse"){
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        fireworks.append(node)
        addChild(node)
    }
    
    
    @objc func launchFireworks(){
        //challenge
        launchCount -= 1
        
        let movementAmount: CGFloat = 1800
        
        switch Int.random(in: 0...3) {
        case 0:
            //fire five, straight up
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
            
        case 1:
            //fire five, in a fan
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)
            
        case 2:
            //fire five, from the left to right
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
            
        case 3:
            //fire five, from the right to left
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
            
        default:
            break
        }
        
    }
    
    
    func checkTouches(_ touches: Set<UITouch>){
        guard let touch = touches.first else {return}
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtPoint{
            guard node.name == "firework" else {continue}
            
            for parent in fireworks{
                guard let firework = parent.children.first as? SKSpriteNode else {continue}
                    
                if firework.name == "selected" && firework.color != node.color{
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
                
                node.name = "selected"
                node.colorBlendFactor = 0
            }
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for(index, firework) in fireworks.enumerated().reversed(){
            if firework.position.y > 900 {
                fireworks.remove(at: index)
                firework.removeFromParent()
               
                //challenge
                if fireworks.count == 0 && launchCount == 0{
                    gameover()
                }
            }
        }
    }
    
    func explode(firework: SKNode){
        if let emitter = SKEmitterNode(fileNamed: "explode"){
            emitter.position = firework.position
            addChild(emitter)
            //challenge
            let wait = SKAction.wait(forDuration: 1)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([wait,remove])
            emitter.run(sequence)
        }
    }
    
    func explodeFireworks(){
        var numExploded = 0
        
        for(index, fireworkContainer) in fireworks.enumerated().reversed(){
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else {continue}
            
            if firework.name == "selected"{
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }
        
        
        switch numExploded {
            case 0:
                break
            case 1:
                score += 200
            case 2:
                score += 500
            case 3:
                score += 1500
            case 4:
                score += 2500
            default:
                score += 4000
            }
        
    }
    
    func gameover() {
        gameOver = SKLabelNode(fontNamed: "chalkduster")
        gameOver.position = CGPoint(x: 495, y: 384)
        gameOver.fontSize = 104
        gameOver.fontColor = .green
        gameOver.zPosition = 1
        gameOver.text = "GAME OVER"
        addChild(gameOver)
    }
    
}
