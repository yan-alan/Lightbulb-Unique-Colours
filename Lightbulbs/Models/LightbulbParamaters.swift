//
//  LightbulbParamaters.swift
//  Lightbulbs
//
//  Created by Alan Yan on 2020-02-14.
//  Copyright © 2020 Alan Yan. All rights reserved.
//

import Foundation

///LightbulbParameters manages data passed between InputViewController and RunningViewController
struct LightbulbParamaters {
    var numColours: Int
    var numEachColour: Int
    var totalBulbs: Int { //calculated property from numColours and numEachColour
        get {
            return numColours * numEachColour
        }
    }
    var numOfChoices: Int
    var numberOfSimulations: Int
}
