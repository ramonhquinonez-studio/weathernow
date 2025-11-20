import Foundation

struct APIWeatherRepository: WeatherRepository {
    let client: APIClient

    func currentWeather(for city: String) async throws -> Weather {
        var req = Endpoints.weather()
        req.httpBody = try JSONEncoder().encode(["city": city])
        return try await client.get(req)
    }
}
