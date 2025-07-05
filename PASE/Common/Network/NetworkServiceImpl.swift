//
//  NetworkServiceImpl.swift
//  PASE
//
//  Created by Américo MQ on 04/07/25.
//

import Foundation

protocol NetworkService {
    func request<T: Decodable>(_ endpoint: URL) async throws -> T
}

final class NetworkServiceImpl: NetworkService {
    func request<T: Decodable>(_ endpoint: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: endpoint)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw NetworkError.decodingError
        }
    }
}

