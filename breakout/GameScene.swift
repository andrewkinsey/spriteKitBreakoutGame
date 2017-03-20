//
//  GameScene.swift
//  breakout
//
//  Created by Andrew James Kinsey on 3/9/17.
//  Copyright © 2017 The Cabinents. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    
    var ball: SKSpriteNode!
    var paddle: SKSpriteNode!
    var brick: SKSpriteNode!
    var gameOverNode: SKLabelNode!
    var gameOverBackground: SKSpriteNode!
    var lives = 3
    
    override func didMove(to view: SKView)
    {
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        createBackground()
        makePaddle()
        makeLoseZone()
        makeBall()
        creatBlocks()
        ball.physicsBody?.applyImpulse(CGVector(dx: 4, dy: 4)) //puts ball into motion


        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self)
            paddle.position.x = location.x


//                check to see if the touch is in the gameoverbackground.

            
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
        if contact.bodyA.node?.name == "brick" || contact.bodyB.node?.name == "brick"
        {
            print("brick hit")
            brick.removeFromParent()
        }
        else if contact.bodyA.node?.name == "loseZone" || contact.bodyB.node?.name == "loseZone"
        {
            print("you lose")
            lifeLost()
            if lives == 0
            {
            resetGame()
            }
        }
    }
    
    
    func createBackground()
    {
        let stars = SKTexture(imageNamed: "stars")
        
        for i in 0...1
        {
            let starsBackground = SKSpriteNode(texture: stars)
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
        let loseZone = SKSpriteNode(color: UIColor.black, size: CGSize(width: frame.width, height: 25))
        loseZone.position = CGPoint(x: frame.midX, y: frame.minY + 25)
        loseZone.name = "loseZone"
        loseZone.physicsBody = SKPhysicsBody(rectangleOf: loseZone.size)
        loseZone.physicsBody?.isDynamic = false
        addChild(loseZone)
    }
    
    func resetGame()
    {
        ball.removeFromParent()
        makeGameOver()
        makeGameOverBackground()
        makeBall()
        
    }
    
    func lifeLost()
    {
        lives -= 1
    }
    
    func makeGameOver()
    {
        gameOverNode = SKLabelNode(fontNamed: "ArielMT")
        gameOverNode.fontSize = 30
        gameOverNode.text = "Game Over"
        gameOverNode.zPosition = 15

        addChild(gameOverNode)
    }
    
    func makeGameOverBackground()
    {
        let gameOverBackground = SKSpriteNode(color: UIColor.red, size: CGSize(width: frame.width, height: frame.height))
        gameOverBackground.zPosition = 10
        
        addChild(gameOverBackground)
    }
    
    func creatBlocks()
    {
        var xPosition = -150
        var yPosition = 150
        
        let blockWidth = (Int)((frame.width - 60)/5)
        let blockHight = 20
        
        for rows in 1...3
        {
            for colums in 1...5
            {
                makeBrick(xPoint: xPosition, yPoint: yPosition, brickWidth: blockWidth, brickHight: blockHight)
                xPosition += (blockWidth + 10)
            }
            xPosition = -150
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
}

