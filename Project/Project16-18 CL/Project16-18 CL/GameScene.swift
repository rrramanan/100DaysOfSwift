//
//  GameScene.swift
//  Project16-18 CL
//
//  Created by R R on 27/01/21.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel : SKLabelNode!
    var lineOne : SKSpriteNode!
    var lineTwo : SKSpriteNode!
    var lineThree : SKSpriteNode!
    var shootingObjectsThree = ["blue1","blue2","blue3","blue4","blue5","circle1","circle2","circle3","circle4","circle5","circle6","circle7"]
    var shootingObjectsTwo = ["star1","star2","star3","star4","star5","star6","ystar1","ystar2","ystar3","ystar4","ystar5","ystar6"]
    var shootingObjectsOne = ["cone1","cone2","cone3","cone4","cone5","cream1","cream2","cream3","cream4","cream5"]
   
    var gameTimer1: Timer?
    var gameTimer2: Timer?
    var gameTimer3: Timer?
    
    var catridgeOne: SKLabelNode!
    var catridgeTwo: SKLabelNode!
    var catridgeThree: SKLabelNode!
    
    var reloadOne: SKSpriteNode!
    var reloadTwo: SKSpriteNode!
    var reloadThree: SKSpriteNode!
    
    var gameOver: SKLabelNode!
    
    var timeRemaining: SKLabelNode!
    var gameTimer: Timer?
    var timeEnd = 60{
        didSet{
            timeRemaining.text = "Time: \(timeEnd)"
        }
    }
    
    var score = 0{
        didSet{
           // print("score: \(score)")
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var cOneScore = 6{
        didSet{
            catridgeOne.text = "Bullets: \(cOneScore)"
        }
    }
    
    var cTwoScore = 6{
        didSet{
            catridgeTwo.text = "Bullets: \(cTwoScore)"
        }
    }
    
    var cThreeScore = 6{
        didSet{
            catridgeThree.text = "Bullets: \(cThreeScore) "
        }
    }
    
    var titleOne: SKLabelNode!
    var titleTwo: SKLabelNode!
    var titleThree: SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        backgroundColor = .black
        
        lineOne = SKSpriteNode(color: .gray, size: CGSize(width: 1450, height: 20))
        lineOne.position = CGPoint(x: 300, y: 80)
        lineOne.physicsBody?.contactTestBitMask = 1
        lineOne.name = "lineone"
        lineOne.physicsBody?.affectedByGravity = false
        addChild(lineOne)
        
        lineTwo = SKSpriteNode(color: .gray, size: CGSize(width: 1450, height: 20))
        lineTwo.position = CGPoint(x: 300, y: 320)
        lineTwo.physicsBody?.contactTestBitMask = 1
        lineTwo.name = "linetwo"
        lineTwo.physicsBody?.affectedByGravity = false
        addChild(lineTwo)
        
        lineThree = SKSpriteNode(color: .gray, size: CGSize(width: 1450, height: 20))
        lineThree.position = CGPoint(x: 300, y: 560)
        lineThree.physicsBody?.contactTestBitMask = 1
        lineThree.name = "linethree"
        lineThree.physicsBody?.affectedByGravity = false
        addChild(lineThree)
        
        scoreLabel = SKLabelNode(fontNamed: "chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.text = "Score: 0"
        addChild(scoreLabel)
        
        catridgeOne = SKLabelNode(fontNamed: "chalkduster")
        catridgeOne.position = CGPoint(x: 16, y: 270)
        catridgeOne.horizontalAlignmentMode = .left
        catridgeOne.text = "Bullets: 6"
        addChild(catridgeOne)
        
        catridgeTwo = SKLabelNode(fontNamed: "chalkduster")
        catridgeTwo.position = CGPoint(x: 16, y: 510)
        catridgeTwo.horizontalAlignmentMode = .left
        catridgeTwo.text = "Bullets: 6"
        addChild(catridgeTwo)
        
        catridgeThree = SKLabelNode(fontNamed: "chalkduster")
        catridgeThree.position = CGPoint(x: 16, y: 730)
        catridgeThree.horizontalAlignmentMode = .left
        catridgeThree.text = "Bullets: 6"
        addChild(catridgeThree)
        
        reloadOne = SKSpriteNode(imageNamed: "reload")
        reloadOne.position = CGPoint(x: 990, y: 280)
        reloadOne.size = CGSize(width: 30, height: 30)
        reloadOne.physicsBody = SKPhysicsBody(texture: reloadOne.texture!, size: reloadOne.size)
        reloadOne.physicsBody?.contactTestBitMask = 1
        reloadOne.zPosition = 1
        reloadOne.name = "reloadone"
        addChild(reloadOne)
        
        reloadTwo = SKSpriteNode(imageNamed: "reload")
        reloadTwo.position = CGPoint(x: 990, y: 522)
        reloadTwo.size = CGSize(width: 30, height: 30)
        reloadTwo.physicsBody = SKPhysicsBody(texture: reloadOne.texture!, size: reloadOne.size)
        reloadTwo.physicsBody?.contactTestBitMask = 1
        reloadTwo.zPosition = 1
        reloadTwo.name = "reloadtwo"
        addChild(reloadTwo)
        
        reloadThree = SKSpriteNode(imageNamed: "reload")
        reloadThree.position = CGPoint(x: 990, y: 755)
        reloadThree.size = CGSize(width: 30, height: 30)
        reloadThree.physicsBody = SKPhysicsBody(texture: reloadOne.texture!, size: reloadOne.size)
        reloadThree.physicsBody?.contactTestBitMask = 1
        reloadThree.zPosition = 1
        reloadThree.name = "reloadthree"
        addChild(reloadThree)
     
        timeRemaining  = SKLabelNode(fontNamed: "chalkduster")
        timeRemaining.position  = CGPoint(x: 1020, y: 16)
        timeRemaining.horizontalAlignmentMode = .right
        timeRemaining.text = "Time: 60"
        addChild(timeRemaining)
        
        titleOne = SKLabelNode(fontNamed: "sanfransico")
        titleOne.position = CGPoint(x: 536, y: 273)
        titleOne.horizontalAlignmentMode  = .center
        titleOne.text = "Hit The Cone"
        titleOne.fontSize = 18
        titleOne.zPosition = 1
        addChild(titleOne)
        
        titleTwo = SKLabelNode(fontNamed: "sanfransico")
        titleTwo.position = CGPoint(x: 536, y: 514)
        titleTwo.horizontalAlignmentMode  = .center
        titleTwo.text = "Hit The Yellow Star"
        titleTwo.fontSize = 18
        titleTwo.zPosition = 1
        addChild(titleTwo)
        
        titleThree = SKLabelNode(fontNamed: "sanfransico")
        titleThree.position = CGPoint(x: 536, y: 733)
        titleThree.horizontalAlignmentMode  = .center
        titleThree.text = "Hit The Blue Circle"
        titleThree.fontSize = 18
        titleThree.zPosition = 1
        addChild(titleThree)
        
        gameTimer1 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(createObjectsOne), userInfo: nil, repeats: true)
        
        gameTimer2 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(createObjectsTwo), userInfo: nil, repeats: true)
        
        gameTimer3 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(createObjectsThree), userInfo: nil, repeats: true)
        
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(gameEnd), userInfo: nil, repeats: true)
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
    }
    
    @objc func gameEnd(){
        timeEnd -= 1
        
        if timeEnd <= 0{
            timeEnd = 0
            gameTimer?.invalidate()
            gameTimer1?.invalidate()
            gameTimer2?.invalidate()
            gameTimer3?.invalidate()
            
            guard let obj1 = objOne else {return}
            guard let obj2 = objTwo else {return}
            guard let obj3 = objThree else {return}
            
            obj1.removeFromParent()
            obj2.removeFromParent()
            obj3.removeFromParent()
         
            gameover()
            
        }
        
    }
    
   var objOne: SKSpriteNode!
   @objc func createObjectsOne(){
        guard let randomObj = shootingObjectsOne.randomElement() else {return}

        objOne = SKSpriteNode(imageNamed: randomObj)
        objOne.position = CGPoint(x: 100 , y:150)
        if randomObj == "cone1" || randomObj == "cone2" || randomObj == "cone3" || randomObj == "cone4" ||
            randomObj == "cone5"{
            
          //  objOne.name = "goodCone"
            let image = UIImage(named: randomObj)
            if (image?.size.width)! > 140.0 {
                objOne.speed = 1.0
                objOne.name = "goodCone"
            }else{
                objOne.speed = 1.23
                objOne.name = "goodConeSuper"
            }
        
        }else{
            objOne.name = "notCone"
        }
        objOne.zPosition = -1
        addChild(objOne)

        objOne.physicsBody = SKPhysicsBody(texture: objOne.texture!, size: objOne.size)
        objOne.physicsBody?.contactTestBitMask = 1
    
        let run = SKAction.moveBy(x: 1024, y: 0, duration: 4.0)
        let remove = SKAction.removeFromParent()
        
        let sequence = SKAction.sequence([run,remove])
        objOne.run(sequence)
    
    }
    
    var objTwo: SKSpriteNode!
    @objc func createObjectsTwo(){
        guard let randomObjTwo = shootingObjectsTwo.randomElement() else {return}

        objTwo = SKSpriteNode(imageNamed: randomObjTwo)
        objTwo.position = CGPoint(x: 1024 , y:400)
        if randomObjTwo == "ystar1" || randomObjTwo == "ystar2" || randomObjTwo == "ystar3" || randomObjTwo == "ystar4" ||
            randomObjTwo == "ystar5" || randomObjTwo == "ystar6"{
           // objTwo.name = "goodStar"
            
            let image = UIImage(named: randomObjTwo)
            if (image?.size.width)! > 140.0 {
                objTwo.speed = 1.0
                objTwo.name = "goodStar"
            }else{
                objTwo.speed = 1.23
                objTwo.name = "goodStarSuper"
            }
            
        }else{
            objTwo.name = "notStar"
        }
        objTwo.zPosition = -1
        addChild(objTwo)
        
        objTwo.physicsBody = SKPhysicsBody(texture: objTwo.texture!, size: objTwo.size)
        objTwo.physicsBody?.contactTestBitMask = 1
        
        let run = SKAction.moveBy(x: -1024, y: 0, duration: 4.0)
        let remove = SKAction.removeFromParent()
        
        let sequence = SKAction.sequence([run,remove])
        objTwo.run(sequence)
        
    }
    
    var objThree: SKSpriteNode!
    @objc func createObjectsThree(){
        guard let randomObjThree = shootingObjectsThree.randomElement() else {return}
        
        objThree = SKSpriteNode(imageNamed: randomObjThree)
        objThree.position = CGPoint(x: 100 , y:640)
        if randomObjThree == "blue1" || randomObjThree == "blue2" || randomObjThree == "blue3" || randomObjThree == "blue4" ||
            randomObjThree == "blue5" {
            //objThree.name = "goodBlue"
            
            let image = UIImage(named: randomObjThree)
            if (image?.size.width)! > 140{
                objThree.speed = 1.0
                objThree.name = "goodBlue"
            }else{
                objThree.speed = 1.23
                objThree.name = "goodBlueSuper"
            }
            
        }else{
            objThree.name = "notBlue"
        }
        objThree.zPosition = -1
        addChild(objThree)
      
        
        objThree.physicsBody = SKPhysicsBody(texture: objThree.texture!, size: objThree.size)
        objThree.physicsBody?.contactTestBitMask = 1
      
      
        let run = SKAction.moveBy(x: 1024, y: 0, duration: 4.0)
        let remove = SKAction.removeFromParent()
        
        let sequence = SKAction.sequence([run,remove])
        objThree.run(sequence)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        for node in children{
            if node.position.x > 1450{
                node.removeFromParent()
            }else if node.position.x < -300{
                node.removeFromParent()
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
    
        let  location = touch.location(in: self)
        
        let objects = nodes(at: location)
        
        if objects.contains(reloadOne){
            print("reload one")
            if cOneScore == 0 {
                cOneScore = 6
            }
        }else if objects.contains(reloadTwo){
            print("reload two")
            if cTwoScore == 0 {
                cTwoScore = 6
            }
        }else if objects.contains(reloadThree){
            print("reload three")
            if cThreeScore == 0 {
                cThreeScore = 6
            }
        }
        
        
        guard let obj1 = objOne else {return}
        guard let obj2 = objTwo else {return}
        guard let obj3 = objThree else {return}
        
        if objects.contains(obj1){
             cOneScore -= 1
            
            if cOneScore > 0{
                emitter(at: obj1.position)
                if obj1.name == "goodCone"{
                    score += 1
                }else if obj1.name == "notCone"{
                    score -= 1
                }else if obj1.name == "goodConeSuper"{
                    score += 5
                }
                
                obj1.removeFromParent()
                
            }else{
                cOneScore = 0
            }
            
        }
        
        if  objects.contains(obj2){
            print(obj2.name!)
            cTwoScore -= 1
            
            if cTwoScore > 0{
                emitter(at: obj2.position)
                if obj2.name == "goodStar"{
                    score += 1
                }else if obj2.name == "notStar"{
                    score -= 1
                }else if obj2.name == "goodStarSuper"{
                    score +=  5
                }
                
                obj2.removeFromParent()
                
            }else{
                cTwoScore = 0
            }
            
        }
        
        
        if objects.contains(obj3){
            cThreeScore -= 1
            
            if cThreeScore > 0{
                emitter(at: obj3.position)
                if obj3.name == "goodBlue"{
                    score += 1
                }else if obj3.name == "notBlue"{
                    score -= 1
                }else if obj3.name == "goodBlueSuper"{
                    score +=  5
                }
                
                obj3.removeFromParent()
                
            }else{
                cThreeScore = 0
            }
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
    
    func emitter(at obj:CGPoint){
        let emitter = SKEmitterNode(fileNamed: "fire")!
        emitter.position = obj
        addChild(emitter)
        
        let delay = SKAction.wait(forDuration: 0.3)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([delay,remove])
        emitter.run(sequence)
    }
    
}
