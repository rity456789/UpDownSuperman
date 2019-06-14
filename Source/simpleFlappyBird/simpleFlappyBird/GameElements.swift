//
//  GameElements.swift
//  simpleFlappyBird
//
//  Created by Phan Hải Bình on 11/29/18.
//  Copyright © 2018 Phan Hải Bình. All rights reserved.
//

import Foundation
import SpriteKit

struct CollisionBitMask {
    static let birdCategory:UInt32 = 0x1 << 0
    static let pillarCategory:UInt32 = 0x1 << 1
    static let flowerCategory:UInt32 = 0x1 << 2
    static let groundCategory:UInt32 = 0x1 << 3
    static let doubleCategory:UInt32 = 0x1 << 4
    static let shieldCategory:UInt32 = 0x1 << 5
    static let emptyCategory:UInt32 = 0x1 << 6
}

extension GameScene {
    
    //createBird
    func createBird() -> SKSpriteNode {
        //1
        let bird = SKSpriteNode(texture: SKTexture(image: GlobalCharacter.character))
        //let bird = SKSpriteNode(
        bird.size = CGSize(width: self.frame.height/13, height: self.frame.height/13)
        bird.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        //2
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width / 2)
        bird.physicsBody?.linearDamping = 1.1
        bird.physicsBody?.restitution = 0
        //3
        bird.physicsBody?.categoryBitMask = CollisionBitMask.birdCategory
        bird.physicsBody?.collisionBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.groundCategory
        bird.physicsBody?.contactTestBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.flowerCategory | CollisionBitMask.groundCategory | CollisionBitMask.doubleCategory | CollisionBitMask.shieldCategory | CollisionBitMask.emptyCategory
        //4
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.isDynamic = true
        
