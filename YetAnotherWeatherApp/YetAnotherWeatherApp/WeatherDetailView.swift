//
//  WeatherDetailView.swift
//  Weather-App-MVVM
//
//  Created by Kautilya Save on 5/2/23.
//

import SwiftUI
import UserNotifications

struct WeatherDetailView: View {
    @State var weatherVM: WeatherViewModel
    
    var body: some View {
        VStack {
            WeatherView(weather: weatherVM.city, icon: weatherVM.iconURL)
        }
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
