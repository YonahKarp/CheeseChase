//
//  Mouse.swift
//  Cheese Chase
//
//  Created by Yk Jt on 6/19/16.
//  Copyright © 2016 Immersion ULTD. All rights reserved.
//

import Foundation
import SpriteKit

class Mouse : Player {
    
    //var node = SKSpriteNode(imageNamed: )
    
    init?(scene: GameScene, x: Int, y: Int) {
        super.init(imageNamed: "mouse", scene: scene, x: x, y: y)
        
        xScale = 0.4
        yScale = 0.4
        zPosition = 4
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    //func move(x: CGFloat, y: CGFloat, angle: CGFloat){
    func move(_ x: CGFloat, y: CGFloat, angle: CGFloat, direction: String){
        var moveAction = SKAction()
        let rotateAction = SKAction.rotate(toAngle: angle, duration: 0)
        
        //if(pathBlocked(x, y: y, target: node)){
        if(pathBlocked2(direction, target: self)){
            run(rotateAction)
            return
        }
        moveAction = SKAction.moveBy(x: x, y: y, duration: 0.2)
        
        gameScene.catsTurn = true
        run(SKAction.sequence([rotateAction, moveAction]), completion: { ()-> Void in
            self.x += Int(x.getSign())
            self.y += Int(y.getSign())
            if(self.gameScene.checkWin()){
                return
            }
            self.gameScene.checkCheese()
            
            self.gameScene.checkTutorial()
            
            //Cat takes turn
            if(self.gameScene.catsTurn){ //we may turn off cat's turn in tutorial
                self.gameScene.cat.takeTurn()
            }
            
            
        })
    }
    
}
