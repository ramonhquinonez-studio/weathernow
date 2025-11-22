//
//  Endpoints.swift
//  WeatherNow
//
//  Created by Ramón H. Quiñonez on 21/11/25.
//

import Foundation

enum Endpoints {
    // Geocoding: ciudad -> lat/long
    static func geocodingURL(for city: String, count: Int = 1) -> URL {
        var comps = URLComponents(string: "https://geocoding-api.open-meteo.com/v1/search")!
        comps.queryItems = [
            .init(name: "name", value: city),
            .init(name: "count", value: "\(count)"),
            .init(name: "language", value: "es"),
            .init(name: "format", value: "json")
        ]
        return comps.url!
    }

    // Forecast: lat/long -> clima actual
    static func forecastURL(lat: Double, lon: Double) -> URL {
        var comps = URLComponents(string: "https://api.open-meteo.com/v1/forecast")!
        comps.queryItems = [
            .init(name: "latitude", value: "\(lat)"),
            .init(name: "longitude", value: "\(lon)"),
            .init(name: "current", value: "temperature_2m,weather_code"),
            .init(name: "timezone", value: "auto")
        ]
        return comps.url!
    }
}
