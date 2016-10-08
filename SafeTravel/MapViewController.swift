//
//  MapViewController.swift
//  SafeTravel
//
//  Created by Lauren Shen on 10/8/16.
//  Copyright © 2016 MHacks8. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var vwGMap = GMSMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 1.285, longitude: 103.848, zoom: 12)
        let vwGMap = GMSMapView.map(withFrame: .zero, camera: camera)
        
        self.view = vwGMap
        
        // Origin Button
        let originButton = UIButton(frame: CGRect(x: 20, y: 90, width: 70, height: 40))
        originButton.backgroundColor = UIColor.init(colorLiteralRed: 0.0, green: 0.0, blue: 1.0, alpha: 0.5)
        originButton.setTitle("Origin", for: .normal)
        originButton.titleLabel!.font = UIFont(name: "Apple SD Gothic Neo", size: 17)
        originButton.addTarget(self, action: #selector(onOriginTap), for: .touchUpInside)
        self.view.addSubview(originButton)
        
        // Destination Button
        let destButton = UIButton(frame: CGRect(x: 20, y: 140, width: 120, height: 40))
        destButton.backgroundColor = UIColor.init(colorLiteralRed: 0.0, green: 0.0, blue: 1.0, alpha: 0.5)
        destButton.setTitle("Destination", for: .normal)
        destButton.titleLabel!.font = UIFont(name: "Apple SD Gothic Neo", size: 17)
        destButton.addTarget(self, action: #selector(onDestinationTap(_:)), for: .touchUpInside)
        self.view.addSubview(destButton)
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        // A minimum distance a device must move before update event generated
        locationManager.distanceFilter = 500
        
        // Request permission to use location service
        locationManager.requestWhenInUseAuthorization()
        
        // Request permission to use location service when the app is run
        locationManager.requestAlwaysAuthorization()
        
        // Start the update of user's location
        locationManager.startUpdatingLocation()
        
        // Add GMSMapView to current view
        
    }
    
    // Present the Autocomplete view controller when the button is pressed.
    @IBAction func onOriginTap(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.present(autocompleteController, animated: true, completion: nil)
        
        //create a label
        
    }
    
    @IBAction func onDestinationTap(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.present(autocompleteController, animated: true, completion: nil)
    }
}

extension MapViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress)
        print("Place attributions: ", place.attributions)
        print("Place coordinates (CLLocationCoordinate2D)", place.coordinate)
        //save in Route object as origin or destination!
        
        //mark point in Map
        let position = place.coordinate
        let marker = GMSMarker(position: position)
        marker.title = "Hello World"
        marker.icon = GMSMarker.markerImage(with: UIColor.blue)
        marker.map = vwGMap //add to existing GMSMapView object
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
