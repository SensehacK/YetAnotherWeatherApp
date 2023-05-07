//
//  MockWeatherViewModel.swift
//  YetAnotherWeatherAppTests
//
//  Created by Kautilya Save on 5/7/23.
//

import Foundation
@testable import YetAnotherWeatherApp

// Mock ViewModel
class MockWeatherViewModel: WeatherServiceProtocol {
    func getCurrentWeather(latitude: Double, longitude: Double) async -> WeatherCity? {
        return nil
    }
    
    func getWeatherByCity(name: String) async -> WeatherCity? {
        return nil
    }
    
    var status: String = ""

}
