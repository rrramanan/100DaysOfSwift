//
//  GameScene.swift
//  Project23
//
//  Created by R R on 09/02/21.
//

import SpriteKit
import AVFoundation

//challenge - "jackpot" <bounus points for hitting "jackpotChain" fast moving enemy>
enum ForceBomb {
    case never, always, random, jackpot
}

//challenge - "jackpotChain" <fast moving enemy>
enum SequenceType: CaseIterable {
    case oneNoBomb, one, twoWithOneBomb, two, three, four, chain, fastChain, jackpotChain
}

class GameScene: SKScene {
    var gameScore: SKLabelNode!
    var score = 0{
        didSet{
            gameScore.text = "Score: \(score)"
        }
    }
    
    var livesImages = [SKSpriteNode]()
    var lives = 3
    
    var activeSliceBG: SKShapeNode!
    var activeSliceFG: SKShapeNode!
    
    var activeSlicePoints = [CGPoint]()
    var isSwooshSoundActive = false
    
    var activeEnemies = [SKSpriteNode]()
    var bombSoundEffect: AVAudioPlayer?
    
    var popupTime = 0.9
    var sequence = [SequenceType]()
    var sequencePosition = 0
    var chainDelay = 3.0
    var nextSequenceQueued = true
    var isGameEnded = false
    
    //challenge
    var gameOver: SKLabelNode!
    
    override func didMove(to view: SKView) {
    
        let background = SKSpriteNode(imageNamed: "sliceBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = 0.85
        
        createScore()
        createLives()
        createSlices()
        
        //challenge <jackpotChain included>
        sequence = [.oneNoBomb, .oneNoBomb, .jackpotChain, .twoWithOneBomb, .twoWithOneBomb, .three, .one, .chain]
        
        for _ in 0...1000{
            if let nextSequence = SequenceType.allCases.randomElement(){
                sequence.append(nextSequence)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            [weak self] in self?.tossEnemies()
        }
        
    }
    
    func createScore(){
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.horizontalAlignmentMode  = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        gameScore.position = CGPoint(x: 8, y: 8)
        score = 0
    }
    
    func createLives(){
        for i in 0..<3{
            let spriteNode = SKSpriteNode(imageNamed: "sliceLife")
            spriteNode.position = CGPoint(x: CGFloat(834 + (i * 70)), y: 720)
            addChild(spriteNode)
            livesImages.append(spriteNode)
        }
    }
    
    func createSlices(){
        
        activeSliceBG = SKShapeNode()
        activeSliceBG.zPosition = 2
        
        activeSliceFG = SKShapeNode()
        activeSliceFG.zPosition = 3
        
        activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
        activeSliceBG.lineWidth = 9
        
        activeSliceFG.strokeColor = UIColor.white
        activeSliceFG.lineWidth = 5
        
        addChild(activeSliceBG)
        addChild(activeSliceFG)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isGameEnded == false else {return}
        
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        redrawActiveSlice()
        
        if !isSwooshSoundActive{
            playSwooshSound()
        }
        
        
        let nodesAtPoint = nodes(at: location)

        for case let node as SKSpriteNode in nodesAtPoint{
            
            //challenge ...
            if node.name == "enemy" || node.name == "enemyMagic"{
                //destroy the  penguin

                if let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy"){
                    emitter.position = node.position
                    addChild(emitter)
                }
                
                if node.name == "enemy"{
                    score += 1
                }else if node.name == "enemyMagic"{
                    score += 15
                }
                
                node.name = ""
                node.physicsBody?.isDynamic = false

                let scaleOut = SKAction.scale(to: 0.0001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let group = SKAction.group([scaleOut,fadeOut])

                let seq = SKAction.sequence([group, .removeFromParent()])
                node.run(seq)

                //score += 1
                
                if let index = activeEnemies.firstIndex(of: node){
                    activeEnemies.remove(at: index)
                }

                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))

            }else if node.name == "bomb"{
                // destroy the bomb
                guard let bombContainer = node.parent as? SKSpriteNode else {continue}

                if let emitter = SKEmitterNode(fileNamed: "sliceHitBomb"){
                    emitter.position = bombContainer.position
                    addChild(emitter)
                }

                node.name = ""
                bombContainer.physicsBody?.isDynamic = false

                let scaleOut = SKAction.scale(to: 0.0001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let group = SKAction.group([scaleOut,fadeOut])

                let seq = SKAction.sequence([group, .removeFromParent()])
                bombContainer.run(seq)

                if let index = activeEnemies.firstIndex(of: bombContainer){
                    activeEnemies.remove(at: index)
                }

                run(SKAction.playSoundFileNamed("explosion.caf", waitForCompletion: false))
                endGame(triggeredByBomb: true)
            }
        }
    }
    
    func endGame(triggeredByBomb: Bool){
        guard isGameEnded == false else {return}
        
        isGameEnded = true
        physicsWorld.speed = 0
        isUserInteractionEnabled = false
        
        bombSoundEffect?.stop()
        bombSoundEffect = nil
        
        if triggeredByBomb{
            livesImages[0].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[1].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[2].texture = SKTexture(imageNamed: "sliceLifeGone")
        }
        
        gameover()
    }
    
    func playSwooshSound(){
        isSwooshSoundActive = true
        
        let randomNumber = Int.random(in: 1...3)
        let soundName = "swoosh\(randomNumber).caf"
        
        let swooshSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
        run(swooshSound){
            [weak self] in
            self?.isSwooshSoundActive = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
        activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        activeSlicePoints.removeAll(keepingCapacity: true)
        
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        
        activeSliceBG.removeAllActions()
        activeSliceFG.removeAllActions()
        
        activeSliceBG.alpha = 1
        activeSliceFG.alpha = 1
       
    }
    
    func redrawActiveSlice(){
        if activeSlicePoints.count < 2 {
            activeSliceBG.path = nil
            activeSliceFG.path = nil
        }
        
        if activeSlicePoints.count > 12 {
            activeSlicePoints.removeFirst(activeSlicePoints.count - 12)
        }
        
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])
        
        for i in 1 ..< activeSlicePoints.count{
            path.addLine(to: activeSlicePoints[i])
        }
        
        activeSliceBG.path = path.cgPath
        activeSliceFG.path = path.cgPath
    }
    

