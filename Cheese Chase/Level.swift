//
//  Level.swift
//  Cheese Chase
//
//  Created by Yk Jt on 4/12/16.
//  Copyright © 2016 Immersion ULTD. All rights reserved.
//

import Foundation
import SpriteKit

class Level: NSObject {
    
    
    var lvlInt : Int
    var map: [String]
    var mouse: (node: SKSpriteNode, x: Int, y: Int)
    var cat: (x: Int, y: Int)
    var cheese : [(node: SKSpriteNode, x: Int, y: Int)]
    
    init?(
        lvlInt: Int,
        map: [String],
        mouse: (node: SKSpriteNode, x: Int, y: Int),
        cat: (x: Int, y: Int),
        cheese: [(node: SKSpriteNode,x: Int,y: Int)]
    ){
        self.lvlInt = lvlInt
        self.map = map
        self.mouse = mouse
        self.cat = cat
        self.cheese = cheese
    }
    
    override init() {
        lvlInt = 0
        map = [""]
        mouse = (node: SKSpriteNode(), x: 0, y: 5)
        cat =  (x: 5, y: 0)
        cheese = [(node: SKSpriteNode(), x: 1, y: 0)]
    }
    
    func createLevel(_ level: Int) -> Level{
        var createdLevel = Level()
        
        switch level{
        case 1:
        map = [
         "- - - - - -", //0
        "| | | | | | |",
         "- = - - = -",
        "| ║ | | ║ ║ |",
         "- = = - - -",
        "| | | ║ | | |",
         "- - - - - -",
        "| | | ║ ║ | |",
         "- = - - = -",
        "| ║ | | | ║ |",
         "- - - - - -",
        "| | | | | | |",
         "- - - - U -", //12
        ]
        mouse = (SKSpriteNode(imageNamed: "mouse"),x: 0,y: 5)
        cat = (x: 5,y: 0)
        //cat2 = Player(x: 5, y:0)
        cheese = [ (SKSpriteNode(imageNamed: "cheese"), x: 0,y: 1),
                   (SKSpriteNode(imageNamed: "cheese"), x: 1,y: 4),
                   (SKSpriteNode(imageNamed: "cheese"), x: 3, y: 3)
        ]
        case 2:
        map = [
         "- - - - - -", //0
        "| | | | | | |",
         "- - - - - -",
        "| | | ║ ║ | |",
         "- = - - - -",
        "| | | | | ║ |",
         "- - - - = -",
        "C | | | | | |",
         "= - = - = -",
        "| | | | | ║ |",
         "- = - - = -",
        "| | | | | | |",
         "- - - - - -", //12
        ]
        mouse = (SKSpriteNode(imageNamed: "mouse"),x: 1,y: 1)
        cat = (x: 1,y: 0)
        cheese = [ (SKSpriteNode(imageNamed: "cheese"), x: 0,y: 4),
                   (SKSpriteNode(imageNamed: "cheese"), x: 4,y: 5),
                   (SKSpriteNode(imageNamed: "cheese"), x: 5, y: 1)
        ]
        case 3:
        map = [
         "- - - - - -", //0
        "| | | ║ | | |",
         "- - - - = -",
        "| | | | ║ | |",
         "- - - - - -",
        "| | | | | | C",
         "- - - - = -",
        "| | ║ | | ║ |",
         "- - - - - -",
        "| ║ | ║ | | |",
         "- = = - = -",
        "| | | | | | |",
         "- - - - - -", //12
        ]
        mouse = (SKSpriteNode(imageNamed: "mouse"),x: 3,y: 3)
        cat = (x: 5,y: 0)
        cheese = [ (SKSpriteNode(imageNamed: "cheese"), x: 0,y: 4),
                   (SKSpriteNode(imageNamed: "cheese"), x: 4,y: 5),
                   (SKSpriteNode(imageNamed: "cheese"), x: 5, y: 1)
        ]
        default:
        break
        }
        
        createdLevel = Level(lvlInt: level, map: map, mouse: mouse, cat: cat, cheese: cheese)!
        
        return createdLevel
    }
}
