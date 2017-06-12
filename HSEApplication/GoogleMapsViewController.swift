//
//  GoogleMapsViewController.swift
//  HSEApplication
//
//  Created by Alexander on 12/06/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit
import GoogleMaps

class GoogleMapsViewController: UIViewController {

    @IBOutlet weak var mapsViewContainer: UIView!
    var googleMapsView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let camera = GMSCameraPosition.camera(withLatitude: 55.75, longitude: 37.61, zoom: 10.0)
        self.googleMapsView = GMSMapView.map(withFrame: self.mapsViewContainer.frame, camera: camera)
        self.view.addSubview(googleMapsView)
    }
    
//    override func loadView() {
//
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        //marker.map = mapView
//    }
}
