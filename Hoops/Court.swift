//
//  Court.swift
//  Hoops
//
//  Created by Minh Tran on 10/17/16.
//  Copyright © 2016 Yanbo Fang. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Court: NSObject, MKAnnotation {
    var identifier = "court location"
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    
    var court_id: Int
    //var courtName: String       replaced with title
    //var latitude: Double      replaced with latitude
    //var longitude: Double     replaced with longitude
    
    init (court_id: Int, courtName: String, latitude: Double, longitude: Double) {
        self.court_id = court_id
        self.title = courtName
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
