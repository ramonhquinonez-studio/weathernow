//
//  CacheStore.swift
//  WeatherNow
//
//  Created by Ramón H. Quiñonez on 21/11/25.
//

import Foundation

actor CacheStore<T: Codable> {
    private let url: URL
    init(filename: String = "cache.json") {
        self.url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
    }
    func save(_ value: T) throws {
        let data = try JSONEncoder().encode(value)
        try data.write(to: url)
    }
    func load() throws -> T {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