        return bird
    }
    
    
    //createRSButton
    func createRestartBtn() {
        restartBtn = SKSpriteNode(imageNamed: "restart")
        restartBtn.size = CGSize(width:self.frame.height/6.5, height:self.frame.height/6.5)
        restartBtn.position = CGPoint(x: self.frame.width / 2 - self.frame.height/6.5, y: self.frame.height / 2)
        restartBtn.zPosition = 6
        restartBtn.setScale(0)
        self.addChild(restartBtn)
        restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
        
        homeBtn = SKSpriteNode(imageNamed: "home")
        homeBtn.size = CGSize(width:self.frame.height/6.5, height:self.frame.height/6.5)
        homeBtn.position = CGPoint(x: self.frame.width / 2 + self.frame.height/6.5, y: self.frame.height / 2)
        homeBtn.zPosition = 6
        homeBtn.setScale(0)
        self.addChild(homeBtn)
        homeBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    //createPauseButton
    func createPauseBtn() {
        pauseBtn = SKSpriteNode(imageNamed: "pause")
        pauseBtn.size = CGSize(width:self.frame.height/16, height:self.frame.height/16)
        pauseBtn.position = CGPoint(x: self.frame.width - self.frame.height/22, y: self.frame.height/22)
        pauseBtn.zPosition = 6
        self.addChild(pauseBtn)
    }
    
    //createScoreLabel
    func createScoreLabel() -> SKLabelNode {
        let scoreLbl = SKLabelNode()
        scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.6)
        scoreLbl.text = "\(score)"
        scoreLbl.zPosition = 5
        scoreLbl.fontSize = self.frame.height/13
        scoreLbl.fontName = "HelveticaNeue-Bold"
        
        let scoreBg = SKShapeNode()
        scoreBg.position = CGPoint(x: 0, y: 0)
        scoreBg.path = CGPath(roundedRect: CGRect(x: CGFloat(-self.frame.height/13), y: CGFloat(-self.frame.height/22), width: CGFloat(self.frame.height/6.5), height: CGFloat(self.frame.height/6.5)), cornerWidth: self.frame.height/13, cornerHeight: self.frame.height/13, transform: nil)
        let scoreBgColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: CGFloat(0.2))
        scoreBg.strokeColor = UIColor.clear
        scoreBg.fillColor = scoreBgColor
        scoreBg.zPosition = -1
        scoreLbl.addChild(scoreBg)
        return scoreLbl
    }
    
    //createHighScoreLabel
    func createHighscoreLabel() -> SKLabelNode {
        let highscoreLbl = SKLabelNode()
        highscoreLbl.position = CGPoint(x: self.frame.width - self.frame.height/8, y: self.frame.height - self.frame.height/30)
        if let highestScore = UserDefaults.standard.object(forKey: "highestScore"){
            highscoreLbl.text = "Highest Score: \(highestScore)"
        } else {
            highscoreLbl.text = "Highest Score: 0"
        }
        highscoreLbl.zPosition = 5
        highscoreLbl.fontSize = self.frame.height/44
        highscoreLbl.fontName = "Helvetica-Bold"
        return highscoreLbl
    }
    
    //createLogo
    func createLogo() {
        logoImg = SKSpriteNode()
        logoImg = SKSpriteNode(imageNamed: "logo")
        logoImg.size = CGSize(width: self.frame.height/2.5, height: self.frame.height/7)
        logoImg.position = CGPoint(x:self.frame.midX, y:self.frame.midY + self.frame.height/7)
        logoImg.setScale(0.5)
        self.addChild(logoImg)
        logoImg.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    func createNotice(notice:String) {
        let noticeLbl = SKLabelNode()
        noticeLbl.position = CGPoint(x:self.frame.midX, y:self.frame.midY )
        noticeLbl.text = notice
        noticeLbl.fontColor = UIColor(red: 204/255, green: 0/255, blue: 0/255, alpha: 1.0)
        noticeLbl.zPosition = 5
        noticeLbl.fontSize = self.frame.height/15
        noticeLbl.fontName = "AvenirNext-Bold"
        
        noticeLbl.setScale(0)
        self.addChild(noticeLbl)
        noticeLbl.run(SKAction.scale(to: 1, duration: 0.7), completion: {
            noticeLbl.removeFromParent()
        })
    }
    
    //createTaptoplayLabel
    func createTaptoplayLabel() -> SKLabelNode {
        let taptoplayLbl = SKLabelNode()
        taptoplayLbl.position = CGPoint(x:self.frame.midX, y:self.frame.midY - self.frame.height/6)
        taptoplayLbl.text = "Tap anywhere to play"
        taptoplayLbl.fontColor = UIColor(red: 63/255, green: 79/255, blue: 145/255, alpha: 1.0)
        taptoplayLbl.zPosition = 5
        taptoplayLbl.fontSize = self.frame.height/33
        taptoplayLbl.fontName = "HelveticaNeue"
        return taptoplayLbl
    }

    func createWalls() -> SKNode  {
        // 1
        let which = Int(arc4random_uniform(5))
        var flowerNode = SKSpriteNode()
        if which == 0
        {
            flowerNode = SKSpriteNode(imageNamed: "double")
        }
        else if which == 1
        {
            flowerNode = SKSpriteNode(imageNamed: "shield")
        }
        else if which == 2
        {
            flowerNode = SKSpriteNode(imageNamed: "empty")
        }
        else{
            flowerNode = SKSpriteNode(imageNamed: "flower")
        }
        flowerNode.size = CGSize(width: self.frame.height/16, height: self.frame.height/16)
        flowerNode.position = CGPoint(x: self.frame.width + self.frame.height/26, y: self.frame.height / 2)
        flowerNode.physicsBody = SKPhysicsBody(rectangleOf: flowerNode.size)
        flowerNode.physicsBody?.affectedByGravity = false
        flowerNode.physicsBody?.isDynamic = false
        
        if which == 0
        {
            flowerNode.physicsBody?.categoryBitMask = CollisionBitMask.doubleCategory
        }
        else if which == 1
        {
            flowerNode.physicsBody?.categoryBitMask = CollisionBitMask.shieldCategory
            
        }
        else if which == 2
        {
            flowerNode.physicsBody?.categoryBitMask = CollisionBitMask.emptyCategory
            
        }
        else{
            flowerNode.physicsBody?.categoryBitMask = CollisionBitMask.flowerCategory
        }
        
        flowerNode.physicsBody?.collisionBitMask = 0
        flowerNode.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        flowerNode.color = SKColor.blue
        // 2
        
        wallPair = SKNode()
        wallPair.name = "wallPair"
        
        if (countforEmpty == 0)
        {
            let topWall = SKSpriteNode(imageNamed: "pillar")
            let btmWall = SKSpriteNode(imageNamed: "pillar")
            
            topWall.size = CGSize(width: self.frame.height/26, height: self.frame.height/1.45)
            btmWall.size = CGSize(width: self.frame.height/26, height: self.frame.height/1.45)
            
            
            
            topWall.position = CGPoint(x: self.frame.width + self.frame.height/26, y: self.frame.height / 2 + self.frame.height/2)
            btmWall.position = CGPoint(x: self.frame.width + self.frame.height/26, y: self.frame.height / 2 - self.frame.height/2)
            
            
            
            topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
            topWall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
            topWall.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
            topWall.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
            topWall.physicsBody?.isDynamic = false
            topWall.physicsBody?.affectedByGravity = false
            
            btmWall.physicsBody = SKPhysicsBody(rectangleOf: btmWall.size)
            btmWall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
            btmWall.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
            btmWall.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
            btmWall.physicsBody?.isDynamic = false
            btmWall.physicsBody?.affectedByGravity = false
            
            topWall.zRotation = CGFloat.pi
            
            wallPair.addChild(topWall)
            wallPair.addChild(btmWall)
        }
        else{
            countforEmpty -= 1
        }
            wallPair.zPosition = 1
            // 3
            let randomPosition = random(min: -self.frame.height/4.5, max: self.frame.height/4.5)
            wallPair.position.y = wallPair.position.y +  randomPosition
            wallPair.addChild(flowerNode)
            
            wallPair.run(moveAndRemove)
        
        return wallPair
    }
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min : CGFloat, max : CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
}
