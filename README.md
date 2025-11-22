# WeatherNow 🌤

WeatherNow is a small iOS weather app built with **SwiftUI**, designed as a portfolio project to showcase good architecture practices (**MVVM + Use Cases + Repository**), real API consumption and code quality.

The app currently displays **current weather for a city** using the public **Open-Meteo** API, with a **live city search** similar to the iOS Weather app.

---

## Features

- **City search with live suggestions** (like iOS Weather) using Open-Meteo Geocoding API:
  - Suggestions shown as you type
  - Tap a suggestion to load weather for that city
- **Current weather view**:
  - City name
  - Current temperature in °C
  - Human-readable description derived from `weather_code`
- **State-driven UI**:
  - `idle / loading / loaded / error`
  - Error message and retry button when something fails

*(Planned: hourly and daily forecasts, saved cities, current location, etc.)*

---

## Architecture

Pattern: **SwiftUI + MVVM + Use Cases + Repository**

- **WeatherScreenView (SwiftUI View)**
  - Main screen of the app
  - Uses `NavigationStack`, gradient background and `.searchable` for the search bar
  - Observes `WeatherViewModel` and renders the appropriate state (`loading`, `loaded`, `error`) and current weather

- **WeatherViewModel (Presentation Layer)**
  - Exposes:
    - `state: idle / loading / loaded(Weather) / error(String)`
    - `suggestions: [CitySuggestion]` for live search
  - Uses two use cases:
    - `FetchWeatherUseCase` → fetches current weather for a given city
    - `SearchCitiesUseCase` → returns city suggestions while typing
  - Main methods:
    - `load(city:)` → orchestrates weather loading and updates `state`
    - `searchCities(query:)` → queries the geocoding API for suggestions
    - `clearSuggestions()` → clears the suggestion list after selection

- **Core / UseCases**
  - `FetchWeatherUseCase`  
    Receives a `WeatherRepository` and exposes `execute(city:)` returning a domain `Weather`.
  - `SearchCitiesUseCase`  
    Uses `APIClient` and `Endpoints.geocodingURL` to return `[CitySuggestion]`.

- **Data Layer**
  - **Repository Protocol**
    - `WeatherRepository`  
      Defines `currentWeather(for city: String) async throws -> Weather`.
  - **Concrete Repository**
    - `APIWeatherRepository` (Open-Meteo implementation)  
      - Uses Open-Meteo:
        - Geocoding: `https://geocoding-api.open-meteo.com/v1/search`
        - Forecast: `https://api.open-meteo.com/v1/forecast`
      - Flow:
        1. Resolve city → latitude/longitude via geocoding.
        2. Request current forecast (temperature + `weather_code`).
        3. Map the API response to the domain model `Weather(city:tempC:description:)`.
      - Maps `weather_code` → human-readable descriptions (clear, rain, snow, etc.).

  - **DTOs & UI Models**
    - `OpenMeteoGeocodingResponse` → decodes geocoding results.
    - `OpenMeteoForecastResponse` → decodes the `current` block (`temperature_2m`, `weather_code`).
    - `CitySuggestion` → domain model for search suggestions UI.

- **Networking**
  - `APIClient` (protocol) + `URLSessionAPIClient` (implementation):
    - Generic `get(_:from:)` method using `async/await`.
    - Basic HTTP status validation and `DecodingError` logging (prints raw JSON when decoding fails).
  - `Endpoints`
    - `geocodingURL(for:count:)`
    - `forecastURL(lat:lon:)`

---

## Tech Stack

- **Language:** Swift 5.x  
- **UI:** SwiftUI  
- **Architecture:** MVVM + Use Cases + Repository  
- **Networking:** URLSession, JSON, `async/await`  
- **API:** [Open-Meteo](https://open-meteo.com/) (no API key required — ideal for portfolio projects)  
- **Code Quality:**
  - [SwiftLint](https://github.com/realm/SwiftLint) with project rules in `.swiftlint.yml`
  - Integrated as a **Run Script Phase** in Xcode

---

## Requirements

- **Xcode** 15+  
- **iOS** 17+ (deployment target of the app)  
- **Optional:** SwiftLint via Homebrew
  ```bash
  brew install swiftlint
