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
    var addresses: [String] = ["ул. Ст. Басманная, д. 21/4, стр. 1", "ул. Ст. Басманная, д. 21/4, стр. 3", "ул. Ст. Басманная, д. 21/4, стр. 5", "ул. Вавилова, д. 7", "Волгоградский пр-т, д. 46б", "М. Гнездниковский переулок, д. 4", "Измайловское ш., д. 44, стр. 1", "Измайловское ш., д. 44, стр. 2", "ул. Кибальчича, д. 7", "ул. Кирпичная, д. 33", "3-й Колобовский пер., д. 8, стр. 2", "ул. Космонавта Волкова, д. 18", "Кочновский проезд, д. 3 ", "Кривоколенный переулок, д. 3", "Кривоколенный переулок, д. 3А ", "ул. Мясницкая, д. 11", "ул. М. Ордынка, д. 17", "ул. Пантелеевская, д. 53", "ул. М. Пионерская, д. 12 ","Покровский б-р, д. 8, стр. 1","Потаповский переулок, д. 16, стр. 10 ","ул. Профсоюзная, 33, к.4 ","Славянская площадь, д. 4, стр. 2","ул. Таллинская, д. 34","Б. Трёхсвятительский переулок, д. 3 ","ул. Трифоновская, д. 57, стр. 1","ул. Усачева, д. 6 ","ул. Шаболовка, д. 26, стр. 3"]
    
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
