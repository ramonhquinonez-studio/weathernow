//
//  APIClient.swift
//  WeatherNow
//
//  Created by Ramón H. Quiñonez on 21/11/25.
//

import Foundation

protocol APIClient {
    func get<T: Decodable>(_ type: T.Type, from request: URLRequest) async throws -> T
}

struct URLSessionAPIClient: APIClient {
    func get<T: Decodable>(_ type: T.Type, from request: URLRequest) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse,
              200..<300 ~= http.statusCode else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            if let json = String(data: data, encoding: .utf8) {
                print("❌ Decode error for \(T.self): \(error)")
                print("🔍 JSON recibido:\n\(json)")
            }
            throw error
        }
    }
}
