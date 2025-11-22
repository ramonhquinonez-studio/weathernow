//
//  WeatherRepository.swift
//  WeatherNow
//
//  Created by Ramón H. Quiñonez on 21/11/25.
//

import Foundation

public protocol WeatherRepository {
    func currentWeather(for city: String) async throws -> Weather
}
