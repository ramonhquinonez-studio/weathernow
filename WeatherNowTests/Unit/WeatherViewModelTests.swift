import XCTest
@testable import WeatherNow

final class WeatherViewModelTests: XCTestCase {
    struct StubRepo: WeatherRepository {
        let weather: Weather
        func currentWeather(for city: String) async throws -> Weather { weather }
    }

    func test_load_success_setsLoaded() async {
        let w = Weather(city: "GDL", tempC: 24, description: "Soleado")
        let vm = WeatherViewModel(
            fetch: DefaultFetchWeatherUseCase(repo: StubRepo(weather: w))
        )
        await vm.load(city: "GDL")
        switch vm.state {
        case .loaded(let got): XCTAssertEqual(got.city, "GDL")
        default: XCTFail("Expected loaded state")
        }
    }
}
