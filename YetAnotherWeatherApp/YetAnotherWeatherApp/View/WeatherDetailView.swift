//
//  WeatherDetailView.swift
//  Weather-App-MVVM
//
//  Created by Kautilya Save on 5/2/23.
//

import SwiftUI
import UserNotifications

struct WeatherDetailView: View {
    // You can instantiate viewModel from SwiftUI as well. But now I resorted back to UIKit ViewController.
    // @StateObject var viewModel: WeatherDetailViewModel = WeatherDetailViewModel()
    @State var weatherVM: WeatherViewModel
    
    var body: some View {
        VStack {
            WeatherView(weather: weatherVM.city, icon: weatherVM.iconURL)
        }
        .onAppear {
            // We can notifications as well.
//            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { _, _ in
//                
//            }
        }
        /*
         When using SwiftUI ViewModel instantiation
        .task {
            for await newWeather in viewModel.$weatherVM.values {
                if let newWeather {
                    weatherVM = newWeather
                }
                
            }
        }
        */
    }
}

struct WeatherDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        switch WeatherCity.from(localJSON: "WeatherCity") {
        case .success(let value):
            let weatherVM = WeatherViewModel(city: value)
            WeatherView(weather: weatherVM.city, icon: weatherVM.iconURL)
        case .failure(_):
            Text("Couldn't parse JSON data")
        }
    }
}
