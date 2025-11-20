import Foundation
import Observation

@Observable final class WeatherViewModel {
    enum State { case idle, loading, loaded(Weather), error(String) }
    private let fetch: FetchWeatherUseCase
    init(fetch: FetchWeatherUseCase) { self.fetch = fetch }
    var state: State = .idle

    @MainActor
    func load(city: String) async {
        state = .loading
        do {
            let write = try await fetch.execute(city: city)
            state = .loaded(write)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
