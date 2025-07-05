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

    func fetchCharacters(page: Int = 1) async throws -> [Character] {
        let url = URL(string: "https://rickandmortyapi.com/api/character?page=\(page)")!
        let response: CharacterListResponse = try await networkService.request(url)
        return response.results.map { $0.toDomain() }
    }
}

// Respuesta principal de la API
struct CharacterListResponse: Decodable {
    let results: [CharacterDTO]
}
