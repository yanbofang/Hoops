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
    
    var nearbyCourts = [Court]()
    var courtClicked_id = 0
    
    var userLocation: CLLocation? = nil {
        didSet {
            let northEast = mapView.convert(CGPoint(x: mapView.bounds.width, y: 0), toCoordinateFrom: mapView)
            let radius = haversine(lat1: northEast.latitude, lon1: northEast.longitude, lat2: (userLocation?.coordinate.latitude)!, lon2: (userLocation?.coordinate.longitude)!)
            DispatchQueue.global(qos: .userInitiated).async {
                self.getCourts(latitude: (self.userLocation?.coordinate.latitude)!, longitude: (self.userLocation?.coordinate.longitude)!, radius: Int(radius))
                // Bounce back to the main thread to update the UI
                DispatchQueue.main.async {
                    self.mapView.addAnnotations(self.nearbyCourts)
                }
            }
        }
    }
    
    @IBAction func gameClicked(_ sender: AnyObject) {
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "getGames":
                if let vc = segue.destination as? GamesTableViewController {
                    // Need to pass which basketball court was clicked into the TableViewController
                    vc.court = courtClicked_id
                }
            default: break
            }
        }
    }
    
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
            mapView.showsUserLocation = true
        }
    }
    
    // Move to user's current location when button is pressed
    @IBAction func moveToCurrentLocation(_ sender: AnyObject) {
        moveToCurrent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Authorization
        self.locationManager.requestWhenInUseAuthorization()
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
        userLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        
        centerMapOnLocation(location: userLocation!)
        
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
    
    var data = NSMutableData()
    var index = 0
    // initializes the 'nearbyCourts' array given latitude, longitude, and radius
    func getCourts(latitude: Double, longitude: Double, radius: Int) {
        //nearbyCourts.removeAll()
        let tempUrl = "http://hoopsapp.netai.net/maps_op.php?function=getCourts&lat=" + String(latitude) + "&lng="
            + String(longitude) + "&radius=" + String(radius)
        let url = NSURL(string: tempUrl)
        let request = URLRequest(url: url as! URL)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("request failed \(error)")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as?
                    [AnyObject] {
                    for index in 0...json.count-1 {
                        if let item = json[index] as? [String: AnyObject] {
                            if let name = item["name"] as? String {
                                self.nearbyCourts.append(Court(
                                    court_id: -1,
                                    courtName: item["name"] as! String,
                                    latitude: Double(item["lat"] as! String)!,
                                    longitude: Double(item["lng"] as! String)!
                                ))
                            }
                        }
                    }
                }
            } catch let parseError {
                print("parsing error: \(parseError)")
                let responseString = String(data: data, encoding: .utf8)
                print("raw response: \(responseString)")
            }
        }
        task.resume()
    }
    
    // get court id of a given latitude and longitude
    func getCourt_Id(latitude: Double, longitude: Double) -> Int {
        print("****************** PRINTING Lat lng")
        print(String(latitude))
        print(longitude)
        let tempUrl = "http://minh.heliohost.org/hoops/database_op.php?function=getCourtId&lat=" + String(latitude) + "&lng="
            + String(longitude)
        let url = NSURL(string: tempUrl)
        let request = URLRequest(url: url as! URL)
        
        var result = -1
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("request failed \(error)")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as?
                    [AnyObject] {
                    print("!!!!!!!!!!!!!!!!!!!!")
                    for index in 0...json.count-1 {
                        print("******************")
                        if let item = json[index] as? [String: AnyObject] {
                            print("*/////////")
                            if let court_id = item["court_id"] as? String {
                                print("-=-=-=-=-=-=-=-=-=")
                                result = Int((court_id as? String)!)!
                                print(result)
                            }
                        }
                    }
                }
            } catch let parseError {
                print("parsing error: \(parseError)")
                let responseString = String(data: data, encoding: .utf8)
                print("raw response: \(responseString)")
            }
        }
        task.resume()
        return result
    }
    
    
    //The function mapview:viewForAnnotation has a map view and an annotation for parameters,
    /*func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var view : MKPinAnnotationView
        guard let annotation = annotation as? Court else {return nil}
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.identifier) as? MKPinAnnotationView {
            view = dequeuedView
        }else { //make a new view
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            
        }
        return view
    }*/
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            
            let rightButton: AnyObject! = UIButton(type: .detailDisclosure)
            
            pinView!.rightCalloutAccessoryView = rightButton as? UIView
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            // get the court_id from coordinate position
            let coordinates = view.annotation?.coordinate
            DispatchQueue.global(qos: .userInitiated).async {
                let result = self.getCourt_Id(latitude: (coordinates?.latitude)!, longitude: (coordinates?.longitude)!)
                // Bounce back to the main thread to update the UI
                DispatchQueue.main.async {
                    self.courtClicked_id = result
                    print("=============================")
                    print(self.courtClicked_id)
                }
            }
            
            if courtClicked_id != -1 {
                performSegue(withIdentifier: "getGames", sender: view)
            }
        }
    }
    
    func haversine(lat1:Double, lon1:Double, lat2:Double, lon2:Double) -> Double {
        let lat1rad = lat1 * M_PI/180
        let lon1rad = lon1 * M_PI/180
        let lat2rad = lat2 * M_PI/180
        let lon2rad = lon2 * M_PI/180
        
        let dLat = lat2rad - lat1rad
        let dLon = lon2rad - lon1rad
        var a = sin(dLat/2) * sin(dLat/2)
        a += sin(dLon/2) * sin(dLon/2) * cos(lat1rad) * cos(lat2rad)
        let c = 2 * asin(sqrt(a))
        let R = 6372.8
        
        return R * c * 1000
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

