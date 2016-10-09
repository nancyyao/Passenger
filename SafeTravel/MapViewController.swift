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
    let messageComposer = MessageComposer()
    
    let locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil
    
    @IBOutlet weak var mapView: MKMapView!
    var selectedPin:MKPlacemark? = nil

    
    var sourcePlacemark: MKPlacemark?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // Logout Button
        let logoutButton = UIButton(frame: CGRect(x: 100, y: 400, width: 100, height: 40))
        logoutButton.setTitle("Log Out", for: .normal)
        logoutButton.backgroundColor = UIColor.blue
        logoutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        self.view.addSubview(logoutButton)
        
        // TEXT MESSAGES
        //Text/Start trip Button
        let textButton = UIButton(frame: CGRect(x: 200, y: 500, width: 100, height: 100))
        textButton.setTitle("Send Message", for: .normal)
        textButton.backgroundColor = UIColor.green
        textButton.addTarget(self, action: #selector(onSendText), for: .touchUpInside)
        self.view.addSubview(textButton)
        
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
    
    
    // SEND TEXT MESSAGES
    func onSendText(_ sender:UIButton) {
        // Make sure the device can send text messages
        if (messageComposer.canSendText()) {
            // Obtain a configured MFMessageComposeViewController
            let messageComposeVC = messageComposer.configuredMessageComposeViewController()
            
            // Present the configured MFMessageComposeViewController instance
            // Note that the dismissal of the VC will be handled by the messageComposer instance,
            // since it implements the appropriate delegate call-back
            present(messageComposeVC, animated: true, completion: nil)
        } else {
            // Let the user know if his/her device isn't able to send text messages
            let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
            errorAlert.show()
        }
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
        print("CALCULATE ETA")
//        func ETARequest(destination:CLLocationCoordinate2D, user: UserType) {
//            
//        }
        // Get current position
//        let sourcePlacemark = MKPlacemark(coordinate: locations.last!.coordinate, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark!)
        
        //Destination location
        //let destinationCoordinates = location.coordinate
        //let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinates, addressDictionary: nil)
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
                print("Distance: \(route.distance), ETA: \(route.expectedTravelTime)")
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

