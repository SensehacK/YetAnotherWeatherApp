//
//  enums.swift
//  Weather-App-MVVM
//
//  Created by Kautilya Save on 5/2/23
//

import Foundation

enum openWeatherFeature {
    case city(name:String)
    case latLon(Latitude:String, Longitude: String)
}

enum unitSystem: String {
    case imperial
    case metric
}
