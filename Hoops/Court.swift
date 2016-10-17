//
//  Court.swift
//  Hoops
//
//  Created by Minh Tran on 10/17/16.
//  Copyright © 2016 Yanbo Fang. All rights reserved.
//

import Foundation

class Court {
    var court_id: Int
    var courtName: String
    var latitude: Double
    var longitude: Double
    
    init (court_id: Int, courtName: String, latitude: Double, longitude: Double) {
        self.court_id = court_id
        self.courtName = courtName
        self.latitude = latitude
        self.longitude = longitude
    }
}
