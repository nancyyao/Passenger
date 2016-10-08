

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
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
}

