//
//  WeatherViewModel.swift
//  WeatherNow
//
//  Created by Ramón H. Quiñonez on 21/11/25.
//

import Foundation
import Observation

@Observable
final class WeatherViewModel {
    enum State {
        case idle
        case loading
        case loaded(Weather)
        case error(String)
    }

    private let fetchUseCase: FetchWeatherUseCase
    private let searchUseCase: SearchCitiesUseCase

    init(fetch: FetchWeatherUseCase, search: SearchCitiesUseCase) {
        self.fetchUseCase = fetch
        self.searchUseCase = search
    }

    var state: State = .idle
    var suggestions: [CitySuggestion] = []

    // Cargar el clima de una ciudad
    @MainActor
    func load(city: String) async {
        state = .loading
        do {
            let w = try await fetchUseCase.execute(city: city)
            state = .loaded(w)
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    // Buscar ciudades mientras se escribe
    @MainActor
    func searchCities(query: String) async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.count < 2 {
            suggestions = []
            return
        }

        do {
            let results = try await searchUseCase.search(cityName: trimmed)
            suggestions = results
        } catch {
            suggestions = []
        }
    }

    @MainActor
    func clearSuggestions() {
        suggestions = []
    }
}
