//
//  CharacterRepository.swift
//  PASE
//
//  Created by Américo MQ on 04/07/25.
//

import Foundation

protocol CharacterRepository {
    func fetchCharacters(
        page: Int,
        name: String,
        status: String,
        species: String
    ) async throws -> [Character]
    func fetchEpisodes(ids: [Int]) async throws -> [Episode]
}
