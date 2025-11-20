import Foundation

public protocol FetchWeatherUseCase {
    func execute(city: String) async throws -> Weather
}

public struct DefaultFetchWeatherUseCase: FetchWeatherUseCase {
    let repo: WeatherRepository
    public init(repo: WeatherRepository) { self.repo = repo }
    public func execute(city: String) async throws -> Weather {
        try await repo.currentWeather(for: city)
    }
}
