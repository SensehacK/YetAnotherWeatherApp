//
//  WeatherServiceProtocol.swift
//  YetAnotherWeatherApp
//
//  Created by Kautilya Save on 5/7/23.
//

import Foundation

protocol WeatherServiceProtocol {
    var status: String { get set }
    func getCurrentWeather(latitude: Double, longitude: Double) async -> WeatherCity?
    func getWeatherByCity(name: String) async -> WeatherCity?
}
