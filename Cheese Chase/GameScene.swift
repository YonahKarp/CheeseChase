//
//  GameScene.swift
//  Cheese Chase
//
//  Created by Yk Jt on 4/5/16.
//  Copyright (c) 2016 Immersion ULTD. All rights reserved.
//

import SpriteKit

//globals
var boxWidth = CGFloat(0.0) //changed lower down
var boxHeight = CGFloat(0.0)
var boardBeginsX = CGFloat(0.0)
var boardBeginsY = CGFloat(0.0)


class GameScene: SKScene {
    
    //variables in scene scope
    var level = Level()
    
    let board = SKSpriteNode(imageNamed: "board")
    var map : [String]!
    
    var mouse : Mouse!
    var cat : Cat!
    
    var cheese = [(node: SKSpriteNode(), x: Int(), y: Int())]
    
    var hud : CheeseHud!
    
    let overlayBackground = SKSpriteNode(imageNamed: "WoodGrain")
    let gameMessage = SKLabelNode(fontNamed:"IowanOldStyle-Italic")
    var resetMessage = SKLabelNode(fontNamed: "IowanOldStyle-Italic")
    var exitMessage = SKLabelNode(fontNamed: "IowanOldStyle-Italic")
    
    let pauseButton = SKSpriteNode(imageNamed: "Pause");
    
    let menuButton1 = SKSpriteNode(imageNamed: "Button")
    let menuButton2 = SKSpriteNode(imageNamed: "Button")

    var barriers = [SKSpriteNode]();
    
    var barriersVertical = Array(repeating: Array(repeating: Barrier(), count: 7), count: 7)
    var barriersHorizontal = Array(repeating: Array(repeating: Barrier(), count: 7), count: 7)
    var oneWays = [SKSpriteNode]();
    var hole = SKSpriteNode()
    
    var catsTurn = false
    var cheeseCount = 0

    var creditVal = PlistManager.sharedInstance.getValueForKey("cheeseCredits") as! Int
    
    
    
    init(size: CGSize, lvlInt: Int){
        super.init(size: size)
        level = level.createLevel(lvlInt)
        initShared(level: level)
    }
    
