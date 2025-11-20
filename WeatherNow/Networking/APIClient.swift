import Foundation

protocol APIClient {
    func get<T: Decodable>(_ request: URLRequest) async throws -> T
}

struct URLSessionAPIClient: APIClient {
    func get<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
