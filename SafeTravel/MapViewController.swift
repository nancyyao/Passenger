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
import Firebase

class MapViewController: UIViewController, CLLocationManagerDelegate {
    let messageComposer = MessageComposer()
    
    var locationManager = CLLocationManager()
    var vwGMap = GMSMapView()
    
    let originButton = UIButton(frame: CGRect(x: 20, y: 80, width: 330, height: 40))
    let destButton = UIButton(frame: CGRect(x: 20, y: 140, width: 330, height: 40))
    var origin: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        // A minimum distance a device must move before update event generated
        locationManager.distanceFilter = 500
        // Request permission to use location service when the app is run
        locationManager.requestAlwaysAuthorization()
        // Start the update of user's location
        locationManager.startUpdatingLocation()
        
        
        let camera = GMSCameraPosition.camera(withLatitude: 1.285, longitude: 103.848, zoom: 12)
        let vwGMap = GMSMapView.map(withFrame: .zero, camera: camera)
        vwGMap.isMyLocationEnabled = true
        self.view = vwGMap
        if vwGMap.myLocation != nil {
            print("my location is not nil")
            let initialLoc = vwGMap.myLocation as CLLocation!
            vwGMap.animate(to: GMSCameraPosition.init(target: (initialLoc?.coordinate)!, zoom: 14, bearing: 0, viewingAngle: 0))
            print("ANIMATED")
            
        }
        //Text/Start trip Button
        let textButton = UIButton(frame: CGRect(x: 200, y: 500, width: 100, height: 100))
        textButton.setTitle("Send Message", for: .normal)
        textButton.backgroundColor = UIColor.green
        textButton.addTarget(self, action: #selector(onSendText), for: .touchUpInside)
        self.view.addSubview(textButton)
        
        // Logout Button
        let logoutButton = UIButton(frame: CGRect(x: 100, y: 400, width: 100, height: 100))
        logoutButton.setTitle("Log Out", for: .normal)
        logoutButton.backgroundColor = UIColor.blue
        logoutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        self.view.addSubview(logoutButton)
        
        
        // Origin Button
        originButton.backgroundColor = UIColor.init(white: 0.7, alpha: 0.65)
        originButton.titleLabel?.textColor = UIColor.init(white: 0.5, alpha: 0.5)
        originButton.setTitle("Enter Starting Point...", for: .normal)
        originButton.titleLabel!.font = UIFont(name: "Apple SD Gothic Neo", size: 18)
        originButton.addTarget(self, action: #selector(onOriginTap), for: .touchUpInside)
        self.view.addSubview(originButton)
        
        // Destination Button
        destButton.backgroundColor = UIColor.init(white: 0.7, alpha: 0.65)
        destButton.titleLabel?.textColor = UIColor.init(white: 0.5, alpha: 0.5)
        destButton.setTitle("Enter Destination...", for: .normal)
        destButton.titleLabel!.font = UIFont(name: "Apple SD Gothic Neo", size: 18)
        destButton.addTarget(self, action: #selector(onDestinationTap(_:)), for: .touchUpInside)
        self.view.addSubview(destButton)
        
        
        
        
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
    
    // Present the Autocomplete view controller when the button is pressed.
    @IBAction func onOriginTap(_ sender: UIButton) {
        origin = true
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func onDestinationTap(_ sender: UIButton) {
        origin = false
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
        if (origin == true) {
            originButton.setTitle(place.name, for: UIControlState.normal)
            originButton.titleLabel?.textColor = UIColor.black
        } else {
            destButton.setTitle(place.name, for: UIControlState.normal)
            destButton.titleLabel?.textColor = UIColor.black
        }
        
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
