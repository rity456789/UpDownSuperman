//
//  GameScene.swift
//  simpleFlappyBird
//
//  Created by Phan Hải Bình on 11/29/18.
//  Copyright © 2018 Phan Hải Bình. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var gameViewController: GameViewController!
    
    var isGameStarted = Bool(false)
    var isDied = Bool(false)
    let coinSound = SKAction.playSoundFileNamed("ScoreSound.mp3", waitForCompletion: false)
    
    var score = Int(0)
    var scoreLbl = SKLabelNode()
    var highscoreLbl = SKLabelNode()
    var taptoplayLbl = SKLabelNode()
    var restartBtn = SKSpriteNode()
    var homeBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    var logoImg = SKSpriteNode()
    var wallPair = SKNode()
    var moveAndRemove = SKAction()
    var countforEmpty = Int(0)
    
    var isShield = Bool(false)
    var countForDouble = Int(0)

    var bird = SKSpriteNode()
    
    //Check player up or down
    var isDown = Bool(false)
    
    //Name of character
    var character = GlobalCharacter.character
    
    
    override func didMove(to view: SKView) {
        createScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameStarted == false{
            
            isGameStarted =  true
            bird.physicsBody?.affectedByGravity = true
            createPauseBtn()
            
            logoImg.run(SKAction.scale(to: 0.5, duration: 0.3), completion: {
                self.logoImg.removeFromParent()
            })
            taptoplayLbl.removeFromParent()
            
            
            let spawn = SKAction.run({
                () in
                self.wallPair = self.createWalls()
                self.addChild(self.wallPair)
            })
            
            let delay = SKAction.wait(forDuration: TimeInterval(self.frame.height/444))
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(spawnDelayForever)
            
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let movePillars = SKAction.moveBy(x: -distance - (self.frame.width/8), y: 0, duration: TimeInterval(0.008 * distance))
            let removePillars = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePillars, removePillars])
            
            self.physicsWorld.gravity = CGVector(dx: 0, dy: self.frame.height/222)
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: (self.frame.height/30)))
            isDown = true
        } else {
            //4
            if isDied == false {
                if isDown == true {
                    isDown = false
                    self.physicsWorld.gravity = CGVector(dx: 0, dy: -self.frame.height/222)
                    bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -(self.frame.height/30)))
                }
                else
                {
                    isDown = true
                    self.physicsWorld.gravity = CGVector(dx: 0, dy: self.frame.height/222)
                    bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: (self.frame.height/30)))
                }
            }
        }
        for touch in touches{
            let location = touch.location(in: self)
            //1
            if isDied == true{
                if restartBtn.contains(location){
                    if UserDefaults.standard.object(forKey: "highestScore") != nil {
                        let hscore = UserDefaults.standard.integer(forKey: "highestScore")
                        if hscore < Int(scoreLbl.text!)!{
                            UserDefaults.standard.set(scoreLbl.text, forKey: "highestScore")
                        }
                    } else {
                        UserDefaults.standard.set(0, forKey: "highestScore")
                    }
                    restartScene()
                }
                else if homeBtn.contains(location)
                {
                    if UserDefaults.standard.object(forKey: "highestScore") != nil {
                        let hscore = UserDefaults.standard.integer(forKey: "highestScore")
                        if hscore < Int(scoreLbl.text!)!{
                            UserDefaults.standard.set(scoreLbl.text, forKey: "highestScore")
                        }
                    } else {
                        UserDefaults.standard.set(0, forKey: "highestScore")
                    }
                    self.removeAllActions()
                    self.removeAllChildren()
                    
                    gameViewController.goHome()
                    
                }
            } else {
                //2
                if pauseBtn.contains(location){
                    if self.isPaused == false{
                        self.isPaused = true
                        pauseBtn.texture = SKTexture(imageNamed: "play")
                    } else {
                        self.isPaused = false
                        pauseBtn.texture = SKTexture(imageNamed: "pause")
                    }
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if isGameStarted == true{
            if isDied == false{
                enumerateChildNodes(withName: "background", using: ({
                    (node, error) in
                    let bg = node as! SKSpriteNode
                    bg.position = CGPoint(x: bg.position.x - (self.frame.height/333), y: bg.position.y)
                    if bg.position.x <= -bg.size.width {
                        bg.position = CGPoint(x:bg.position.x + bg.size.width * 6, y:bg.position.y)
                    }
                }))
            }
        }
    }
    
    
    func createScene(){
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CollisionBitMask.groundCategory
        self.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        self.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        for i in 0..<2
        {
            let background = SKSpriteNode(imageNamed: "bgDay")
            background.anchorPoint = CGPoint.init(x: 0, y: 0)
            background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
        }
        
        for i in 2..<3
        {
            let background = SKSpriteNode(imageNamed: "bgDayToNight")
            background.anchorPoint = CGPoint.init(x: 0, y: 0)
            background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
        }
        
        for i in 3..<5
        {
            let background = SKSpriteNode(imageNamed: "bgNight")
            background.anchorPoint = CGPoint.init(x: 0, y: 0)
            background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
        }
        
        for i in 5..<6
        {
            let background = SKSpriteNode(imageNamed: "bgNightToDay")
            background.anchorPoint = CGPoint.init(x: 0, y: 0)
            background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
        }
        
        

        
        self.bird = createBird()
        self.addChild(bird)
        
        
        
        scoreLbl = createScoreLabel()
        self.addChild(scoreLbl)
        
        highscoreLbl = createHighscoreLabel()
        self.addChild(highscoreLbl)
        
        createLogo()
        
        taptoplayLbl = createTaptoplayLabel()
        self.addChild(taptoplayLbl)
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        //Truong hop va cham cac cot hoac cham dat
        if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.pillarCategory || firstBody.categoryBitMask == CollisionBitMask.pillarCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory || firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.groundCategory || firstBody.categoryBitMask == CollisionBitMask.groundCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory{
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                if self.isShield == true
                {
                    
                }
                else
                {
                    node.speed = 0
                    self.removeAllActions()
                    self.physicsWorld.gravity = CGVector(dx: 0, dy: -self.frame.height/111)
                }
                
            }))
            
            
            
            if isDied == false && isShield == false {
                isDied = true
                createRestartBtn()
                pauseBtn.removeFromParent()
            }
            if (isShield == true)
            {
                isShield = false
                
                //self.bird.texture = SKTexture(imageNamed: character)
                self.bird.texture = SKTexture(image: GlobalCharacter.character)
                if (firstBody.categoryBitMask == CollisionBitMask.pillarCategory)
                {
                    firstBody.node?.removeFromParent()                }
                else if secondBody.categoryBitMask == CollisionBitMask.pillarCategory{
                    secondBody.node?.removeFromParent()
                }
                else if secondBody.categoryBitMask == CollisionBitMask.groundCategory || firstBody.categoryBitMask == CollisionBitMask.groundCategory
                {
                    if isDown == true {
                        isDown = false
                        self.physicsWorld.gravity = CGVector(dx: 0, dy: -self.frame.height/222)
                        bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -(self.frame.height/30)))
                    }
                    else
                    {
                        isDown = true
                        self.physicsWorld.gravity = CGVector(dx: 0, dy: self.frame.height/222)
                        bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: (self.frame.height/30)))
                    }
                }
                
            }
        } //Truong hop an diem
        else if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.flowerCategory {
            run(coinSound)
            if (countForDouble > 0){
                countForDouble -= 1
                score += 2
            }
            else {
                score += 1
            }
            scoreLbl.text = "\(score)"
            secondBody.node?.removeFromParent()
        } //Truong hop an diem
        else if firstBody.categoryBitMask == CollisionBitMask.flowerCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            run(coinSound)
            if (countForDouble > 0){
                countForDouble -= 1
                score += 2
            }
            else {
                score += 1
            }
            scoreLbl.text = "\(score)"
            firstBody.node?.removeFromParent()
        }
            //Truong hop an double icon
        else if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.doubleCategory {
            run(coinSound)
            if (countForDouble > 0){
                countForDouble -= 1
                score += 2
            }
            else {
                score += 1
            }
            countForDouble = 5  //5 bong hoa tiep theo se duoc 2 diem
            scoreLbl.text = "\(score)"
            secondBody.node?.removeFromParent()
            createNotice(notice: "Double point")
        } //Truong hop an double icon
        else if firstBody.categoryBitMask == CollisionBitMask.doubleCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            run(coinSound)
            if (countForDouble > 0){
                countForDouble -= 1
                score += 2
            }
            else {
                score += 1
            }
            countForDouble = 5  //5 bong hoa tiep theo se duoc 2 diem
            scoreLbl.text = "\(score)"
            firstBody.node?.removeFromParent()
            createNotice(notice: "Double point")
        }
            //Truong hop an shield icon
        else if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.shieldCategory {
            run(coinSound)
            if (countForDouble > 0){
                countForDouble -= 1
                score += 2
            }
            else {
                score += 1
            }
            isShield = true
            scoreLbl.text = "\(score)"
            secondBody.node?.removeFromParent()
            self.bird.texture = SKTexture(image: GlobalCharacter.detail.shield)
            createNotice(notice: "Super shield")
        } //Truong hop an shield icon
        else if firstBody.categoryBitMask == CollisionBitMask.shieldCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            run(coinSound)
            if (countForDouble > 0){
                countForDouble -= 1
                score += 2
            }
            else {
                score += 1
            }
            isShield = true
            scoreLbl.text = "\(score)"
            firstBody.node?.removeFromParent()
            self.bird.texture = SKTexture(image: GlobalCharacter.detail.shield)
            createNotice(notice: "Super shield")
        }
            //Truong hop an empty world icon
        else if firstBody.categoryBitMask == CollisionBitMask.emptyCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            run(coinSound)
            if (countForDouble > 0){
                countForDouble -= 1
                score += 2
            }
            else {
                score += 1
            }
            countforEmpty = 3
            scoreLbl.text = "\(score)"
            firstBody.node?.removeFromParent()
            createNotice(notice: "Empty world")
        }
            //Truong hop an empty world icon
        else if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.emptyCategory {
            run(coinSound)
            if (countForDouble > 0){
                countForDouble -= 1
                score += 2
            }
            else {
                score += 1
            }
            countforEmpty = 3
            scoreLbl.text = "\(score)"
            secondBody.node?.removeFromParent()
            createNotice(notice: "Empty world")
        }
    }
    
    
    func restartScene(){
        self.removeAllChildren()
        self.removeAllActions()
        isDied = false
        isGameStarted = false
        score = 0
        createScene()
        isShield = false
        countForDouble = 0
        countforEmpty = 0
    }
    
    
}

