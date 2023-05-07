//
//  ViewController.swift
//  YetAnotherWeatherApp
//
//  Created by Kautilya Save on 5/2/23.
//

import UIKit
import Combine
import CoreLocation
import SwiftUI

class ViewController: UIViewController {
    
    private var locationManager: LocationManager = LocationManager.shared
    private var anyCancellables = Set<AnyCancellable>()
    private let viewModel = WeatherDetailViewModel(weatherService: WeatherManager.shared)
    
    // IBOutlets
    @IBOutlet weak var weatherSearchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var shareLocation: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestLocation()
        /*
         We can have this initial `Storyboard` screen to show welcome screen.
         And ask for delayed permission of locations.
         If they don't give permission we can show alerts
         We can show a customizable UI with search option by name for weather.
         Sadly I didn't have a personal iPhone at the moment. So only did my testing on a simulator.
         Of course I wanted to stop here since it is very easy to go above and beyond from the MVP of the product and just spend too much time on something.
         Also changing locations settings in simulator isn't reflecting the changes properly.
         https://developer.apple.com/forums/thread/693317
        */
        
        
        view.backgroundColor = .lightGray
        statusLabel.isHidden = true
        // testWeatherAPIByCity()
        shouldRestoreState()
        initializeStatusLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    
    // MARK: - Data Calls
    
    func getWeatherCityby(name: String) async -> WeatherCity? {
        return await WeatherManager.shared.getWeatherByCity(name: name)
    }
    
    func testWeatherAPIByCity() {
        Task {

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
        }
    }
    
    
    // Initialize UI screens
    func initializeLocationWithWeatherView() {
        locationManager.requestLocation()
        
        viewModel.fetchWeatherByLocation()

        viewModel
            .$weatherVM
            .sink { [weak self] weatherVM in
                if let weatherVM {
                    let swiftView = UIHostingController(rootView: WeatherDetailView(weatherVM: weatherVM))
                    // swiftView.modalPresentationStyle = .fullScreen // Can enable this if we don't want to let user go back.
                    self?.present(swiftView, animated: true)
                }

            }
            .store(in: &anyCancellables)

    }
    
    
    func initializeWeatherView(city: WeatherCity) {
        let weatherVM = WeatherViewModel(city: city)
        let swiftView = UIHostingController(rootView: WeatherDetailView(weatherVM: weatherVM))
        // swiftView.modalPresentationStyle = .fullScreen // Can enable this if we don't want to let user go back.
        self.present(swiftView, animated: true)
    }
    
    func initializeStatusLabel() {
        WeatherManager
            .shared
            .$status
            .filter { $0 != "" }
            .map { [weak self] value in
                self?.statusLabel.isHidden = false
                return value
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.text!, on: statusLabel)
            .store(in: &anyCancellables)
        
    }
    
    // MARK: - Helper Functions
    
    func shouldRestoreState() {
        if let result = WeatherAppPreferences.shared.shouldResumeState() {
            if result == UserDefaultsKey.locationAccessGranted.rawValue {
                statusLabel.isHidden = true
                initializeLocationWithWeatherView()
            } else {
                Task {
                    if let city = await getWeatherCityby(name: result) {
                        initializeWeatherView(city: city)
                    } else {
                        initializeStatusLabel()
                    }
                }

            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func searchCity(_ sender: Any) {
        statusLabel.isHidden = true
        
        Task {
            guard let text = weatherSearchField.text,
                  text.count > 2
            else {
                statusLabel.isHidden = false
                statusLabel.text = "Enter more than 3 characters"
                return
            }
            WeatherAppPreferences.shared.set(key: .citySearched, value: text)
            guard let city = await getWeatherCityby(name: text) else {
                statusLabel.isHidden = false
                WeatherManager
                    .shared
                    .$status
                    .receive(on: DispatchQueue.main)
                    .assign(to: \.text!, on: statusLabel)
                    .store(in: &anyCancellables)
                
                return
            }
            
            initializeWeatherView(city: city)
        }
    }
    
    @IBAction func shareLocationPressed(_ sender: Any) {
        statusLabel.isHidden = true
        initializeLocationWithWeatherView()
    }

}

