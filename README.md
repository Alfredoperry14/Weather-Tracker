# Weather Tracker App

A SwiftUI-based weather application that allows users to search for cities and display current weather conditions.

## Setup Instructions

### Prerequisites
- Xcode 15.0 or later
- iOS 16.0+ deployment target
- Active internet connection
- WeatherAPI.com API key

### Installation Steps
1. Clone the repository:
```bash
git clone [your-repository-url]
cd [repository-name]
```

2. API Key Configuration:
- Sign up for a free API key at [WeatherAPI.com](https://www.weatherapi.com)
- Open the project in Xcode
- Navigate to `WeatherAPIConfig.swift`
- Replace `YOUR_API_KEY` with your actual API key:
```swift
static let apiKey = "YOUR_API_KEY"
```

Currently my api key is provided

3. Build and Run:
- Open `WeatherTracker.xcodeproj` in Xcode
- Select your target device/simulator
- Press ⌘+R to build and run the project

### Potential Setup Issues
- If you encounter any certificate errors, ensure your system clock is set correctly
- If the API key isn't working, verify it's been activated in your WeatherAPI.com dashboard

## App Usage

### Features
- Search for cities worldwide
- View current weather conditions including:
  - Temperature
  - Weather condition with icon
  - Humidity percentage
  - UV index
  - "Feels like" temperature
- Automatically saves your last selected city

### How to Use
1. On first launch, use the search bar to find your city
2. Tap on a search result to select it
3. The app will remember your selection and show it on future launches
4. To change cities, simply search and select a new one

## Technical Details

### Architecture
- MVVM Design Pattern
- SwiftUI for UI implementation
- Async/await for network calls
- UserDefaults for persistence

### Third-Party Dependencies
- None (uses only native frameworks)

## Testing

To run the tests:
1. Open the project in Xcode
2. Press ⌘+U to run all tests

## Contact

If you encounter any issues during setup, please contact alfredoperry14@gmail.com
