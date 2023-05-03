//
//  ViewController.swift
//  YetAnotherWeatherApp
//
//  Created by Kautilya Save on 5/2/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    
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


    
    @IBAction func shareLocationPressed(_ sender: Any) {
        statusLabel.isHidden = true
    }
}

