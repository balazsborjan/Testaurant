//
//  MapViewController.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 06. 08..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var restaurants = [Restaurant]()
    
    var mapViewFinishedLoading = false
    
    let navBarVisualEffectView   = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarVisualEffectView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.navigationController!.navigationBar.frame.maxY)
        
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.view.addSubview(navBarVisualEffectView)
        
        mapView.delegate = self
        
        mapView.showsUserLocation = true
        mapView.addAnnotations(restaurants)
        
        globalContainer.locationManager.delegate = self
        globalContainer.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        if CLLocationManager.locationServicesEnabled() {
            
            if globalContainer.isLocationAuthorizationEnabled() {
                
                globalContainer.locationManager.startUpdatingLocation()
                
            } else {
                
                globalContainer.locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        globalContainer.locationManager.stopUpdatingLocation()
    }
    
    private func showAnnotations() {
        
        mapView.addAnnotation(mapView.userLocation)
        mapView.showAnnotations(mapView.annotations, animated: true)
        mapViewFinishedLoading = true
    }
    
    // MARK: LocationManager delegate methods
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .notDetermined || status == .authorizedWhenInUse || status == .authorizedAlways {
            
            manager.startUpdatingLocation()
            
        } else {
            
            manager.stopUpdatingLocation()
        }
    }
    
    // MARK: MapView delegate methods
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        if !mapViewFinishedLoading {
         
            showAnnotations()
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showOpenInMapAlert(_:)))
        
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func showOpenInMapAlert(_ sender: UITapGestureRecognizer) {
        
        let alertController = UIAlertController(title: "Navigáció", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Maps", style: .default, handler: { (action) in
            
            self.openInMaps(for: sender.view as! MKAnnotationView)
        }))
        
        alertController.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: { (action) in
            
            self.openInGoogleMaps(for: sender.view as! MKAnnotationView)
        }))
        
        alertController.addAction(UIAlertAction(title: "Mégsem", style: .cancel, handler: { (action) in
            
            // Do nothing!!!
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func openInMaps(for annotationView: MKAnnotationView) {
        
        if let annotation = annotationView.annotation {
            
            let placeMark = MKPlacemark(coordinate: annotation.coordinate)
            let mapItem = MKMapItem(placemark: placeMark)
            
            mapItem.openInMaps(launchOptions: nil)
        }
    }
    
    private func openInGoogleMaps(for annotationView: MKAnnotationView) {
        
        if let annotation = annotationView.annotation {
            
            let latitude = annotation.coordinate.latitude
            let longitude = annotation.coordinate.longitude
            
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                UIApplication.shared.open(
                    URL(string: "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=transit")!,
                    options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.open(
                    URL(string: "https://www.google.com/maps/search/?api=1&query=\(latitude),\(longitude)")!,
                        options: [:], completionHandler: nil)
            }
        }
    }
}