    func createEnemy(forcebomb :ForceBomb = .random){
        let enemy: SKSpriteNode
        
        var enemyType = Int.random(in: 0...6)
        
        if forcebomb == .never{
            enemyType = 1
        }else if forcebomb == .always{
            enemyType = 0
        }else if forcebomb == .jackpot{
            enemyType = 2 //challenge
        }
        
        if enemyType == 0{
            enemy = SKSpriteNode()
            enemy.name = "bombContainer"
            enemy.zPosition = 1
            
            let bomb = SKSpriteNode(imageNamed: "sliceBomb")
            bomb.name = "bomb"
            enemy.addChild(bomb)
            
            if bombSoundEffect != nil{
                bombSoundEffect?.stop()
                bombSoundEffect = nil
            }
            
            if let path = Bundle.main.url(forResource: "sliceBombFuse", withExtension: "caf"){
                if let sound = try? AVAudioPlayer(contentsOf: path){
                    bombSoundEffect = sound
                    sound.play()
                }
            }
            
            if  let emitter = SKEmitterNode(fileNamed: "sliceFuse"){
                emitter.position = CGPoint(x: 76, y: 64)
                enemy.addChild(emitter)
            }
                
        }else if enemyType == 2{ //challenge
            enemy = SKSpriteNode(imageNamed: "penguinMagic")
            run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
            enemy.name = "enemyMagic"
        }
        else{
            enemy = SKSpriteNode(imageNamed: "penguin")
            run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
            enemy.name = "enemy"
        }
        
        //challenge
        let range_XPosition = Int.random(in: 64...960)
        let range1_XVelocity = Int.random(in: 8...15)
        let range2_XVelocity = Int.random(in: 3...5)
        
        let randomPosition = CGPoint(x: range_XPosition, y: -128)
        enemy.position = randomPosition
        
        let randomAngularVelocity = CGFloat.random(in: -3...3)
        let randomXVelocity: Int
        
        if randomPosition.x < 256{
            randomXVelocity = range1_XVelocity
        }else if randomPosition.x < 512{
            randomXVelocity = range2_XVelocity
        }else if randomPosition.x < 768{
            randomXVelocity = -range2_XVelocity
        }else{
            randomXVelocity = -range1_XVelocity
        }
        
        let randomYVelocity = Int.random(in: 24...32)
        
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
        enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * 40 , dy: randomYVelocity * 40)
        enemy.physicsBody?.angularVelocity = randomAngularVelocity
        enemy.physicsBody?.collisionBitMask = 0
        
        
        addChild(enemy)
        activeEnemies.append(enemy)
        
    }
    
    func subtractLife(){
        lives -= 1
        
        run(SKAction.playSoundFileNamed("wrong.caf", waitForCompletion: false))
        
        var life: SKSpriteNode
        
        if lives == 2{
           life = livesImages[0]
        }else if lives == 1{
            life = livesImages[1]
        }else{
            life = livesImages[2]
            endGame(triggeredByBomb: false)
        }
        
        life.texture = SKTexture(imageNamed: "sliceLifeGone")
        life.xScale = 1.3
        life.yScale = 1.3
        life.run(SKAction.scale(by: 1, duration: 0.1))
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if activeEnemies.count > 0 {
            for (index,node) in activeEnemies.enumerated().reversed(){
                if node.position.y < -140{
                    node.removeAllActions()

                    if node.name == "enemy" || node.name == "enemyMagic"{
                        node.name = ""
                        subtractLife()
                        
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                    }else if node.name == "bombContainer"{
                        node.name = ""
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                    }
                    
                }else{
                    if !nextSequenceQueued{
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + popupTime) {
                            [weak self] in
                            self?.tossEnemies()
                        }

                        nextSequenceQueued = true
                    }
                }
            }
        }
        
        var bombCounter = 0
        for node in activeEnemies {
            if node.name == "bombComtainer"{
                bombCounter += 1
                return
            }
        }
        
        if bombCounter == 0 {
            bombSoundEffect?.stop()
            bombSoundEffect = nil
        }
    }
    
    
    func tossEnemies(){
        guard isGameEnded == false else {return}
        popupTime *= 0.991
        chainDelay *= 0.99
        physicsWorld.speed *= 1.02
        
        let sequenceType = sequence[sequencePosition]
      
        switch sequenceType {
        case .oneNoBomb:
            createEnemy(forcebomb: .never)
            
        case .one:
            createEnemy()
        
        case .twoWithOneBomb:
            createEnemy(forcebomb: .never)
            createEnemy(forcebomb: .always)
        
        case .two:
            createEnemy()
            createEnemy()
            
        case .three:
            createEnemy()
            createEnemy()
            createEnemy()
            
        case .four:
            createEnemy()
            createEnemy()
            createEnemy()
            createEnemy()
            
        case .chain:
            createEnemy()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0))
                {[weak self] in self?.createEnemy()}
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 2))
                {[weak self] in self?.createEnemy()}
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 3))
                {[weak self] in self?.createEnemy()}
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 4))
                {[weak self] in self?.createEnemy()}
            
        case .fastChain:
            createEnemy()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0))
                {[weak self] in self?.createEnemy()}
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 2))
                {[weak self] in self?.createEnemy()}
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 3))
                {[weak self] in self?.createEnemy()}
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 4))
                {[weak self] in self?.createEnemy()}
        
        //chhallenge
        case .jackpotChain:
            createEnemy()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 14.0))
                {[weak self] in self?.createEnemy(forcebomb: .always)}
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 14.0 * 2))
                {[weak self] in self?.createEnemy(forcebomb: .jackpot)} 
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 14.0 * 3))
                {[weak self] in self?.createEnemy(forcebomb: .never)}
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 14.0 * 4))
                {[weak self] in self?.createEnemy(forcebomb: .never)}
            
        }
    
        sequencePosition += 1
        nextSequenceQueued = false
    }
    
    
    //challenge
    func gameover() {
        gameOver = SKLabelNode(fontNamed: "chalkduster")
        gameOver.position = CGPoint(x: 495, y: 384)
        gameOver.fontSize = 104
        gameOver.fontColor = .red
        gameOver.zPosition = 3
        gameOver.text = "GAME OVER"
        addChild(gameOver)
    }
}
