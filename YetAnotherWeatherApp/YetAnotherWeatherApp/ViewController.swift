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
    
    // IBOutlets
    @IBOutlet weak var weatherSearchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var shareLocation: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestLocation()
        view.backgroundColor = .lightGray
        statusLabel.isHidden = true
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
//        WeatherDetailViewModel
        let vm = WeatherDetailViewModel()
        vm.fetchWeatherByLocation2()

        vm
            .$weatherVM.print()
            .sink { [weak self] weatherVM in
                if let weatherVM {
                    let swiftView = UIHostingController(rootView: WeatherDetailView(weatherVM: weatherVM))
//                    swiftView.modalPresentationStyle = .fullScreen // Can enable this if we don't want to let user go back.
                    self?.present(swiftView, animated: true)
                }

            }
            .store(in: &anyCancellables)

    }
    
    
    func initializeWeatherView(city: WeatherCity) {
        let weatherVM = WeatherViewModel(city: city)
        let swiftView = UIHostingController(rootView: WeatherDetailView(weatherVM: weatherVM))
//        swiftView.modalPresentationStyle = .fullScreen // Can enable this if we don't want to let user go back.
        self.present(swiftView, animated: true)
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

