import Foundation

public protocol WeatherRepository {
    func currentWeather(for city: String) async throws -> Weather
}
