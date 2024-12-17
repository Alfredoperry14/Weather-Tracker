//
//  WeatherView.swift
//  Weather Tracker
//
//  Created by Alfredo Perry on 12/16/24.
//

import SwiftUI

struct WeatherHomeView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            if let weather = viewModel.currentWeather, let current = weather.current {
                // Weather icon from API
                AsyncImage(url: getIconUrl(iconPath: current.condition.icon)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .frame(width: 123, height: 123)
                    case .failure(_):
                        Image(systemName: "cloud.fill")
                            .resizable()
                            .scaledToFit()
                    @unknown default:
                        EmptyView()
                    }
                }
                
                // Location name with plane icon
                HStack(spacing: 8) {
                    Text(weather.location.name)
                        .font(.poppins(.semibold, size: 30))
                    Image("Vector")
                }
                .padding(.top, 24)
                
                // Temperature
                HStack {
                    Text("\(Int(current.tempC))")
                        .font(.poppins(.semibold, size: 70))
                        .padding(.top, -24)
                    Text("°")
                        .font(.poppins(.regular, size: 20))
                        .foregroundColor(.black)
                        .padding(.top, -50)

                }
                .padding(.bottom, -8) // Add negative padding to bring the card closer
                
                // Weather metrics card
                HStack(spacing: 56) {
                    // Humidity
                    VStack(spacing: 4) {
                        Text("Humidity")
                            .font(.poppins(.regular, size: 12))
                            .foregroundColor(.gray)
                        Text("\(current.humidity)%")
                            .foregroundStyle(Color.customGray)
                            .font(.poppins(.medium, size: 15))
                    }
                    
                    // UV Index
                    VStack(spacing: 4) {
                        Text("UV")
                            .font(.poppins(.regular, size: 12))
                            .foregroundColor(.gray)
                        Text("\(Int(current.uv))")
                            .foregroundStyle(Color.customGray)
                            .font(.poppins(.medium, size: 15))
                    }
                    
                    // Feels Like
                    VStack(spacing: 4) {
                        Text("Feels Like")
                            .font(.poppins(.regular, size: 8))
                            .foregroundColor(.gray)
                        Text("\(Int(current.feelsLikeC))°")
                            .foregroundStyle(Color.customGray)
                            .font(.poppins(.regular, size: 15))
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(16)
                .frame(width: 274)
                
            } else {
                ProgressView()
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
    
    private func getIconUrl(iconPath: String) -> URL? {
        // The API returns paths like "//cdn.weatherapi.com/weather/64x64/day/116.png"
        // We need to add https: to the beginning
        if iconPath.hasPrefix("//") {
            return URL(string: "https:" + iconPath)
        }
        return URL(string: iconPath)
    }
}

#Preview {
    WeatherHomeView(viewModel: WeatherViewModel())
}
