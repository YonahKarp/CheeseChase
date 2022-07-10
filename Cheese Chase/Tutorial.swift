//
//  Tutorial.swift
//  Cheese Chase
//
//  Created by Yonah Karp on 12/3/16.
//  Copyright © 2016 Immersion ULTD. All rights reserved.
//

import Foundation
import SpriteKit

class Tutorial : NSObject{
   
    var dialog : String
    var passCondition : (() -> Bool)
    var passAction : (() -> ())
    
    init(dialog : String, passCondition : @escaping (() -> Bool), passAction : @escaping (() -> ())){
        self.dialog = dialog
        self.passCondition = passCondition
        self.passAction = passAction
    }
    
    
}
