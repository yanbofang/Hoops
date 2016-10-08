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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Authorization
        self.locationManager.requestWhenInUseAuthorization()
        moveToCurrent()
    }
    
    // shift to user's current location
    func moveToCurrent() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

