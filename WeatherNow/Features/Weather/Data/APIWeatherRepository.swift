//
//  APIWeatherRepository.swift
//  WeatherNow
//
//  Created by Ramón H. Quiñonez on 21/11/25.
//

import Foundation

struct APIWeatherRepository: WeatherRepository {
    let client: APIClient

    enum WeatherError: Error {
        case cityNotFound
    }

    func currentWeather(for city: String) async throws -> Weather {
        // 1) Geocoding: ciudad -> coordenadas
        let geocodingRequest = URLRequest(url: Endpoints.geocodingURL(for: city))
        let geocodingResponse = try await client.get(
            OpenMeteoGeocodingResponse.self,
            from: geocodingRequest
        )

        guard let first = geocodingResponse.results?.first else {
            throw WeatherError.cityNotFound
        }

        // 2) Forecast: coordenadas -> clima actual
        let forecastRequest = URLRequest(
            url: Endpoints.forecastURL(
                lat: first.latitude,
                lon: first.longitude
            )
        )

        let forecastResponse = try await client.get(
            OpenMeteoForecastResponse.self,
            from: forecastRequest
        )

        let current = forecastResponse.current
        let description = Self.description(for: current.weatherCode)

        // 3) Mapear al modelo de dominio Weather
        return Weather(
            city: first.name,
            tempC: current.temperature,
            description: description
        )
    }

    private static func description(for code: Int) -> String {
        switch code {
        case 0: return "Despejado"
        case 1, 2, 3: return "Parcialmente nublado"
        case 45, 48: return "Niebla"
        case 51, 53, 55: return "Llovizna"
        case 61, 63, 65: return "Lluvia"
        case 71, 73, 75: return "Nieve"
        case 80, 81, 82: return "Chubascos"
        case 95, 96, 99: return "Tormenta"
        default: return "Condición variable"
        }
    }
}
