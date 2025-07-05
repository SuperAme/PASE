//
//  CharacterRepositoryImpl.swift
//  PASE
//
//  Created by Américo MQ on 04/07/25.
//

import Foundation

class CharacterRepositoryImpl: CharacterRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkServiceImpl()) {
        self.networkService = networkService
    }

    func fetchCharacters(
        page: Int = 1,
        name: String = "",
        status: String = "",
        species: String = ""
    ) async throws -> [Character] {
        var urlComponents = URLComponents(string: "https://rickandmortyapi.com/api/character")!
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)")
        ]

        if !name.isEmpty {
            urlComponents.queryItems?.append(URLQueryItem(name: "name", value: name))
        }

        if !status.isEmpty {
            urlComponents.queryItems?.append(URLQueryItem(name: "status", value: status.lowercased()))
        }

        if !species.isEmpty {
            urlComponents.queryItems?.append(URLQueryItem(name: "species", value: species))
        }

        guard let url = urlComponents.url else {
            throw NetworkError.invalidResponse
        }

        let response: CharacterListResponse = try await networkService.request(url)
        return response.results.map { $0.toDomain() }
    }
}

// Respuesta principal de la API
struct CharacterListResponse: Decodable {
    let results: [CharacterDTO]
}
