//
//  FavoritesViewModel.swift
//  PASE
//
//  Created by Américo MQ on 05/07/25.
//
import SwiftUI

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favorites: [Character] = []
    private let favoritesUseCase: FavoritesUseCase
    private let getEpisodesUseCase: GetEpisodesUseCase

    init(favoritesUseCase: FavoritesUseCase, getEpisodesUseCase: GetEpisodesUseCase) {
        self.favoritesUseCase = favoritesUseCase
        self.getEpisodesUseCase = getEpisodesUseCase
    }

    func loadFavorites() async {
        do {
            let favoriteCharacters = try await favoritesUseCase.fetchAllFavorites()
            self.favorites = favoriteCharacters
        } catch {
            print("Error cargando favoritos: \(error)")
            self.favorites = []
        }
    }
}
