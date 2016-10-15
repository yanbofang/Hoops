//
//  Games.swift
//  Hoops
//
//  Created by Minh Tran on 10/9/16.
//  Copyright © 2016 Yanbo Fang. All rights reserved.
//

import Foundation

class Games {
    var gameName: String
    var maxPlayers: Int
    var currentNumPlayers: Int
    var month: Int
    var date: Int
    var startTime: Int
    var endTime: Int
    var level: String
    var teamBlue: [Player]
    var teamRed: [Player]
    
    init(gameName: String, maxPlayers: Int, currentNumPlayers: Int, month: Int, date: Int, startTime: Int, endTime: Int, level: String, teamBlue: [Player], teamRed: [Player] ) {
        self.gameName = gameName
        self.maxPlayers = maxPlayers
        self.currentNumPlayers = currentNumPlayers
        self.month = month
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.level = level
        self.teamBlue = teamBlue
        self.teamRed = teamRed
    }
}
