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
//    let localNames: LocalNames?
    let lat, lon: Double
    let country, state: String

//    enum CodingKeys: String, CodingKey {
//        case name
////        case localNames = "local_names"
//        case lat, lon, country, state
//    }
}

// MARK: - LocalNames
struct LocalNames: Codable {
    let zh, ja, ta, ru: String
    let es, bn, ar, oc: String
    let hi, te, fa, ko: String
    let eo, ps, uk, mr: String
    let el, ur, en, pl: String
}

typealias CityAPI = [CityAPIElement]
