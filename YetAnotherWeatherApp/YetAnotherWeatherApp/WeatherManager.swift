//
//  WeatherManager.swift
//  Weather-App-MVVM
//
//  Created by Kautilya Save on 5/2/23.
//

import SwiftSense
import Combine

class WeatherManager {
    
    static var shared: WeatherManager = WeatherManager()
    private init() { }
    
    
    func getCurrentWeather(latitude: Double, longitude: Double) async -> WeatherCity? {
        let constructedURL = URLConstants
            .buildURL(method: .latLon(Latitude: String(latitude), Longitude: String(longitude)))

        guard let city = try? await AsyncNetwork.shared.fetchData(url: constructedURL, type: WeatherCity.self) else {
            return nil
        }
        return city
    }
    

}


