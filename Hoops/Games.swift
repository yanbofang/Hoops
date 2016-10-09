//
//  Games.swift
//  Hoops
//
//  Created by Minh Tran on 10/9/16.
//  Copyright © 2016 Yanbo Fang. All rights reserved.
//

import Foundation

class Games {
    private var maxPlayers: Int
    private var currentNumPlayers: Int
    private var month: Int
    private var date: Int
    private var startTime: Int
    private var endTime: Int
    private var level: String
    private var teamBlue: [Player]
    private var teamRed: [Player]
    
    init(maxPlayers: Int, currentNumPlayers: Int, month: Int, date: Int, startTime: Int, endTime: Int, level: String, teamBlue: [Player], teamRed: [Player] ) {
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
