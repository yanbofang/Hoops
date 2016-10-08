//
//  Player.swift
//  Hoops
//
//  Created by Minh Tran on 10/7/16.
//  Copyright © 2016 Yanbo Fang. All rights reserved.
//

import Foundation

class Player {
    var username: String
    var followers: Int
    var following: Int
    
    init(username: String, followers: Int, following: Int) {
        self.username = username
        self.followers = followers
        self.following = following
    }
}
