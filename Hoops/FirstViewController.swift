//
//  FirstViewController.swift
//  Hoops
//
//  Created by Yanbo Fang on 10/5/16.
//  Copyright © 2016 Yanbo Fang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FirstViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var nearbyGames: [Games] = []
    
    @IBAction func gameClicked(_ sender: AnyObject) {
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "getGames":
                if let vc = segue.destination as? GamesTableViewController {
                    // Need to pass which basketball court was clicked into the TableViewController
                }
            default: break
            }
        }
    }
    
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    
    // Move to user's current location when button is pressed
    @IBAction func moveToCurrentLocation(_ sender: AnyObject) {
        moveToCurrent()
    }
    
    let regionRadius: CLLocationDistance = 1500
    func centerMapOnLocation(location: CLLocation) {
        let coodinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                 regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coodinateRegion, animated: true)
    }
    
    let locationManager = CLLocationManager()
    
    // locationManager() gets called whenever location changes/get updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        let userLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        centerMapOnLocation(location: userLocation)
        
        // Stop updating location to conserve power
        locationManager.stopUpdatingLocation()
    }
    
    // shift to user's current location
    func moveToCurrent() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

    }
    
    // Load nearby location from Database here...
    // Will have to implement later...
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For testing, set up nearby games
        let one = Player(username: "michael")
        let two = Player(username: "jeff")
        let three = Player(username: "three")
        let four = Player(username: "four")
        nearbyGames.append(Games(
            gameName: "Coolest Game of the Year",
            maxPlayers: 6,
            currentNumPlayers: 2,
            month: 10,
            date: 20,
            startTime: 5,
            endTime: 6,
            level: "Novice",
            teamBlue: [one, three, four],
            teamRed: [two]
        ))
        
        // Authorization
        self.locationManager.requestWhenInUseAuthorization()
        moveToCurrent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

