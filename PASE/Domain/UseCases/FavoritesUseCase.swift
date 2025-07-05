//
//  FavoritesUseCase.swift
//  PASE
//
//  Created by Américo MQ on 05/07/25.
//

import Foundation

class FavoritesUseCase {
    private let repository: FavoritesRepository

    init(repository: FavoritesRepository) {
        self.repository = repository
    }

    func isFavorite(characterId: Int) -> Bool {
        repository.isFavorite(characterId: characterId)
    }

    func addFavorite(character: Character) async throws {
        try await repository.addFavorite(character: character)
    }

    func removeFavorite(characterId: Int) async throws {
        try await repository.removeFavorite(characterId: characterId)
    }
}
