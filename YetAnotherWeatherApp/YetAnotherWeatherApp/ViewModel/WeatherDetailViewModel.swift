//
//  WeatherDetailViewModel.swift
//  Weather-App-MVVM
//
//  Created by Kautilya Save on 5/2/23.
//

import Combine
import Foundation
import CoreLocation

@MainActor
class WeatherDetailViewModel: ObservableObject {
    
    // Exposed
    @Published var weatherVM: WeatherViewModel?
    
    // Private
    private var anyCancellables = Set<AnyCancellable>()
    private var locationManager: LocationManager = LocationManager.shared
    
    private var weatherService: WeatherServiceProtocol
    
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
        fetchWeatherByLocation()
    }
    
    func fetchWeatherByLocation() {
        locationManager
            .$location
            .compactMap { $0 }
            .print("🧠 Location subscription ??")
            .asyncMap { [weak self] location in
                let weatherCity = await self?.weatherService.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                return weatherCity
            }
            .compactMap { $0 }
            .removeDuplicates()
            .map { WeatherViewModel(city: $0)}
            .receive(on: DispatchQueue.main)
            .assign(to: &$weatherVM)
    }
    
    
    func fetchWeatherByCity(name: String) {
        locationManager
            .$location
            .compactMap { ($0?.latitude ?? 0.0 , $0?.longitude ?? 0.0) }
            .asyncMap { [weak self]  location -> WeatherViewModel? in
                if let weatherCity = await self?.weatherService.getWeatherByCity(name: name) {
                    return WeatherViewModel(city: weatherCity)
                }
                return nil
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$weatherVM)
    }
    
    
    
}

// Consumable ViewModel for WeatherView
struct WeatherViewModel {
    
    let city: WeatherCity
    
    // Generating URL + icon ID
    var iconURL: URL {
        let iconURLCreation = city.weather.first?.icon
        let baseURL = "https://openweathermap.org/img/wn/"
        let defaultURL: URL = URL(string: "https://openweathermap.org/img/wn/10d@2x.png")!
        guard
            let icon = iconURLCreation else {
            return defaultURL
        }
        let constructedURL = baseURL + icon + "@2x.png"
        print("Generated ICON URL \(constructedURL)")
        
        guard let url = URL(string: constructedURL) else {
            return defaultURL
        }
        return url
    }
    
}
