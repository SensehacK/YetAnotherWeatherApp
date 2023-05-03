//
//  WeatherDetailViewModel.swift
//  Weather-App-MVVM
//
//  Created by Kautilya Save on 5/2/23.
//

import Combine
import Foundation

@MainActor
class WeatherDetailViewModel: ObservableObject {
    
    // Exposed
    @Published var weatherVM: WeatherViewModel?
    
    // Private
    private var anyCancellables = Set<AnyCancellable>()
    private var locationManager: LocationManager = LocationManager.shared
    
    func fetchWeatherByLocation() -> WeatherCity? {
        let _ = locationManager
            .$location

            .compactMap { ($0?.latitude ?? 0.0 , $0?.longitude ?? 0.0) }
            .asyncMap { location -> WeatherCity? in
                let weatherService = WeatherManager.shared
                return await weatherService.getCurrentWeather(latitude: location.0,
                                                              longitude: location.1)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weather in
                if let weather {
                    self?.weatherVM = WeatherViewModel(city: weather)
                }
            }
            .store(in: &anyCancellables)
        return nil
    }
    
    func fetchWeatherByLocation2() {
        locationManager
            .$location
            .compactMap { ($0?.latitude ?? 0.0 , $0?.longitude ?? 0.0) }
            .asyncMap { location -> WeatherViewModel? in
                let weatherService = WeatherManager.shared
                if let weatherCity =  await weatherService.getCurrentWeather(latitude: location.0,
                                                                             longitude: location.1) {
                    return WeatherViewModel(city: weatherCity)
                }
                return nil
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$weatherVM)
    }
    
    
    func fetchWeatherByCity(name: String) {
        locationManager
            .$location
            .compactMap { ($0?.latitude ?? 0.0 , $0?.longitude ?? 0.0) }
            .asyncMap { location -> WeatherViewModel? in
                let weatherService = WeatherManager.shared
                if let weatherCity = await weatherService.getWeatherByCity(name: name) {
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
