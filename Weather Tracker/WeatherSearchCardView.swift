//
//  WeatherSearchCardView.swift
//  Weather Tracker
//
//  Created by Alfredo Perry on 12/17/24.
//

import SwiftUI

struct SearchResultCard: View {
    let cityName: String
    let temperature: Double
    let iconUrl: URL?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: -13) { // Adjust spacing between city name and temperature
                    Text(cityName)
                        .font(.poppins(.semibold, size: 20))
                        .foregroundColor(.black)
                    
                    HStack(alignment: .top, spacing: 11) {
                        Text("\(Int(temperature))")
                            .font(.poppins(.semibold, size: 60))
                            .foregroundColor(.black)
                        
                        Text("°")
                            .font(.poppins(.regular, size: 20))
                            .foregroundColor(.black)
                            .padding(.top, 8)
                    }
                }
                
                Spacer()
                
                // Weather icon from API
                if let iconUrl = iconUrl {
                    AsyncImage(url: iconUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 80)
                        case .failure(_):
                            Image(systemName: "cloud.fill")
                                .resizable()
                                .frame(width: 83, height: 67)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
            .padding(.horizontal, 31)
            .padding(.top, 16)
            .frame(maxWidth: .infinity)
            .frame(height: 117)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 20) {
        SearchResultCard(
            cityName: "Mumbai",
            temperature: 20,
            iconUrl: URL(string: "https://cdn.weatherapi.com/weather/64x64/day/116.png")
        ) {}
    }
    .padding()
}
