import Foundation

enum Endpoints {
    static let baseURL = URL(string: "https://api.example.com")! // TODO: reemplazar
    static func weather() -> URLRequest {
        var req = URLRequest(url: baseURL.appending(path: "/weather"))
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return req
    }
}
