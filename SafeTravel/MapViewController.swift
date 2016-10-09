//
//  MapViewController.swift
//  SafeTravel
//
//  Created by Lauren Shen on 10/8/16.
//  Copyright © 2016 MHacks8. All rights reserved.
//

import UIKit
import MapKit
import Firebase

protocol HandleMapSearch: class {
    func dropPinZoomIn(_ placemark:MKPlacemark)
}

class MapViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil
    
    @IBOutlet weak var mapView: MKMapView!
    var selectedPin:MKPlacemark? = nil
    var minutes:Int!
    
    let startButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 110, y: UIScreen.main.bounds.height - 150, width: 100, height: 70))
    
    var sourcePlacemark: MKPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // Logout Button
        let logoutButton = UIButton(frame: CGRect(x: 20, y: UIScreen.main.bounds.height - 50, width: 80, height: 40))
        logoutButton.setTitle("Log Out", for: .normal)
        logoutButton.backgroundColor = UIColor.init(white: 1.0, alpha: 0.8)
        logoutButton.setTitleColor(UIColor.gray, for: .normal)
        logoutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        self.view.addSubview(logoutButton)
        
        // Time/Start route Button
        startButton.backgroundColor = UIColor.blue
        startButton.addTarget(self, action: #selector(onStartRoute), for: .touchUpInside)
        self.view.addSubview(startButton)
        startButton.isHidden = true
        
        // Contacts Button
        let contactsButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 100, y: UIScreen.main.bounds.height - 50, width: 80, height: 40))
        contactsButton.backgroundColor = UIColor.init(white: 1.0, alpha: 0.8)
        contactsButton.setTitleColor(UIColor.gray, for: .normal)
        contactsButton.setTitle("Contacts", for: .normal)
        contactsButton.addTarget(self, action: #selector(toContacts), for: .touchUpInside)
        self.view.addSubview(contactsButton)
        
        //Search function
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Find your destination"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        
        locationSearchTable.handleMapSearchDelegate = self
        
    }
    
    // Contacts Segue
    func toContacts(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ContactsSegue", sender: nil)
    }
    
    // Sign out
    func signOut(_ sender: UIButton) {
        try! FIRAuth.auth()!.signOut()
        self.performSegue(withIdentifier: "LogOut", sender: nil)
    }
    
    //Directions
    func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
    
    //Start Route
    func onStartRoute(_ sender: UIButton) {
        self.performSegue(withIdentifier: "TimerSegue", sender: nil)
        startButton.isHidden = true
    }
    
    
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let hours = Int(self.minutes!/60)
        var mins: Int?
        if self.minutes! > 60 {
            mins = minutes - 60*hours
        }
        if let vc = segue.destination as? CountdownViewController {
            if let name = selectedPin?.name {
                vc.address = name as String
            }
            vc.eta = "\(hours)h, \(mins!)m"
        }
    }
}

extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        sourcePlacemark = MKPlacemark(coordinate: locations.last!.coordinate, addressDictionary: nil)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
}

extension MapViewController: HandleMapSearch {
    func dropPinZoomIn(_ placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = city + " " + state
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
        
        // CALCULATE ETA
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark!)
        
        //Destination location
        let destinationPlacemark = placemark
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // Create request
        let request = MKDirectionsRequest()
        request.source = sourceMapItem
        request.destination = destinationMapItem
        request.transportType = MKDirectionsTransportType.automobile
        request.requestsAlternateRoutes = false
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let route = response?.routes.first {
                let sec = route.expectedTravelTime
                print("Distance: \(route.distance), ETA: \(sec)")
                let doub = sec/60
                self.minutes =  Int(doub)
                self.startButton.setTitle("\(self.minutes!) mins", for: .normal)
                self.startButton.isHidden = false
            } else {
                print("Error!")
            }
        }
    }
}

extension MapViewController : MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        print("FUNC MAPVIEW)")
        if annotation is MKUserLocation {
            //return nil so mamp view draws "blue dot" for standard user location
            print("nil")
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        //let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
        button.addTarget(self, action: #selector(MapViewController.getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}

