//
//  MapViewController.swift
//  SafeTravel
//
//  Created by Lauren Shen on 10/8/16.
//  Copyright © 2016 MHacks8. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    override func loadView() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 1.285, longitude: 103.848, zoom: 12)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        self.view = mapView
        mapView.isMyLocationEnabled = true
        if let mylocation = mapView.myLocation {
            print("User's location: \(mylocation)")
        } else {
            print("User's location is unknown")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
