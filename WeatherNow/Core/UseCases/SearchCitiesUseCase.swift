//
//  SearchCitiesUseCase.swift
//  WeatherNow
//
//  Created by Ramón H. Quiñonez on 21/11/25.
//

import Foundation

protocol SearchCitiesUseCase {
    func search(cityName: String) async throws -> [CitySuggestion]
}

struct DefaultSearchCitiesUseCase: SearchCitiesUseCase {
    let client: APIClient

    func search(cityName: String) async throws -> [CitySuggestion] {
        let trimmed = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 2 else { return [] }

        let request = URLRequest(
            url: Endpoints.geocodingURL(for: trimmed, count: 6)
        )

        let response = try await client.get(
            OpenMeteoGeocodingResponse.self,
            from: request
        )

        let results = response.results ?? []
        return results.map { r in
            CitySuggestion(
                name: r.name,
                region: r.admin1,
                country: r.country
            )
        }
    }
}
