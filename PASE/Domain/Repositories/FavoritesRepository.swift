//
//  FavoritesRepository.swift
//  PASE
//
//  Created by Américo MQ on 05/07/25.
//

protocol FavoritesRepository {
    func isFavorite(characterId: Int) -> Bool
    func addFavorite(character: Character) async throws
    func removeFavorite(characterId: Int) async throws
}
