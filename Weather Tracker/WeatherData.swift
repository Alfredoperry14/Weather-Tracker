//
//  WeatherData.swift
//  Weather Tracker
//
//  Created by Alfredo Perry on 12/15/24.
//

import Foundation

struct WeatherData: Codable {
    let location: Location
    let current: CurrentWeather?
}

struct Location: Codable {
    let name: String
    let region: String
    let country: String
}

struct CurrentWeather: Codable {
    let tempC: Double
    let tempF: Double
    let feelsLikeC: Double
    let feelsLikeF: Double
    let uv: Double
    let humidity: Int
    let condition: WeatherCondition
    
    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case tempF = "temp_f"
        case feelsLikeC = "feelslike_c"
        case feelsLikeF = "feelslike_f"
        case uv
        case condition
        case humidity
    }
}

struct WeatherCondition: Codable {
    let text: String
    let icon: String
}

struct LocationSearch {
    let name: String
    let weather: WeatherData
}

enum WeatherError: Error {
    case invalidCity
    case networkError(String)
    case decodingError
    case unknown
}

enum UserDefaultsKeys {
    static let savedCity = "savedCity"
}
