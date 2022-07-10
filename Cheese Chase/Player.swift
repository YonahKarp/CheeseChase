//
//  Player.swift
//  Cheese Chase
//
//  Created by Yk Jt on 6/17/16.
//  Copyright © 2016 Immersion ULTD. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode{
    
    var x: Int
    var y: Int
    
    var gameScene : GameScene
    
    
    init?(imageNamed: String, scene: GameScene, x: Int, y:Int) {
        
        self.gameScene = scene
        self.x = x
        self.y = y
        
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /*
    func pathBlocked(x: CGFloat, y: CGFloat, target: SKNode)-> Bool{
        
        //Victory (mouse)
        if ( CGRectIntersectsRect(target.frame.offsetBy(dx: x/2, dy: y/2), gameScene.hole.frame) && gameScene.cheeseCount >= 3 ) {
            return false
        }
        
        if !CGRectIntersectsRect(target.frame.offsetBy(dx: x, dy: y), gameScene.board.frame){
            return true
        }
        
        for barrier in gameScene.barriers{
            if CGRectIntersectsRect(target.frame.offsetBy(dx: x/2, dy: y/2), barrier.frame) {
                return true
            }
        }
        
        for oneWay in gameScene.oneWays{
            if (CGRectIntersectsRect(target.frame.offsetBy(dx: x/2, dy: y/2), oneWay.frame)){
                if(oneWay.name == "right" && x.getSign() != 1){
                    return true
                }
                if(oneWay.name == "left" && x.getSign() != -1){
                    return true
                }
                
                
                if(oneWay.name == "up" && y.getSign() != 1){
                    return true
                }
                if(oneWay.name == "down" && y.getSign() != -1){
                    return true
                }
            }
        }
        
        return false
    }*/
    
    
    func pathBlocked2(_ direction : String, target: Player)-> Bool{
        let x = target.x
        let y = target.y
        var barrier : Barrier
        
        switch direction{
            case "left":
                barrier = gameScene.barriersVertical[x][y]
                if(x == 0 && barrier.type != "holeVert"){return true}
            case "right":
                barrier = gameScene.barriersVertical[x+1][y]
                if(x == 5 && barrier.type != "holeVert"){return true}
            case "down":
                barrier = gameScene.barriersHorizontal[x][y]
                if(y == 0 && barrier.type != "holeHorz"){return true}
            case "up":
                barrier = gameScene.barriersHorizontal[x][y+1]
                if(y == 5 && barrier.type != "holeHorz"){return true}
            case "null":
                return true
            default:
                barrier = gameScene.barriersVertical[0][0]
                print("error in pathBlocked. Direction was given as \(direction)")
        }
        
        //print("x = \(x) y= \(y) barrier = \(barrier.type)")
        
        
        if(barrier.type == "null" || barrier.type == direction || ((barrier.type == "holeVert" || barrier.type == "holeHorz") && gameScene.cheeseCount == 3)){
            return false
        }
        return true
    }
    
    
    func pathBlockedSpecialAI(_ x: CGFloat, y: CGFloat, direction: String, target: Player) -> Bool{
        let xAdjust = x < 0 ? target.x : target.x + 1
        let yAdjust = y < 0 ? target.y : target.y + 1
        
        let barrier = gameScene.barriersVertical[xAdjust][yAdjust]
        
        if(barrier.type == "null" || barrier.type == direction){
            return false
        }
        return true
    }
    
}

