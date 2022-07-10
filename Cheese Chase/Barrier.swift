//
//  Barrier.swift
//  Cheese Chase
//
//  Created by Yonah Karp on 9/30/16.
//  Copyright © 2016 Immersion ULTD. All rights reserved.
//

import Foundation
import SpriteKit

class Barrier: SKSpriteNode{
    
    var parentScene : SKScene
    var type : String
    var x : Int
    var y : Int
    
    //empty init
    init(){
        type = "null"
        x = 0
        y = 0
        parentScene = SKScene()
        
        let texture = SKTexture(imageNamed: "")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
    }
    
    init(imageNamed: String, parentScene: SKScene, type: String, x : Int, y: Int){
        self.parentScene = parentScene
        
        self.type = type
        
        self.x = x
        self.y = y
        
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        setUpBarrier()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpBarrier(){
        
        switch type {
        
        case "up":
            position = CGPoint(x: boardBeginsX + boxWidth/2 + CGFloat(x)*boxWidth, y: boardBeginsY - CGFloat(y)*boxHeight)
            zRotation = CGFloat(M_PI_2)
            size.width = 3*boxWidth/4
        case "down":
            position = CGPoint(x: boardBeginsX + boxWidth/2 + CGFloat(x)*boxWidth, y: boardBeginsY - CGFloat(y)*boxHeight)
            zRotation = CGFloat(3*M_PI_2)
            size.width = 3*boxWidth/4
        case "horizontal":
            position = CGPoint(x: boardBeginsX + boxWidth/2 + CGFloat(x)*boxWidth, y: boardBeginsY - CGFloat(y)*boxHeight)
            size.width = 3*boxWidth/4
            
        case "vertical":
           position = CGPoint(x: boardBeginsX + CGFloat(x)*boxWidth, y:(boardBeginsY + boxHeight/2) - CGFloat(y)*boxHeight)
           zRotation = CGFloat(M_PI/2)
           size.width = boxHeight
        case "right":
            position = CGPoint(x: boardBeginsX + CGFloat(x)*boxWidth, y:(boardBeginsY + boxHeight/2) - CGFloat(y)*boxHeight)
            size.width = boxHeight
        case "left":
           position = CGPoint(x: boardBeginsX + CGFloat(x)*boxWidth, y:(boardBeginsY + boxHeight/2) - CGFloat(y)*boxHeight)
           zRotation = CGFloat(M_PI)
           size.width = boxHeight
       
        
        case "holeVert":
            let adjust = (x == 0 ? boxWidth/2 : -boxWidth/2)
            position = CGPoint(x: boardBeginsX + CGFloat(x)*boxWidth + adjust, y:(boardBeginsY + boxHeight/2) - CGFloat(y)*boxHeight)
            zRotation = (x == 0 ? CGFloat(3*M_PI/2) : CGFloat(M_PI/2))
            
            size = CGSize(width: (boxHeight + boxWidth)/3, height: (boxHeight + boxWidth)/3)
            
            
        case "holeHorz":
            let adjust = (y == 6 ? boxHeight/2 : -boxHeight/2)
            position = CGPoint(x: boardBeginsX + boxWidth/2 + CGFloat(x)*boxWidth, y: boardBeginsY - CGFloat(y)*boxHeight + adjust)
            //zRotation = (y == 0 ? CGFloat(M_PI) : CGFloat(M_PI/2))
            size = CGSize(width: (boxHeight + boxWidth)/2, height: (boxHeight + boxWidth)/3)
        default:
            print("error in parsing barrier type. Type is give as \(type)")
        }
        
        zPosition = 3
        parentScene.addChild(self)

    }
    
    
}