    //For tutorial
    override init(size: CGSize){
       super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initShared(level: Level){
        cat = Cat(scene: self, x: level.cat.x, y: level.cat.y)
        mouse = Mouse(scene: self, x: level.mouse.x, y: level.mouse.y)
        
        map = level.map
        cheese = level.cheese
        
        hud = CheeseHud(scene: self)
        hud.setUpHud()
        hud.frameImage.isHidden = true
        
        setBoard()
        
        setUpPlayers()
        setUpCheese()
        
    }
    
    override func didMove(to view: SKView) {
        
        //swipe gesture recignizers
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view!.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view!.addGestureRecognizer(swipeRight)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        self.view!.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view!.addGestureRecognizer(swipeDown)
        
        setUpOverlay() //don't know why this can't be moved to initShared, but it puts buttons in wacky places if I do
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch ends */
        
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
                    displayOverlay(message: "Paused")
                    pauseButton.texture = SKTexture(imageNamed: "Play")
                }else{
                   overlayBackground.isHidden = true
                    hud.frameImage.isHidden = true
                    
                    gameMessage.text = ""
                    
                    pauseButton.texture = SKTexture(imageNamed: "Pause")
                }
                
            }
            
        }
    }
   
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if(NSDate().timeIntervalSince(hud.rechargeTime as Date) > 600){
            hud.manageCredits()
        }
        hud.setTime()
    }
  
    func setBoard(){
        
        //board.position = CGPoint(x:CGRectGetMinX(self.frame) + board.frame.width/2, y:CGRectGetMinY(self.frame) + board.frame.width/2)
        board.size.width = self.size.width
        board.size.height = self.size.height
        boxWidth = (board.frame.width*0.7119341563786) / 6
        boxHeight = (board.frame.height*0.74209650582363) / 6
        
        boardBeginsX = board.frame.minX + board.frame.width*0.10288065843621
        boardBeginsY  = board.frame.maxY - board.frame.height*0.25833333333333
        
        
        for i in 0..<13{
            for j in 0..<map[i].characters.count/2+1{

                switch map[i][2*j]{
                    case "=": barriersHorizontal[j][6 - Int(i/2)] = Barrier(imageNamed: "barrier", parentScene: self, type: "horizontal", x: j, y: i/2)
                    case "║": barriersVertical[j][5 - Int(i/2)] = Barrier(imageNamed: "barrier", parentScene: self, type: "vertical", x: j, y: i/2+1)
                    case ">": barriersVertical[Int(j/2)][5 - Int(i/2)] = Barrier(imageNamed: "oneWay", parentScene: self, type: "right", x: j, y: i/2+1)
                    case "<": barriersVertical[Int(j/2)][5 - Int(i/2)] = Barrier(imageNamed: "oneWay", parentScene: self, type: "left", x: j, y: i/2+1)
                    case "^": barriersHorizontal[Int(j/2)][6 - Int(i/2)] = Barrier(imageNamed: "oneWay", parentScene: self, type: "up", x: j, y: i/2)
                    case "V": barriersHorizontal[Int(j/2)][6 - Int(i/2)] = Barrier(imageNamed: "oneWay", parentScene: self, type: "down", x: j, y: i/2)
                    case "C": barriersVertical[Int(j)][5 - Int(i/2)] = Barrier(imageNamed: "welcomeMat", parentScene: self, type: "holeVert", x: j, y: i/2+1)
                    case "U": barriersHorizontal[Int(j)][6 - Int(i/2)] = Barrier(imageNamed: "welcomeMat", parentScene: self, type: "holeHorz", x: j, y: i/2)
                    case "|","-": break;
                    
                    default:
                        print("invalid character")
                }
                
            }//end j
        }//end i
        self.addChild(board)
        
    }
    
    func setUpPlayers(){
        
        mouse.position = CGPoint(x: boardBeginsX + boxWidth/2 + CGFloat(mouse.x)*boxWidth, y:(board.frame.minY + boxHeight/2) + CGFloat(mouse.y)*boxHeight)
        let bounce = SKAction.sequence([SKAction.moveBy(x: 0, y: 5, duration: 0.3), SKAction.moveBy(x: 0, y: -5, duration: 0.3)])
        mouse.run(SKAction.repeatForever(bounce), withKey: "bounce")
        
        self.addChild(mouse)
       
        cat.size = CGSize(width: boxHeight, height: boxHeight*14/10)
        cat.position = CGPoint(x: boardBeginsX + boxWidth/2 + CGFloat(cat.x)*boxWidth, y:(board.frame.minY + boxHeight/2) + CGFloat(cat.y)*boxHeight)
        
        self.addChild(cat)
        
        
    }
    
    func setUpCheese(){
        for tempCheese in cheese{
            tempCheese.node.position = CGPoint(x: boardBeginsX + (boxWidth*CGFloat(tempCheese.x) + boxWidth/2), y: board.frame.minY+(CGFloat(tempCheese.y)*boxHeight + boxHeight/2))
            tempCheese.node.zPosition = 1
            tempCheese.node.xScale = 0.5
            tempCheese.node.yScale = 0.5
            self.addChild(tempCheese.node)
        }
    }
    
    func setUpOverlay(){
        self.backgroundColor = UIColor.gray
        gameMessage.text = ""
        gameMessage.fontSize = 40
        gameMessage.zPosition = 7
        gameMessage.position = CGPoint(x:self.frame.midX, y:self.frame.midY + overlayBackground.frame.height/4)
        gameMessage.fontColor = UIColor.black
        
        menuButton1.position = CGPoint(x: gameMessage.position.x - overlayBackground.frame.width/5, y: gameMessage.position.y - overlayBackground.frame.height/2)
        menuButton1.zPosition = 7
        
        menuButton2.position = CGPoint(x: gameMessage.position.x + overlayBackground.frame.width/5, y: gameMessage.position.y - overlayBackground.frame.height/2)
        menuButton2.zPosition = 7
        
        resetMessage.text = ""
        resetMessage.fontSize = 35
        resetMessage.zPosition = 8
        resetMessage.position = CGPoint(x: 0, y: -menuButton1.frame.height/10)
        resetMessage.fontColor = UIColor.black
        
        exitMessage.text = ""
        exitMessage.fontSize = 35
        exitMessage.zPosition = 8
        exitMessage.position = CGPoint(x: 0, y: -menuButton1.frame.height/10)
        exitMessage.fontColor = UIColor.black
        
        pauseButton.zPosition = 7
        pauseButton.position = CGPoint(x: -self.frame.width/2 + pauseButton.frame.width, y: self.frame.height/2 - pauseButton.frame.height)
        
        overlayBackground.zPosition = 6
        overlayBackground.isHidden = true
        
        self.addChild(overlayBackground)
        overlayBackground.addChild(gameMessage)
        overlayBackground.addChild(menuButton1)
        overlayBackground.addChild(menuButton2)
        
        menuButton1.addChild(resetMessage)
        menuButton2.addChild(exitMessage)
        
        self.addChild(pauseButton);
    }

    
    
    ///Swipe respond
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            if(!catsTurn && gameMessage.text == ""){
                switch swipeGesture.direction {
                case UISwipeGestureRecognizer.Direction.right:
                    mouse.move(boxWidth, y: 0, angle: CGFloat(M_PI/2), direction: "right")
                case UISwipeGestureRecognizer.Direction.down:
                    mouse.move(0, y: -boxHeight, angle: CGFloat(0), direction: "down")
                case UISwipeGestureRecognizer.Direction.left:
                    mouse.move(-boxWidth, y: 0, angle: CGFloat(3*M_PI/2), direction: "left")
                case UISwipeGestureRecognizer.Direction.up:
                    mouse.move(0, y: boxHeight, angle: CGFloat(M_PI), direction: "up")
                default:
                    mouse.move(0, y: 0, angle: 0, direction: "null")
                    break
                }
            }
        }
    }
    
    func checkCheese(){
        cheese = cheese.filter{ cheese in
            if (mouse.frame.intersects(cheese.node.frame)) {
            	cheese.node.removeFromParent()
                cheeseCount += 1
            	return false //don't keep this cheese
            }
            else {
                return true //keep this cheese
            }
        }
    }
    
    func checkTutorial(){
        //overriden
    }
    
    func checkWin() -> Bool{
        //if (!CGRectIntersectsRect(mouse.node.frame, board.frame) && cheeseCount == 3){
        if(mouse.x < 0 || mouse.x > 5 || mouse.y < 0 || mouse.y > 5){
            gameMessage.text = "Great Job!!!"
            pauseButton.removeFromParent()
            menuButton1.removeFromParent()
            
            menuButton2.position = CGPoint(x: gameMessage.position.x, y: gameMessage.position.y - overlayBackground.frame.height/2)
            menuButton2.size.width *= 2
            exitMessage.text = "next level"
            
            
            overlayBackground.isHidden = false
            hud.frameImage.isHidden = false
          
            cheeseCount = 4
            
            return true
        }
        return false
    }
    
    func checkGameOver(){
        //if (CGRectIntersectsRect(cat.node.frame, mouse.node.frame) && gameMessage.text == ""){
        if(cat.x == mouse.x && cat.y == mouse.y){
            displayOverlay(message: "Game over")
        }
    }
    
    func displayOverlay(message: String){
       
        overlayBackground.isHidden = false
        hud.frameImage.isHidden = false
        
        gameMessage.text = message
        resetMessage.text = "retry"
        exitMessage.text = "quit"
       
        if(creditVal < 3){
            menuButton1.color = .white
        }
    }
    
    func reset(lvlInt: Int){
        
        //let lvlInt = self.level.lvlInt
        let size = self.view!.bounds.size
        let gameScene : GameScene
        
        if(lvlInt < 1){
            gameScene = TutorialScene(size: size, tLvlInt: lvlInt) //tutorial
        }
        else{
            gameScene = GameScene(size: size, lvlInt: lvlInt)
        }
        
        let transition = SKTransition.fade(with: UIColor.black, duration: 1.5)
        gameScene.scaleMode = .resizeFill
        gameScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.view?.presentScene(gameScene, transition: transition)
    }
    
    func exit(){
        let stageSelect = StageSelect()
        let transition = SKTransition.fade(with: UIColor.black, duration: 1)
        
        stageSelect.scaleMode = .resizeFill
        stageSelect.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        stageSelect.size = self.view!.bounds.size
    
        self.view?.presentScene(stageSelect, transition: transition)
    }
    
    func removeCredits(){
        if(creditVal == 15){
            PlistManager.sharedInstance.saveValue(NSDate(), forKey: "rechargeTime")
        }
        //creditVal = creditVal - 3
        
        PlistManager.sharedInstance.saveValue(creditVal as AnyObject, forKey: "cheeseCredits")
    }
    
   
    
    
}//end


//some extension methods
extension CGFloat{
    func getSign() -> CGFloat{
        if(self < 0){
            return -1
        }
        if(self > 0){
            return 1
        }
           return 0
    }
    
}


extension String {
    
    subscript (i: Int) -> Character {
         return self[self.index(self.startIndex, offsetBy: i)]
	}
}


