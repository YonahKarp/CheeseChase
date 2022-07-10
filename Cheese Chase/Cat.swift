//
//  Cat.swift
//  Cheese Chase
//
//  Created by Yk Jt on 6/17/16.
//  Copyright © 2016 Immersion ULTD. All rights reserved.
//


import Foundation
import SpriteKit

class Cat: Player {
    
    var prevMove = ""
    var direction = 0
    
    init?(scene: GameScene, x: Int, y: Int) {
        super.init(imageNamed: "cat", scene: scene, x: x, y: y)
        
        zPosition = 4
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func takeTurn(){
        run(AI(), completion: { () -> Void in
            self.updatePosition()
            self.run(self.AI(), completion: { () -> Void in
                self.updatePosition()
                
                self.prevMove = ""
                self.gameScene.catsTurn = false

                self.gameScene.checkGameOver()
            })
        })
    }
    
    func takeTurnOne(){
        run(AI(), completion: { () -> Void in
            self.updatePosition()
            self.gameScene.checkGameOver()
        })
    }
    
    func takeTurnTwo(){
        run(SKAction.wait(forDuration: 2), completion: { () -> Void in
            self.run(self.AI(), completion: { () -> Void in
                self.updatePosition()
                self.prevMove = ""
                self.gameScene.catsTurn = false
                self.gameScene.checkGameOver()
            })
        })
    }

    
    func AI() -> SKAction{
        
        var action = SKAction()
        let nullAction = SKAction.wait(forDuration: 0)
        
        let distY = CGFloat(gameScene.mouse.y - y);
        let distX = CGFloat(gameScene.mouse.x - x);
        
        let directionX = distX < 0 ? "left" : distX == 0 ? "null" : "right"
        let directionY = distY < 0 ? "down" : distY == 0 ? "null" : "up"
        
        
        let moveX = !pathBlocked2(directionX, target: self)
        let moveY = !pathBlocked2(directionY, target: self)
        
        //if you can't move on both, return no action
        if(!moveY && !moveX){
            direction = 0
            return nullAction
        }
        
        //special case so cat isn't /that/ stupid
        if(abs(distY*distX) == 1 && prevMove == ""){
            return specialAI(distX, y: distY)
        }
        
        //this if summerizes all the cases the cat should move on Y, else it moves on X (When both start equal, it moves on X)
        if((abs(distY) > abs(distX) || (abs(distY) == abs(distX) && prevMove == "x") || !moveX) && moveY){
            action = move(CGFloat(0), y: boxHeight*distY.getSign())
        }else{
            action = move(boxWidth*distX.getSign(), y: CGFloat(0))
        }
        
        return action
    }
    
    func specialAI(_ x: CGFloat, y: CGFloat) -> SKAction{
        
        let directionX = x < 0 ? "left" : "right"
        let directionY = y < 0 ? "down" : "up"
       
        let moveX = !pathBlocked2(directionX, target: self)
        let moveY = !pathBlocked2(directionY, target: self)
        
        let moveY2 = !pathBlockedSpecialAI(x, y: y, direction: directionX, target: self)
        
        if ((moveY && moveY2) || !moveX ){
            return move(CGFloat(0), y: boxHeight*y)
        }
        
        return move(boxWidth*x, y: CGFloat(0))
    }
    
    
    func move(_ x: CGFloat, y: CGFloat) -> SKAction{
        if(x == 0){
            prevMove = "y"
            direction = Int(y.getSign())
        }else{
            prevMove = "x"
            direction = Int(x.getSign())
        }
        return SKAction.moveBy(x: x, y: y, duration: 0.2)
    }
    
    
    func updatePosition(){
        if(prevMove == "x"){
            x += direction
        }else{
            y += direction
        }
    }
    
}
