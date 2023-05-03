//
//  URLConstants.swift
//  Weather-App-MVVM
//
//  Created by Kautilya Save on 5/2/23.
//

import Foundation

struct URLConstants {
    static let baseURL: String = "https://api.openweathermap.org/data/2.5/weather?"
    static let baseGeoURL: String = "http://api.openweathermap.org/geo/1.0/direct?q="
    static let apiURL: String = apiKey + apiValue
    static let backgroundImageURL: String = "https://i.pinimg.com/originals/42/a3/4a/42a34abf71e348d893be96affee43fcc.jpg"
    
    // Other Keys
    static let apiKey: String = "&appid="
    static let apiValue: String = "b25ecd39a0f08f16aed86d6ffaafc964"
    static let unitsKey: String = "&units="
    static let latKey: String = "lat="
    static let lonKey: String = "&lon="
    static let limitKey: String = "&limit="

    // Dummy URLS
    struct Dummy {
        static let latLonURL: String = "https://api.openweathermap.org/data/2.5/weather?lat=40.730610&lon=-73.935242&appid=b25ecd39a0f08f16aed86d6ffaafc964&units=imperial"
    }

    // Can always utilize URL components for better verification
    static func buildURL(method: openWeatherFeature, unit: unitSystem = .imperial, limit: String = "1") -> String {
        switch method {
        
        case .city(let name):
            if let urlEncoded = name.addingPercentEncoding(withAllowedCharacters: .alphanumerics) {
                return baseGeoURL + urlEncoded + limitKey + limit + apiURL
            } else {
                print("Couldn't Build City URL! so returning dummy URL")
                return Dummy.geoCoding
            }
            
    }
}


