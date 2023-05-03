//
//  WeatherView.swift
//  Weather-App-MVVM
//
//  Created by Kautilya Save on 5/2/23
//

import SwiftUI
import SwiftSense

struct WeatherView: View {
    var weather: WeatherCity
    var icon: URL
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(weather.name)
                        .bold()
                        .font(.title)
                    
                    Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                        .fontWeight(.light)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                VStack {
                    HStack {
                        VStack {
                            AsyncImageCache(url: icon) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100)
                                    Text("\(weather.weather[0].main)")
                                    
                                default:
                                    ProgressView()
                                }
                            }
                        }
                        .frame(width: 150, alignment: .leading)
                        
                        Spacer()
                        
                        Text(weather.main.feelsLike.roundValue() + "°")
                            .font(.system(size: 80))
                            .fontWeight(.bold)
                            .padding()
                    }
                    
                    Spacer()
                        .frame(height:  80)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 20) {
                    Text("Information")
                        .bold()
                        .padding(.bottom)
                    
                    // Utilizing SF Symbols 3 & could be kept in an enum to not mispell these values or units.
                    HStack {
                        WeatherRow(logo: "thermometer", name: "Min temp", value: (weather.main.tempMin.roundValue() + ("°")))
                        Spacer()
                        WeatherRow(logo: "wind", name: "Wind m/s", value: (weather.wind.speed.roundValue() + " m"))
                        
                    }
                    .frame(width: 350)
                    
                    HStack(alignment: .center) {
                        WeatherRow(logo: "thermometer", name: "Max temp", value: (weather.main.tempMax.roundValue() + "°"))
                        
                        Spacer()
                        WeatherRow(logo: "humidity", name: "Humidity", value: "\(weather.main.humidity)%")
                    }
                    .frame(width: 350)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.bottom, 20)
                .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                .background(.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(
            AsyncImage(url: URL(string: URLConstants.backgroundImageURL)) { image in
                image
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
        )
        .preferredColorScheme(.dark)
    }
}
