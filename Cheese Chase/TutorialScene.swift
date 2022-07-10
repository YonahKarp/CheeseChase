//
//  TutorialScene1.swift
//  Cheese Chase
//
//  Created by Yonah Karp on 11/28/16.
//  Copyright © 2016 Immersion ULTD. All rights reserved.
//

import SpriteKit

class TutorialScene: GameScene {
    
    var tLevel = TutorialLevel()
    
    var tutorial : [Tutorial]!
    
    var dialogBox = SKSpriteNode(imageNamed: "DialogBox")
    let dialogText = SKLabelNode(fontNamed:"Noteworthy-Bold")
    let bouncyMouse = SKSpriteNode(imageNamed: "sideMouse")
    
    var dialogCounter = 0
    
    var txtCounter = 0{
        didSet{
            if(txtCounter == txt.count){
                timer.invalidate()
                
                self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(txt[txtCounter-1].characters.count/25) + TimeInterval(0.7), target: self, selector: #selector(self.playerBounce), userInfo: nil, repeats: false)
                txtCounter = 0
            }
        }
    }
    var timer : Timer!
    var txt : [String]!
    
    init(size: CGSize, tLvlInt: Int){
        super.init(size: size)
        tLevel = tLevel.createLevel(self, level: tLvlInt)
        self.tutorial = tLevel.tutorial
        initShared(level: tLevel)
        
        if(tLvlInt == -2){
            cat.isHidden = true //hide cat until ready
        }
        
        setUpDialog()
        checkTutorial()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let location = touch.location(in: self)
            
            //quit
            if menuButton2.frame.contains(location) && !overlayBackground.isHidden{
                exit()
            }
        //retry
            else if menuButton1.frame.contains(location) && !overlayBackground.isHidden{
                if((PlistManager.sharedInstance.getValueForKey("cheeseCredits") as! Int) < 3){
                    return
                }
                resetMessage.fontColor = UIColor.gray
                removeCredits()
                reset(lvlInt: level.lvlInt)
            }
        //pause
            else if pauseButton.frame.contains(location) {
                if((overlayBackground.isHidden)){
                    displayOverlay(message: "paused")
                    pauseButton.texture = SKTexture(imageNamed: "Play")
                }else{
                    overlayBackground.isHidden = true
                    hud.frameImage.isHidden = true
                    
                    gameMessage.text = ""
                    
                    pauseButton.texture = SKTexture(imageNamed: "Pause")
                }
            }
        
        //move along tutorial
            else if(txtCounter > 0){
                timer.invalidate()
                dialogText.text = txt[txtCounter]
                self.timer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(self.updateDialogText), userInfo: nil, repeats: true)
                txtCounter += 1
            }
        }

    }
    
    
    func setUpDialog(){
        dialogBox.size.width = 7*frame.width/8
        dialogBox.position = CGPoint(x: 0, y: -frame.height/2 - dialogBox.frame.height/3)//start below the screen (just tab above)
        dialogBox.zPosition = 6
        
        bouncyMouse.position = CGPoint(x: -6*dialogBox.frame.width/14, y: 0)
        bouncyMouse.zPosition = 7
        bouncyMouse.size.height = 4*dialogBox.frame.height/7
        bouncyMouse.size.width = dialogBox.frame.width/10
        
        dialogText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        dialogText.position = CGPoint(x: dialogBox.frame.minX + 1.5*bouncyMouse.frame.width, y: -dialogBox.frame.height/5)
        dialogText.zPosition = 7
        dialogText.fontSize = 13
        dialogText.color = UIColor.black
        addChild(dialogBox)
        dialogBox.addChild(dialogText)
        dialogBox.addChild(bouncyMouse)
    }
    
    func passBounce(){
        if(bouncyMouse.hasActions()){
            playerBounce()
        }else{
            guideBounce()
        }
    }
    
    @objc func playerBounce(){
        catsTurn = false
        gameMessage.text = "" //upause player
        
        bouncyMouse.removeAction(forKey: "bounce")
        bouncyMouse.run(SKAction.moveTo(y: 0, duration: 0.1))
        
        let bounce = SKAction.sequence([SKAction.moveBy(x: 0, y: 5, duration: 0.35) , SKAction.moveBy(x: 0, y: -5, duration: 0.35)])
        mouse.run(SKAction.repeatForever(bounce), withKey: "bounce")
        
        dialogBox.run(SKAction.moveTo(y: -frame.height/2 - dialogBox.frame.height/3, duration: 0.3))
    }
    
    func guideBounce(){
        catsTurn = true
        gameMessage.text = "Pause Player"
        
        mouse.removeAction(forKey: "bounce")
        mouse.run(SKAction.moveTo(y: board.frame.minY + boxHeight/2 + CGFloat(mouse.y)*boxHeight, duration: 0.1))
        
        let bounce = SKAction.sequence([SKAction.moveBy(x: 0, y: 5, duration: 0.35) , SKAction.moveBy(x: 0, y: -5, duration: 0.35)])
        bouncyMouse.run(SKAction.repeatForever(bounce), withKey: "bounce")
        
    }
    
    override func checkTutorial(){
        if(tutorial[dialogCounter].passCondition()){
            runDialog(tutorial[dialogCounter].dialog)
            tutorial[dialogCounter].passAction()
            dialogCounter += 1
        }
    }
    
    func runDialog(_ dialog: String){
        timer?.invalidate() //kill any already running dialog
        txt = dialog.components(separatedBy: "\n")
        txtCounter = 0
        
        passBounce()
        
        dialogText.text = txt[txtCounter]
        
        
        dialogBox.run(SKAction.moveTo(y: -frame.height/2 + dialogBox.size.height/2, duration: 0.3), completion: {() -> Void in
            self.timer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(self.updateDialogText), userInfo: nil, repeats: true)
            self.txtCounter += 1 //didSet will check for switch
        })
    }
    
    @objc func updateDialogText(){
        
        dialogText.text = txt[txtCounter]
        txtCounter += 1 //didSet will check for switch
    }
    
    override func reset(lvlInt: Int){
        super.reset(lvlInt: tLevel.lvlInt)
    }
}
