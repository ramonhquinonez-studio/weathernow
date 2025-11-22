//
//  OpenMeteoDTOs.swift
//  WeatherNow
//
//  Created by Ramón H. Quiñonez on 21/11/25.
//

import Foundation

// Geocoding
struct OpenMeteoGeocodingResponse: Decodable {
    struct Result: Decodable {
        let name: String
        let latitude: Double
        let longitude: Double
        let country: String?
        let admin1: String?
    }

    let results: [Result]?
}

// Forecast (current)
struct OpenMeteoForecastResponse: Decodable {
    struct Current: Decodable {
        let time: String
        let temperature: Double
        let weatherCode: Int

        enum CodingKeys: String, CodingKey {
            case time
            case temperature = "temperature_2m"
            case weatherCode = "weather_code"
        }
    }

    let latitude: Double
    let longitude: Double
    let current: Current
}
