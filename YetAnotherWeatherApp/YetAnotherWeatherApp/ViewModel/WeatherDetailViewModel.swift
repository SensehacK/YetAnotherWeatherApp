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
    private(set) var locationManager: LocationManager = LocationManager.shared
    
    private(set) var weatherService: WeatherServiceProtocol
    
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
        fetchWeatherByLocation()
        // testWeatherAPIByCity()
    }
    
    // MARK: - Data Calls
    
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
    
    func getWeatherCityby(name: String) async -> WeatherCity? {
        return await weatherService.getWeatherByCity(name: name)
    }
    
    
    func testWeatherAPIByCity() async -> [WeatherCity?] {
        
        let downloadCities = Task { () -> [WeatherCity?] in
            // So the idea behind this multiple Async calls is to get multiple weather cities
            // on app launch if the user has home view with saved cities as a list.
            var cityArr: [WeatherCity?] = []
            async let city1 = getWeatherCityby(name: "Mumbai")
            async let city2 = getWeatherCityby(name: "London")
            async let city3 = getWeatherCityby(name: "Hyderabad")

            cityArr.append(contentsOf: await [city1, city2, city3])
            print("Async Calls")
            for city in cityArr {
                if let city {
                    print("City: \(city.name), Feels like: \(city.main.feelsLike) ")
                }
            }
            return cityArr
        }
        
        
        do {
            let result = try await downloadCities.result.get()
            return result
        } catch {
            
        }
        return []

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
