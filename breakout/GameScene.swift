//
//  GameScene.swift
//  breakout
//
//  Created by Andrew James Kinsey on 3/9/17.
//  Copyright © 2017 The Cabinents. All rights reserved.
// adding this for test

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    
    var ball: SKSpriteNode!
    var paddle: SKSpriteNode!
    var brick: SKSpriteNode!
    var gameOverNode: SKLabelNode!
    var starsBackground: SKSpriteNode!
    var loseZone: SKSpriteNode!
    var livesNode: SKLabelNode!
    var scoreNode: SKLabelNode!
    var levelCompleteNode: SKLabelNode!
    
    var lives = 3
    var blockCount = 0
    var score = 0
    var ballSpeed = 4
    
    override func didMove(to view: SKView)
    {
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        createGame()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if blockCount == 15
        {
            ball.physicsBody?.applyImpulse(CGVector(dx: ballSpeed, dy: ballSpeed)) //puts ball into motion
        }
        for touch in touches
        {
            let location = touch.location(in: self)
            paddle.position.x = location.x
            
        }
        
        //Game over reset
        if lives == 0
        {
            print("tap")
            scene?.removeAllChildren()
            lives = 3
            score = 0
            blockCount = 0
            ballSpeed = 4
            createGame()
        }
        
        //Level complete reset
        if blockCount == 0
        {
            scene?.removeAllChildren()
            ballSpeed += 1
            blockCount = 0
            createGame()
        }
        
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        if contact.bodyA.node?.name == "brick"
        {
            removeChildren(in: nodes(at: (contact.bodyA.node?.position)!))
            starsBackground.removeFromParent()
            createBackground()
            blockCount -= 1
            score += 10
            scoreNode.removeFromParent()
            makeScore()
            checkForLevelComplete()
        }
        else if contact.bodyB.node?.name == "brick"
        {
            removeChildren(in: nodes(at: (contact.bodyB.node?.position)!))
            //scotty & hussein
            starsBackground.removeFromParent()
            createBackground()
            blockCount -= 1
            score += 10
            scoreNode.removeFromParent()
            makeScore()
            checkForLevelComplete()
        }
        else if contact.bodyA.node?.name == "loseZone" || contact.bodyB.node?.name == "loseZone"
        {
            print("you lose")
            lifeLost()
            if lives == 0
            {
            makeGameOver()
            }
        }
    }
    
    
    func createBackground()
    {
        let stars = SKTexture(imageNamed: "stars")
        
        for i in 0...1
        {
            starsBackground = SKSpriteNode(texture: stars)
            starsBackground.zPosition = -1
            starsBackground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            starsBackground.position = CGPoint(x: 0, y: (starsBackground.size.height * CGFloat(i) - CGFloat(1 * i)))
            
            addChild(starsBackground)
            
            let moveDown = SKAction.moveBy(x: 0, y: -starsBackground.size.height, duration: 4)
            let moveReset = SKAction.moveBy(x: 0, y: starsBackground.size.height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            starsBackground.run(moveForever)
        }
    }
    
    func makeBall()
    {
        let ballDiameter = frame.width / 20
        ball = SKSpriteNode(color: UIColor.green, size: CGSize(width: ballDiameter, height: ballDiameter))
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        ball.name = "ball"
        
        ball.physicsBody = SKPhysicsBody(rectangleOf: ball.size)
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.usesPreciseCollisionDetection = true
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.contactTestBitMask = (ball.physicsBody?.collisionBitMask)!
        
        addChild(ball)
    }
    
    func makePaddle()
    {
        paddle = SKSpriteNode(color: UIColor.blue, size: CGSize(width: frame.width/4, height: frame.height/25))
        paddle.position = CGPoint(x: frame.midX, y: frame.minY + 125)
        paddle.name = "paddle"
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        addChild(paddle)
    }
    
    
    func makeLoseZone()
    {
        loseZone = SKSpriteNode(color: UIColor.black, size: CGSize(width: frame.width, height: 25))
        loseZone.position = CGPoint(x: frame.midX, y: frame.minY + 25)
        loseZone.name = "loseZone"
        loseZone.physicsBody = SKPhysicsBody(rectangleOf: loseZone.size)
        loseZone.physicsBody?.isDynamic = false
        addChild(loseZone)
    }
    
    
    
    func lifeLost()
    {
        ball.removeFromParent()
        lives -= 1
        makeBall()
        ball.physicsBody?.applyImpulse(CGVector(dx: ballSpeed , dy: ballSpeed))
        livesNode.removeFromParent()
        makeLives()
    }
    
    func makeGameOver()
    {
        gameOverNode = SKLabelNode(fontNamed: "ArialMT")
        gameOverNode.fontSize = 30
        gameOverNode.text = "Game Over"
        gameOverNode.zPosition = 15
        
        ball.removeFromParent()

        addChild(gameOverNode)
    }
    
    
    
    func creatBlocks()
    {
        let blockWidth = (Int)((frame.width - 60)/5)
        let blockHight = 20
        
        let blockEdge = blockWidth / 2
        let screenEdge = Int(frame.midX - (frame.width / 2))
        var xPosition = screenEdge + blockEdge + 10
        var yPosition = 150
        
        
        
        for rows in 1...3
        {
            for colums in 1...5
            {
                makeBrick(xPoint: xPosition, yPoint: yPosition, brickWidth: blockWidth, brickHight: blockHight)
                xPosition += (blockWidth + 10)
                blockCount += 1
            }
            xPosition = screenEdge + blockEdge + 10
            yPosition += (blockHight + 10)
        }
    }
    
    func makeBrick(xPoint: Int, yPoint: Int, brickWidth: Int, brickHight: Int)
    {
        brick = SKSpriteNode(color: UIColor.red, size: CGSize(width: brickWidth, height: brickHight))
        brick.position = CGPoint(x: xPoint, y: yPoint)
        brick.name = "brick"
        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
        brick.physicsBody?.isDynamic = false
        addChild(brick)
    }
    
    func makeLives()
    {
        livesNode = SKLabelNode(text: "Lives: ❤️❤️❤️")
        livesNode.position = CGPoint(x: -100, y: frame.maxY - 50)
        
        if lives == 2
        {
            livesNode.text = "Lives: ❤️❤️"
        }
        else if lives == 1
        {
            livesNode.text = "Lives: ❤️"
        }
        
        addChild(livesNode)
    }
    
    func makeScore()
    {
        scoreNode = SKLabelNode(text: "Score: \(score)")
        scoreNode.position = CGPoint(x: 100, y: frame.maxY - 50)
        
        addChild(scoreNode)
    }
    
    func createGame()
    {
        createBackground()
        makePaddle()
        makeLoseZone()
        makeBall()
        creatBlocks()
        makeLives()
        makeScore()
        
    }
    
    func makeLevelCompleteNode()
    {
        levelCompleteNode = SKLabelNode(text: "Level Complete!")
        levelCompleteNode.fontSize = 30
        levelCompleteNode.zPosition = 15
        
        ball.removeFromParent()
        
        addChild(levelCompleteNode)
    }
    
    func checkForLevelComplete()
    {
        if blockCount == 0
        {
            makeLevelCompleteNode()
        }
    }
}

