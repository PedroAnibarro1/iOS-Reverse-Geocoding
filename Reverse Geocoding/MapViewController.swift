//
//  ViewController.swift
//  Reverse Geocoding
//
//  Created by Pedro Anibarro on 6/21/18.
//  Copyright © 2018 ErraticMinds. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressContainerView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    
    // MARK: - Actions
    @IBAction func currentLocationButtonAction(_ sender: Any) {
        
        // Go to current user location
        self.goToCurrentLocation()
        
    }
    
    
    // MARK: - Properties
    var locationManager = CLLocationManager()
    /// Most recent user location.
    /// Having a nil means that the location has not been updated yet by the location manager.
    var mostRecentUserLocation: CLLocation?
    /// Address of the center of the map.
    var pinAddress: String? {
        didSet {
            self.addressLabel.text = self.pinAddress
        }
    }
    

    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Map View delegate
        self.mapView.delegate = self
        
        // Set round corners to coordinates container view
        self.addressContainerView.layer.cornerRadius = 10.0
        
        // Set initial coordinates message
        self.pinAddress = "Move the map around 🌎"
        
        // Request user location updates
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        }
        
        // Show user location in map
        self.mapView.showsUserLocation = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Go to current user location
        self.goToCurrentLocation()
        
    }

}


// MARK: - Private Methods
extension MapViewController {
    
    private func goToCurrentLocation() {
        
        // Get most recent user location and coordinates
        if let location = self.mostRecentUserLocation {
            
            // Get location coordinates
            let coordinates = location.coordinate
            
            // Go to user coordinates on map
            self.mapView.setCenter(coordinates, animated: true)
            
        }
        
    }
    
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    // This method is called when the user finishes dragging the map.
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        // Get coordinates
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        // Get location based on coordinates
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        // Set Geo coder
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            
            if let error = error {
                // Print the error
                print(error)
                
                // Show an error in the map
                self.pinAddress = "Opps, an error occured. Try again 😅"
            } else {
                
                // Get the first option of the placemarks
                guard let placemark = placemarks?.first else {return}
                
                // See all the information from the placemark
                print(placemark)
                
                // Set coordinates text
                self.pinAddress = placemark.name ?? "Opps, address not found 😅"
                
            }
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        // Verify is it's the first location update
        // Having a nil in self.mostRecentLocation means it's the first time updating the location
        if self.mostRecentUserLocation == nil {
            self.mostRecentUserLocation = userLocation.location
            self.goToCurrentLocation()
        } else {
            self.mostRecentUserLocation = userLocation.location
        }
        
    }
    
}
