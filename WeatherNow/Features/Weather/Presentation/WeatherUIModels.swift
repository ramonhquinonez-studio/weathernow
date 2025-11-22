//
//  WeatherUIModels.swift
//  WeatherNow
//
//  Created by Ramón H. Quiñonez on 21/11/25.
//

// Features/Weather/Presentation/WeatherUIModels.swift
import Foundation

struct HourForecastUI: Identifiable {
    let id = UUID()
    let hourLabel: String   // "Ahora", "14:00", etc
    let symbolName: String  // SF Symbol
    let tempLabel: String   // "24°"
}

struct DayForecastUI: Identifiable {
    let id = UUID()
    let dayLabel: String    // "Hoy", "Mañana", "Lun"
    let symbolName: String  // SF Symbol
    let maxTempLabel: String
    let minTempLabel: String
}
