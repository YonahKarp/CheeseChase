//
//  TutorialLevel.swift
//  Cheese Chase
//
//  Created by Yonah Karp on 12/3/16.
//  Copyright © 2016 Immersion ULTD. All rights reserved.
//

import Foundation
import SpriteKit

class TutorialLevel: Level {
    
    
    var tutorial : [Tutorial]
    var scene : GameScene! //will be set in the scene init
    
    
    override init() {
        self.tutorial = [Tutorial]()
        super.init()
    }
    
    init?(
        scene: GameScene,
        tutorial: [Tutorial],
        lvlInt: Int,
        map: [String],
        mouse: (node: SKSpriteNode, x: Int, y: Int),
        cat: (x: Int, y: Int),
        cheese: [(node: SKSpriteNode,x: Int, y: Int)]
    ){
        self.scene = scene
        self.tutorial = tutorial
        super.init(lvlInt: lvlInt, map: map, mouse: mouse, cat: cat, cheese: cheese)
    }
    
    
    func createLevel(_ scene: GameScene, level: Int) -> TutorialLevel{
        var createdLevel = TutorialLevel()
        
        switch level{
        case -2:
            map = [
                 "- - - - - -", //0
                "| | | | | ║ |",
                 "- - - - - =",
                "| | ║ ║ | | |",
                 "- - - - - -",
                "| | | ║ | ║ |",
                 "- - - = - -",
                "| | ║ | ║ ║ |",
                 "- - = - - -",
                "| | | | | ║ |",
                 "- - - - - -",
                "| | | | ║ | |",
                 "- U - - - -", //12
            ]
            mouse = (SKSpriteNode(imageNamed: "mouse"),x: 2,y: 3)
            cat = (x: 5,y: 5)
           
            cheese = [ (SKSpriteNode(imageNamed: "cheese"), x: 0,y: 4),
                       (SKSpriteNode(imageNamed: "cheese"), x: 2,y: 1),
                       (SKSpriteNode(imageNamed: "cheese"), x: 4,y: 2)
            ]
            
            tutorial = [
                Tutorial(
                dialog: "Welcome to Cheese Chase, my name is Peanut and I love cheese. \n Would you please help me collect some cheese? \n Swipe any direction to help me move",
                passCondition:{ true }, //self.scene.mouse.node.hidden},
                passAction: {}),
                
                Tutorial(
                dialog: "Great job!",
                passCondition:{ scene.mouse.hasActions()},
                passAction: {}),
                
                Tutorial(
                    dialog: "You're good at this! We should have all the cheese in no time",
                    passCondition:{ scene.cheeseCount == 1},
                    passAction: {}),
                
                Tutorial(
                    dialog: "Oh no! I think I hear a cat! \n Quick! help me get to the hole to escape!",
                    passCondition:{ scene.cheeseCount == 3},
                    passAction: {
                        scene.cat.isHidden = false
                        scene.barriersHorizontal[5][5].removeFromParent();
                        //scene.barriersHorizontal[5][5] = Barrier();
                    }
                ),
                
                Tutorial(
                    dialog: "He's coming after us! \n Use the walls to your advantage and escape through the hole!",
                    passCondition:{ scene.mouse.hasActions()},
                    passAction: {
                       scene.barriersHorizontal[5][5] = Barrier();
                    }
                ),
                
                Tutorial(
                    dialog: "How'd you swing that?",
                    passCondition:{ scene.cheeseCount > 4},
                    passAction: {})
            ]
            
        case -1:
            map = [
                 "- - - - - -", //0
                "| ║ | | | | |",
                 "- - - - - -",
                "| ║ | | | | |",
                 "- - = = = -",
                "| ║ ║ | | ║ |",
                 "- - - - = -",
                "| | ║ ║ | | |",
                 "= - - - - -",
                "| | | | ║ | |",
                 "- - - - - -",
                "| | | | | | |",
                 "- - U - - -", //12
            ]
            mouse = (SKSpriteNode(imageNamed: "mouse"),x: 0,y: 5)
            cat = (x: 5,y: 2)
            
            cheese = [ (SKSpriteNode(imageNamed: "cheese"), x: 0,y: 3),
                       (SKSpriteNode(imageNamed: "cheese"), x: 1,y: 2),
                       (SKSpriteNode(imageNamed: "cheese"), x: 3,y: 0)
            ]
            
            tutorial = [
                Tutorial(
                    dialog: "Good Job back there! \n Seems like that cat is back though... \n He's faster than me, everytime I move once he moves twice. \n But I bet you can help me outsmart him! \n Lets get that cheese!",
                    passCondition:{ true }, //self.scene.mouse.node.hidden},
                    passAction: {}),
                
                Tutorial(
                    dialog: "The cat's thought process is fairly simple: \n He tries to close the largest distance, up,down or sideways, on each move",
                    passCondition:{ scene.mouse.hasActions()},
                    passAction: {
                        scene.catsTurn = false
                        scene.cat.takeTurn()
                        
                }),
                
                Tutorial(
                    dialog: "The cat wanted to move left, but he was blocked by the barrier,\n so he moved up instead",
                    passCondition:{ scene.mouse.hasActions()},
                    passAction: {
                        scene.catsTurn = true
                        scene.cat.takeTurnOne()
                        scene.cat.takeTurnTwo()
                        scene.catsTurn = false

                
                }),
                
                Tutorial(
                    dialog: "The cat won't move if it will bring him father away from me \n He'd rather stay still, even if he could get me by running around the corner \n he's kinda lazy if you ask me. But that's good for us!",
                    passCondition:{ scene.cheeseCount == 2},
                    passAction: {}),
                
                Tutorial(
                    dialog: "Ahh he's coming!",
                    passCondition:{ scene.cheeseCount == 3},
                    passAction: {}),
                
                Tutorial(
                    dialog: "Ahh he's really close! \nLet me explain his movements to you real quick \nYou may have noticed the cat moved first down, then left \n That's because there was an even distance up/down and sideways, \n AND he had just moved down (vertically) on his first move \n But enough of that for now! Quick, run through the hole!",
                    passCondition:{ scene.mouse.x == 2},
                    passAction: {})
            ]

            
            
        default:
            map = [
                "- - - - - -", //0
                "| | | | | ║ |",
                "- - - - - =",
                "| | ║ | | | |",
                "- - - - - -",
                "| | ║ ║ | ║ |",
                "- - - = - -",
                "| | ║ | ║ ║ |",
                 "- - = - - -",
                "| | | | | ║ |",
                "- - - - - -",
                "| | | | | ║ |",
                "- U - - - -", //12
            ]

            break
        }
        
        createdLevel = TutorialLevel(scene: scene, tutorial: tutorial, lvlInt: level, map: map, mouse: mouse, cat: cat, cheese: cheese)!
        
        return createdLevel
    }
}
