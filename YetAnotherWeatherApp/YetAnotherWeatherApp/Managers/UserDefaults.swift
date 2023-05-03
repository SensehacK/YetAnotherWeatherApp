//
//  UserDefaults.swift
//  YetAnotherWeatherApp
//
//  Created by Kautilya Save on 5/3/23.
//

import Foundation

class WeatherAppPreferences {
    
    // Singleton
    static var shared: WeatherAppPreferences = WeatherAppPreferences()
    private init() { }
    
    private let defaults = UserDefaults.standard
    
    
    // MARK: - Public methods
    func get(key: UserDefaultsKey) -> String {
        guard let returnedValue = defaults.object(forKey: key.rawValue) as? String else {
            return ""
        }
        return returnedValue
    }
    
    func set(key: UserDefaultsKey, value: String) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    
    func shouldResumeState() -> String? {
        
        let cityName = get(key: .citySearched)
        let locationAccess = get(key: .locationAccessGranted)
        
        if locationAccess == "true" {
            return UserDefaultsKey.locationAccessGranted.rawValue
        }
        if cityName.count > 3 {
            return cityName
        }
        return nil
    }
    
    
}
