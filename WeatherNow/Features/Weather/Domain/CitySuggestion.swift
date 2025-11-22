//
//  CitySuggestion.swift
//  WeatherNow
//
//  Created by Ramón H. Quiñonez on 21/11/25.
//

import Foundation

struct CitySuggestion: Identifiable, Hashable {
    let id = UUID()
    let name: String       // "Guadalajara"
    let region: String?    // "Jalisco"
    let country: String?   // "México"

    var displayName: String {
        if let region, !region.isEmpty {
            return "\(name), \(region)"
        }
        return name
    }

    var subtitle: String {
        country ?? ""
    }
}
