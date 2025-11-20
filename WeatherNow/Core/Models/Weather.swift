import Foundation

public struct Weather: Decodable, Identifiable, Equatable {
    public var id = UUID()
    public let city: String
    public let tempC: Double
    public let description: String

    public init(city: String, tempC: Double, description: String) {
        self.city = city
        self.tempC = tempC
        self.description = description
    }
}
