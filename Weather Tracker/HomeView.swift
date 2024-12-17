//
//  WeatherView.swift
//  Weather Tracker
//
//  Created by Alfredo Perry on 12/15/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var isSearching = false
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Empty State
                if viewModel.searchResults.isEmpty {
                    VStack {
                        Spacer()
                        NoCitiesFound()
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                }
                
                // Weather View
                if let _ = viewModel.currentWeather, !isSearching {
                    WeatherHomeView(viewModel: viewModel)
                        .transition(.opacity)
                }
                
                // Main content
                VStack {
                    SearchBar(searchText: $searchText, isSearching: $isSearching, viewModel: viewModel)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .padding()
                    }
                    
                    // Search Results
                    searchResultsView
                        .padding(.top, 32)
                    
                    Spacer()
                }
            }
            .animation(.easeInOut(duration: 0.3), value: isSearching)
        }
    }
    
    @ViewBuilder
    private var searchResultsView: some View {
        if !viewModel.searchResults.isEmpty {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.searchResults, id: \.name) { result in
                        SearchResultCard(
                            cityName: result.name,
                            temperature: result.weather.current?.tempC ?? 0,
                            iconUrl: getIconUrl(iconPath: result.weather.current?.condition.icon ?? "")
                        ) {
                            Task {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    searchText = ""
                                    isSearching = false
                                }
                                await viewModel.selectCity(result.name)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .transition(.opacity)
        }
    }
    
    private func getIconUrl(iconPath: String) -> URL? {
        if iconPath.hasPrefix("//") {
            return URL(string: "https:" + iconPath)
        }
        return URL(string: iconPath)
    }
}

struct SearchBar: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    @ObservedObject var viewModel: WeatherViewModel
    var body: some View {
        HStack {
            TextField("Search Location", text: $searchText)
                .font(Font.custom("Poppins-Regular", size: 16))
                .autocorrectionDisabled()
                .onChange(of: searchText) {
                    viewModel.search(query: searchText)
                    isSearching = !searchText.isEmpty
                }
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
        )
        .padding(.horizontal, 24)
        .padding(.top, 44)
    }
}

struct NoCitiesFound: View {
    var body: some View {
        VStack {
            Text("No City Selected")
                .font(Font.custom("Poppins-SemiBold", size: 30))
                .padding()
            Text("Please Search for a city")
                .font(Font.custom("Poppins-SemiBold", size: 16))
        }
    }
}

#Preview {
    HomeView()
}
