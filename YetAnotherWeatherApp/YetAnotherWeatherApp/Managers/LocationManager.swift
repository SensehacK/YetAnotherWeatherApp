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
    
}


// MARK: - Location Delegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Getting any location? in Delegate functions>")
        location = locations.first?.coordinate
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        WeatherAppPreferences.shared.set(key: .locationAccessGranted, value: "false")
        print("ERROR! Retrieving location!", error.localizedDescription)
        manager.requestLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("In the did change authorization")
        switch manager.authorizationStatus {
        case .notDetermined:
            print("not determined - hence ask for Permission")
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            // Couldn't test these different scenarios since I only had simulator access and no unlocked iPhone to directly test.
            WeatherAppPreferences.shared.set(key: .locationAccessGranted, value: "false")
            print("permission denied")
            if CLLocationManager.locationServicesEnabled() {
                print("Did get the system wide approval!")
                manager.requestWhenInUseAuthorization()
                manager.requestLocation()
            }
            else {
                print("Show an alert or UIView to let the end user about enabling in settings!")
            }
        case .authorizedAlways, .authorizedWhenInUse:
            print("Apple delegate gives the call back here once user taps Allow option, Make sure delegate is set to self")
            WeatherAppPreferences.shared.set(key: .locationAccessGranted, value: "true")
            manager.requestLocation()
        @unknown default:
            print("Unknown")
        }
        
    }

    
}
