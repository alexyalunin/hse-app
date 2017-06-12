//
//  MapViewController.swift
//  HSEmanager
//
//  Created by Alexander on 03/05/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    var address: String? = "ул. Кирпичная, д. 33"
    var addresses: [String] = ["Кончовский проезд, д. 3", "ул. Петровка, д. 12, стр. 1", "Славянская площадь, д. 4, стр. 2", "ул. М. Пионерская, д. 12", "ул, Ст. Басманная, д. 21/4, стр.1", "Варшавское ш., д. 44а", "ул. Кирпичная, д. 33", "Волгоградский пр-т, д. 46Б"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial location
        let initialLocation = CLLocation(latitude: 55.7522200, longitude: 37.6155600)
        let regionRadius: CLLocationDistance = 1000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(
                location.coordinate,
                regionRadius * 30.0,
                regionRadius * 30.0)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(location: initialLocation)
        
        // Convert address to coordinate and annotate it on map
//        for address1 in addresses {
//            let geoCoder = CLGeocoder()
//            geoCoder.geocodeAddressString(address1, completionHandler: {
//                placemarks, error in
//                if error != nil {
//                    print(error!)
//                    return
//                }
//                if let placemarks = placemarks {
//                    // Get the first placemark
//                    let placemark = placemarks[0]
//                    // Add annotation
//                    let annotation = MKPointAnnotation()
//                    //annotation.title = self.address
//                    // annotation.subtitle = self.address
//                    if let location = placemark.location {
//                        annotation.coordinate = location.coordinate
//                        // Display the annotation
//                        self.mapView.addAnnotation(annotation)
//                    }
//                }
//            })
//        }
//            
        
        // Convert address to coordinate and annotate it on map
        for address1 in addresses {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address1, completionHandler: {
            placemarks, error in
            if error != nil {
                print(error!)
                return
            }
            if let placemarks = placemarks {
                // Get the first placemark
                let placemark = placemarks[0]
                // Add annotation
                let annotation = MKPointAnnotation()
                annotation.title = self.address
                // annotation.subtitle = self.address
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    // Display the annotation
                    self.mapView.addAnnotation(annotation)
                }
            }
        })
        }
    }
    
}
