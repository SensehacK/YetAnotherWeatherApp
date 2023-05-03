//
//  WeatherGeocoding.swift
//  Weather-App-MVVM
//
//  Created by Kautilya Save on 5/2/23.
//

import Foundation

// MARK: - CityAPIElement
struct CityAPIElement: Codable {
    let name: String
    let lat, lon: Double
    let country, state: String

}
