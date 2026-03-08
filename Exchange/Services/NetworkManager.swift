//
//  NetworkManager.swift
//  Exchange
//
//  Created by Imron Mirzarasulov on 03/03/26.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkManager {
    static let shared = NetworkManager()
        
    private init() {}
    
    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    // Фетчинг моковых данных из файла
    func fetchMockExchangeRate() throws -> [ExchangeRate] {
        guard let path = Bundle.main.path(forResource: "mock_exchange_rate", ofType: "json") else {
            throw NetworkError.noData
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        return try JSONDecoder().decode([ExchangeRate].self, from: data)
    }
}
