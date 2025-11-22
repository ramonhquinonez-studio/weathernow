//
//  WeatherScreenView.swift
//  WeatherNow
//
//  Created by Ramón H. Quiñonez on 21/11/25.
//


import SwiftUI

struct WeatherScreenView: View {
    @State private var city: String = "Guadalajara"
    @State private var query: String = ""
    @State private var vm: WeatherViewModel
    @State private var searchTask: Task<Void, Never>?

    init() {
        let client = URLSessionAPIClient()
        let fetch = DefaultFetchWeatherUseCase(
            repo: APIWeatherRepository(client: client)
        )
        let search = DefaultSearchCitiesUseCase(client: client)

        _vm = State(initialValue: WeatherViewModel(
            fetch: fetch,
            search: search
        ))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.blue, .indigo],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                content
                    .padding(.vertical, 32)
                    .padding(.horizontal, 16)
            }
            .preferredColorScheme(.dark)
            .navigationTitle(city)
        }
        .task {
            await vm.load(city: city)
        }
        .searchable(
            text: $query,
            placement: .navigationBarDrawer,
            prompt: "Buscar ciudad"
        ) {
            // SUGERENCIAS EN TIEMPO REAL
            ForEach(vm.suggestions) { suggestion in
                Button {
                    select(suggestion)
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(suggestion.displayName)
                            if !suggestion.subtitle.isEmpty {
                                Text(suggestion.subtitle)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
        .onChange(of: query) { newValue in
            // debounce: esperamos un poco antes de buscar
            searchTask?.cancel()
            let currentQuery = newValue
            searchTask = Task { [vm] in
                try? await Task.sleep(nanoseconds: 300_000_000) // 0.3s
                await vm.searchCities(query: currentQuery)
            }
        }
        .onSubmit(of: .search) {
            // Enter en el teclado usa el texto tal cual
            let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return }
            Task {
                city = trimmed
                await vm.load(city: city)
                await vm.clearSuggestions()
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch vm.state {
        case .idle, .loading:
            ProgressView()
        case .error(let msg):
            VStack(spacing: 12) {
                Text("Error")
                    .font(.title2)
                Text(msg)
                    .multilineTextAlignment(.center)
                Button("Reintentar") {
                    Task { await vm.load(city: city) }
                }
                .buttonStyle(.borderedProminent)
            }
        case .loaded(let weather):
            ScrollView {
                VStack(spacing: 24) {
                    header(weather: weather)
                    // aquí luego metemos hourly/daily reales
                }
            }
        }
    }

    private func header(weather: Weather) -> some View {
        VStack(spacing: 8) {
            Text(weather.city)
                .font(.system(size: 34, weight: .medium))
            Text("\(Int(weather.tempC))°")
                .font(.system(size: 72, weight: .thin))
            Text(weather.description)
                .font(.title3)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private func select(_ suggestion: CitySuggestion) {
        Task {
            city = suggestion.displayName
            query = suggestion.displayName
            await vm.clearSuggestions()
            await vm.load(city: suggestion.name)
        }
    }
}

#Preview {
    WeatherScreenView()
}
