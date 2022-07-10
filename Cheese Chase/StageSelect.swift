//
//  StageSelect.swift
//  Cheese Chase
//
//  Created by Yk Jt on 4/13/16.
//  Copyright © 2016 Immersion ULTD. All rights reserved.
//

import SpriteKit

class StageSelect: SKScene {
   
    //MARK: variables in scope
    let background = SKSpriteNode(imageNamed: "selectBg")
    let doors = [SKSpriteNode(imageNamed: "mouseHole"),SKSpriteNode(imageNamed: "mouseHole"),SKSpriteNode(imageNamed: "mouseHole")]
    let levelNumber = [SKLabelNode(fontNamed: "Calibri"),SKLabelNode(fontNamed: "Calibri"),SKLabelNode(fontNamed: "Calibri")]
    let floor = [SKSpriteNode(imageNamed: "floor"),SKSpriteNode(imageNamed: "floor"),SKSpriteNode(imageNamed: "floor")]
    let mouse = SKSpriteNode(imageNamed: "sideMouse")
   
    var hud = CheeseHud()
    
     var counter = 0
    
    override func didMove(to view: SKView) {
        
        hud = CheeseHud(scene: self, x: frame.maxX, y: frame.maxY)!
        hud.setUpHud()
        
        setUpBackground()
        setUpMouse()
        
        //swipe recognizers
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(StageSelect.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view!.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(StageSelect.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view!.addGestureRecognizer(swipeRight)

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            for i in 0..<doors.count{
                if doors[i].frame.contains(location){
                    if(hud.hasEnoughCredits()){
                    	selectLevel(counter + i + 1)
                    }
 
                }
            }
        }
    }
    
    override func update(_ currentTimes: TimeInterval) {
        
        //update the countdown
        if(Date().timeIntervalSince(hud.rechargeTime as Date) > 600){
            hud.manageCredits()
        }
        
        hud.setTime()
        
        //update floor (only move 2 of them, 3rd is a safety for frame clips
        for i in 0..<2 {
            if(floor[i].position.x <= -frame.width){
                floor[i].position = CGPoint(x: floor[(1+i)%2].frame.maxX + floor[i].frame.width/2, y: background.frame.minY - floor[i].frame.height/2)
            }else if(floor[i].position.x >= frame.width){
                floor[i].position = CGPoint(x: floor[(1+i)%2].frame.minX - floor[i].frame.width/2, y: background.frame.minY - floor[i].frame.height/2)
            }
        }
        //update doors
        for i in 0..<3{
            if (!intersects(doors[i])) {
                if(doors[i].position.x < 0){
                    doors[i].run(SKAction.moveTo(x: frame.width/2, duration: 0))
                }else{
                    doors[i].run(SKAction.moveTo(x: -frame.width/2, duration: 0))
                }
                levelNumber[i].text = "\(counter + i+1)"
            }
        }
        
    }
    
    //MARK: setup
    func setUpBackground(){
        
        background.position = CGPoint(x:self.frame.midX , y:self.frame.maxY - background.frame.height/2)
        background.size.width = self.frame.width

        floor[0].position = CGPoint(x: frame.minX, y: background.frame.minY - floor[0].frame.height/2)
        floor[0].size.width = self.frame.width
        
        floor[1].position = CGPoint(x: frame.maxX, y: background.frame.minY - floor[1].frame.height/2)
        floor[1].size.width = self.frame.width
        
        floor[2].position = CGPoint(x: frame.midX, y: background.frame.minY - floor[1].frame.height/2)
        floor[2].size.width = self.frame.width

        
        self.addChild(background)
        self.addChild(floor[2])
        self.addChild(floor[0])
        self.addChild(floor[1])
        
        setUpDoors()
    
    }
    
    func setUpDoors(){
        
        
        let levelLabel = [SKSpriteNode(imageNamed: "levelLabel"),SKSpriteNode(imageNamed: "levelLabel"),SKSpriteNode(imageNamed: "levelLabel")]
  
        for i in 0..<doors.count{
            doors[i].position = CGPoint(x: CGFloat(-1+i)*self.frame.width/4, y: floor[0].frame.maxY + doors[i].size.height/2)
            
            levelLabel[i].position = CGPoint(x: -doors[0].frame.width/6, y : doors[0].frame.height/1.5)
            levelNumber[i].position = CGPoint(x: levelLabel[i].frame.maxX + levelLabel[i].frame.width/4, y: levelLabel[i].frame.minY)
            
            levelNumber[i].text = "\(i+1)"
            levelNumber[i].fontSize = 25
            
            levelNumber[i].fontColor = UIColor.cyan
            levelNumber[i].zRotation = CGFloat(-M_PI_4/3)
            
            doors[i].zPosition = 2
            levelLabel[i].zPosition = 2
            levelNumber[i].zPosition = 2

            doors[i].addChild(levelNumber[i])
            doors[i].addChild(levelLabel[i])
            self.addChild(doors[i])
        }
    }
    
    func setUpMouse(){
        mouse.position = CGPoint(x: doors[0].frame.minX - mouse.frame.width/2, y: doors[0].frame.minY + mouse.frame.height/3)
        mouse.zPosition = 3
        
        let bouncyMouse = SKAction.sequence([SKAction.moveBy(x: 0, y: 25, duration: 0.3), SKAction.moveBy(x: 0, y: -25, duration: 0.35)])
        mouse.run(SKAction.repeatForever(bouncyMouse))
        
        self.addChild(mouse)
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                if(counter >= 0){
                    counter -= 3
                    moveDoors(1)
                }
                break
            case UISwipeGestureRecognizer.Direction.left:
                // if(counter < 10){
                    counter += 3
                    moveDoors(-1)
                    // }
                break
            default:
                break
                
            }
        }
    }
    
    func moveDoors(_ direction: CGFloat){
        let moveAction = SKAction.moveBy(x: direction*self.frame.width, y: 0, duration: 0.6)
        var adjust: SKAction
       
        for i in 0..<3{
            adjust = SKAction.moveTo(x: CGFloat(-1+i)*self.frame.width/4, duration: 0.1)
            doors[i].run(SKAction.sequence([moveAction,adjust]))
        }
        moveFloor(direction)
    }
    
    //and mouse
    func moveFloor(_ direction: CGFloat){
        let moveAction = SKAction.moveBy(x: direction*self.frame.width, y: 0, duration: 0.7)
        
        floor[0].run(moveAction)
        floor[1].run(moveAction, completion: { () -> Void in
            if(!self.floor[0].hasActions()){
               
                let mouseMove = SKAction.moveBy(x: -direction*self.frame.width, y: 0, duration: 1.2)
                let flipMouse = SKAction.scaleX(to: -direction, duration: 0.1)
                let flipAgain = SKAction.scaleX(to: 1, duration: 0.15) //used to flip mouse back when finished moving so he always faces forward
                let mouseSequence = [flipMouse, SKAction.wait(forDuration: 0.2), mouseMove, flipAgain]
                
                self.mouse.run(SKAction.sequence(mouseSequence))
            }
        })
        mouse.run(moveAction)
      }
    
    
    func selectLevel(_ level: Int){
        
        let size = self.view!.bounds.size
        let gameScene : GameScene
        //let createdLevel : Level
        
        if(level < 1){
            gameScene = TutorialScene(size: size, tLvlInt: level) //tutorial
        }
        else{
            gameScene = GameScene(size: size, lvlInt: level)
        }
    	
        let transition = SKTransition.fade(with: UIColor.black, duration: 2)
        transition.pausesOutgoingScene = false
        gameScene.scaleMode = .resizeFill
        gameScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        self.view?.presentScene(gameScene, transition: transition)
    }
    

    
 
    
    

}
