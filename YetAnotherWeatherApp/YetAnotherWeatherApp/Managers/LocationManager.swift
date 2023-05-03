//
//  LocationManager.swift
//  Weather-App-MVVM
//
//  Created by Kautilya Save on 5/2/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    
    // @Published var isLocationLoading = false // Could be used for displaying a progress View.
    @Published var location: CLLocationCoordinate2D?
    
    // Singleton Instance
    static let shared = LocationManager()
    
    let manager = CLLocationManager()
    private override init() {
        super.init()
    }
    
    
    // MARK: - Public methods
    func requestLocation() {
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    }
    
    func checkIfLocationServicesAreEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            print("Didn't get the system wide approval!")
        } else {
            print("Show an alert or UIView to let the end user about enabling in settings!")
        }
    }
    
}


// MARK: - Location Delegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Getting any location? in Delegate functions>")
        location = locations.first?.coordinate
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR! Retrieving location!", error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("In the did change authorization")
        switch manager.authorizationStatus {
        case .notDetermined:
            print("not determined - hence ask for Permission")
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            checkIfLocationServicesAreEnabled()
            print("permission denied")
        case .authorizedAlways, .authorizedWhenInUse:
            print("Apple delegate gives the call back here once user taps Allow option, Make sure delegate is set to self")
            manager.requestLocation()
        @unknown default:
            print("Unknown")
        }
        
    }

    
}
