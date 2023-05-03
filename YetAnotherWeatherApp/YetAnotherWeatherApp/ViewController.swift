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
    
    private var anyCancellables = Set<AnyCancellable>()
    
    // IBOutlets
    @IBOutlet weak var weatherSearchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var shareLocation: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    
    // MARK: - Data Calls
    
    func getWeatherCityby(name: String) async -> WeatherCity? {
        return await WeatherManager.shared.getWeatherByCity(name: name)
    }
    }

    
    func initializeWeatherView(city: WeatherCity) {
        let weatherVM = WeatherViewModel(city: city)
        let swiftView = UIHostingController(rootView: WeatherDetailView(weatherVM: weatherVM))
//        swiftView.modalPresentationStyle = .fullScreen // Can enable this if we don't want to let user go back.
        self.present(swiftView, animated: true)
    }
    @IBAction func searchCity(_ sender: Any) {
        statusLabel.isHidden = true
        
        Task {
            guard let text = weatherSearchField.text,
                  text.count > 2
            else {
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
    }
}

