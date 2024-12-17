//
//  WeatherViewModel.swift
//  Weather Tracker
//
//  Created by Alfredo Perry on 12/15/24.
//

import Foundation
import Combine

struct WeatherAPIConfig{
    static let baseUrl = "https://api.weatherapi.com/v1"
    static let apiKey = "bcffea6309ab42dea3440259241612"
}

protocol WeatherServiceProtocol {
    func searchLocation(query: String) async throws -> [LocationSearch]
    func getCurrentWeather(for city: String) async throws -> WeatherData
}

class WeatherTrackerService: WeatherServiceProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func searchLocation(query: String) async throws -> [LocationSearch] {
        guard !query.isEmpty else { return [] }
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(WeatherAPIConfig.baseUrl)/current.json?key=\(WeatherAPIConfig.apiKey)&q=\(encodedQuery)") else {
            throw WeatherError.invalidCity
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw WeatherError.networkError("Invalid Response")
            }
            
            guard httpResponse.statusCode == 200 else {
                throw WeatherError.networkError("Status code: \(httpResponse.statusCode)")
            }
            
            let decoder = JSONDecoder()
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            let locationSearch = LocationSearch(name: weatherData.location.name, weather: weatherData)
            return [locationSearch]
            
        } catch {
            throw WeatherError.networkError(error.localizedDescription)
        }
    }
    
    func getCurrentWeather(for city: String) async throws -> WeatherData {
        guard let url = URL(string: "\(WeatherAPIConfig.baseUrl)/current.json?key=\(WeatherAPIConfig.apiKey)&q=\(city)") else {
            throw WeatherError.invalidCity
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw WeatherError.networkError("Invalid response")
            }
            
            guard httpResponse.statusCode == 200 else {
                throw WeatherError.networkError("Status code: \(httpResponse.statusCode)")
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(WeatherData.self, from: data)
        } catch {
            throw WeatherError.networkError(error.localizedDescription)
        }
    }
}

class WeatherViewModel: ObservableObject {
    
    // These properties automatically notify the view when they change
    @Published var currentWeather: WeatherData? // The current weather for the selected city
    @Published var searchResults: [LocationSearch] = [] // List of cities matching the search
    @Published var isLoading = false // Loading state for UI feedback
    @Published var error: String? // Error messages to display to the user
    
    // MARK: - Private Properties
    
    // The service that handles all weather API calls
    private let weatherService: WeatherServiceProtocol
    
    // Combine-related properties for handling search
    private var searchCancellable: AnyCancellable? // Stores our subscription to prevent it from being canceled
    private let searchSubject = PassthroughSubject<String, Never>() // Emits search text changes
    
    // MARK: - Initialization
    
    init(weatherService: WeatherServiceProtocol = WeatherTrackerService(session: .shared)) {
        self.weatherService = weatherService
        setupSearchSubscription()
        loadSavedCity() // Load the previously selected city when the app starts
    }
    
    // MARK: - Search Setup
    
    private func setupSearchSubscription() {
        searchCancellable = searchSubject
            // Wait for 300ms of no typing before performing search
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            // Don't search again if the text hasn't changed
            .removeDuplicates()
            // Handle the search text
            .sink { [weak self] searchText in
                // Only search if we have text to search for
                if !searchText.isEmpty {
                    Task {
                        await self?.performSearch(query: searchText)
                    }
                } else {
                    // Clear results if search is empty
                    self?.searchResults = []
                }
            }
    }
    
    // MARK: - Public Methods
    
    func search(query: String) {
        searchSubject.send(query)
    }
    
    @MainActor
    func selectCity(_ city: String) async {
        isLoading = true
        error = nil
        
        do {
            // Get the weather data for the selected city
            currentWeather = try await weatherService.getCurrentWeather(for: city)
            // Save the city selection for next time the app launches
            UserDefaults.standard.set(city, forKey: UserDefaultsKeys.savedCity)
        } catch WeatherError.invalidCity {
            error = "City not found. Please try another location."
        } catch WeatherError.networkError(let message) {
            error = "Network error: \(message)"
        } catch WeatherError.decodingError {
            error = "Unable to process weather data. Please try again."
        } catch {
            //.error = "An unexpected error occurred. Please try again."
        }
        
        isLoading = false
    }
    
    /// Refreshes the weather for the currently selected city
    @MainActor
    func refreshCurrentWeather() async {
        // Only refresh if we have a city selected
        guard let cityName = currentWeather?.location.name else { return }
        await selectCity(cityName)
    }
    
    // MARK: - Private Methods
    
    @MainActor
    private func performSearch(query: String) async {
        isLoading = true
        error = nil
        
        do {
            searchResults = try await weatherService.searchLocation(query: query)
            if searchResults.isEmpty {
                error = "No cities found matching '\(query)'"
            }
        } catch {
            searchResults = []
            self.error = "Search failed: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    /// Loads the previously saved city when the app launches
    private func loadSavedCity() {
        // Check if we have a saved city
        if let savedCity = UserDefaults.standard.string(forKey: UserDefaultsKeys.savedCity) {
            // Load the weather for that city
            Task {
                await selectCity(savedCity)
            }
        }
    }
}
