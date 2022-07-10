//
//  CheeseHud.swift
//  Cheese Chase
//
//  Created by Yk Jt on 9/9/16.
//  Copyright © 2016 Immersion ULTD. All rights reserved.
//

import Foundation
import SpriteKit

class CheeseHud: NSObject{
    
    var scene : SKScene
    var x: CGFloat
    var y: CGFloat
    
    
    let labelCredits = SKLabelNode(fontNamed: "AvenirNextCondensed-DemiBold")
    let timerLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-DemiBold")
    let invisableLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-DemiBold")
    
    let cheeseImage = SKSpriteNode(imageNamed: "cheese")
    let frameImage = SKSpriteNode(imageNamed: "scoreBoard")
    
    let barImage = SKSpriteNode(imageNamed: "Bar")
    let emptyBarImage = SKSpriteNode(imageNamed: "EmptyBar")
    
    
    var rechargeTime = NSDate()
    var creditVal = 15
    var counter = 0
    var levelCost = 3
    

    init?(scene: SKScene, x: CGFloat, y: CGFloat) {
        self.scene = scene
        self.x = x - frameImage.frame.width/2.5
        self.y = y - frameImage.frame.height/3.5
    }
    
    init?(scene: SKScene){
        self.scene = scene
        self.x = 0
        self.y = 0
    }
    
    override init() {
        scene = SKScene()
        x = 0
        y = 0
    }
    
    
    func setUpHud(){
        
        creditVal = PlistManager.sharedInstance.getValueForKey("cheeseCredits") as! Int
        rechargeTime = PlistManager.sharedInstance.getValueForKey("rechargeTime") as! NSDate
        
        manageCredits()
        
        frameImage.position = CGPoint(x: x, y: y)
        frameImage.zPosition = 5
        
        emptyBarImage.position = CGPoint(x: cheeseImage.frame.width/4 , y: -frameImage.frame.height/12 )
        emptyBarImage.zPosition = 6
        
        
        labelCredits.text = "\(creditVal) / 15"
        labelCredits.fontSize = 12
        labelCredits.zPosition = 8
        labelCredits.position = CGPoint(x: 0 , y: emptyBarImage.frame.maxY - emptyBarImage.frame.height/12)

        
        timerLabel.text = "...."
        timerLabel.fontSize = 12
        timerLabel.zPosition = 7
        timerLabel.position =  CGPoint(x: -cheeseImage.frame.width/4 , y: emptyBarImage.frame.minY)
        
        invisableLabel.isHidden = true
        invisableLabel.zPosition = 9
        invisableLabel.fontSize = 14
        
        
        cheeseImage.position = CGPoint(x: -emptyBarImage.frame.width/2 - cheeseImage.frame.width/2, y: cheeseImage.frame.height/4)
        cheeseImage.xScale = 0.7
        cheeseImage.yScale = 0.7
        cheeseImage.zPosition = 7
        
   
        let cropNode = SKCropNode()
        let maskNode = SKSpriteNode()
        maskNode.color = UIColor.black
        maskNode.size = CGSize(width: CGFloat(creditVal)/15*barImage.frame.width, height: barImage.frame.height)
        
        maskNode.position = CGPoint(x: barImage.position.x + CGFloat(15-creditVal)/15*barImage.frame.width/2, y: barImage.position.y)
        cropNode.maskNode = maskNode
        cropNode.addChild(barImage)
        barImage.zPosition = 7
        
        emptyBarImage.addChild(labelCredits)
        emptyBarImage.addChild(cheeseImage)
        emptyBarImage.addChild(cropNode)
        emptyBarImage.addChild(timerLabel)
        emptyBarImage.addChild(invisableLabel)
        frameImage.addChild(emptyBarImage)
        
        
        scene.addChild(frameImage)
        
    }
    
    
    
    
    func removeCredits(){
        if(creditVal == 15){
            PlistManager.sharedInstance.saveValue(NSDate(), forKey: "rechargeTime")
        }
        
        //PlistManager.sharedInstance.saveValue(creditVal-3, forKey: "cheeseCredits")
        
        invisableLabel.isHidden = false
        invisableLabel.text = "-\(levelCost)🧀"
        invisableLabel.position = labelCredits.position
        invisableLabel.run(SKAction.moveBy(x: 0, y: 50, duration: 2))
        invisableLabel.run(SKAction.fadeAlpha(to: 0, duration: 2))
        
    }
    
    
    func manageCredits(){
        let creditsToAdd = Int(NSDate().timeIntervalSince(rechargeTime as Date)/600)
        ///PlistManager.sharedInstance.saveValue((creditVal as! Int) + (creditsToAdd as! Int), forKey: "cheeseCredits")
        
        if(PlistManager.sharedInstance.getValueForKey("cheeseCredits") as! Int > 15){
            PlistManager.sharedInstance.saveValue(15 as AnyObject, forKey: "cheeseCredits")
        }
        
        creditVal = PlistManager.sharedInstance.getValueForKey("cheeseCredits") as! Int
        labelCredits.text = "\(creditVal) / 15"
        
        //set the recharge time to 10mins*credits added, so time won't be lost when below 15
        rechargeTime = rechargeTime.addingTimeInterval(Double(600*creditsToAdd))
        PlistManager.sharedInstance.saveValue(rechargeTime, forKey: "rechargeTime")
        
        setTime()
    }
    
    
    func hasEnoughCredits()->Bool{
        if(creditVal - levelCost >= 0){
            removeCredits()
            return true
        }else{
            showNotEnoughCredits()
            return false
        }
    }
    
    func showNotEnoughCredits(){
        labelCredits.fontColor = UIColor.red
        
        let shakeRight = SKAction.moveBy(x: 10, y: 0, duration: 0.18)
        let shakeLeft = SKAction.moveBy(x: -10, y: 0, duration: 0.18)
        
        let shakeSequence = SKAction.sequence([shakeRight,shakeLeft,shakeRight,shakeLeft,shakeRight,shakeLeft])
        
        
        labelCredits.run(shakeSequence, completion: { ()-> Void in
            self.labelCredits.fontColor = UIColor.white
        })
        print("not enough credits")
    }
    
    func setTime(){
        let timer = 600 - (NSDate().timeIntervalSince(rechargeTime as Date)).truncatingRemainder(dividingBy:600)
        let minutes = Int(timer/60)
        let seconds = Int(timer.truncatingRemainder(dividingBy: 60))
        
        timerLabel.text = "Wait \(minutes):" +  (seconds >= 10 ? "\(seconds)" : "0\(seconds)") + " for more cheese"
        
        timerLabel.isHidden = (creditVal >= 15)
    }
    
    

}

