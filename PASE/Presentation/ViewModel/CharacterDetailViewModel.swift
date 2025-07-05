//
//  CharacterDetailViewModel.swift
//  PASE
//
//  Created by Américo MQ on 04/07/25.
//

import Foundation

@MainActor
class CharacterDetailViewModel: ObservableObject {
    @Published var episodes: [Episode] = []
    @Published var isLoading = false
    @Published var isFavorite = false
    
    private let character: Character
    private let getEpisodesUseCase: GetEpisodesUseCase
    private let favoritesUseCase: FavoritesUseCase

    init(
        character: Character,
        getEpisodesUseCase: GetEpisodesUseCase,
        favoritesUseCase: FavoritesUseCase
    ) {
        self.character = character
        self.getEpisodesUseCase = getEpisodesUseCase
        self.favoritesUseCase = favoritesUseCase

        self.isFavorite = favoritesUseCase.isFavorite(characterId: character.id)
    }
    
    var characterInfo: Character {
        character
    }
    
    func onAppear() {
        Task {
            await loadEpisodes()
        }
    }
    
    private func loadEpisodes() async {
        isLoading = true
        do {
            let ids = character.episode.compactMap { URL(string: $0)?.lastPathComponent }.compactMap(Int.init)
            let fetched = try await getEpisodesUseCase.execute(ids: ids)
            episodes = fetched.sorted(by: { $0.id < $1.id })
        } catch {
            print("Error al cargar episodios: \(error)")
        }
        isLoading = false
    }
    
    func toggleFavorite() {
        Task {
            do {
                if isFavorite {
                    try await favoritesUseCase.removeFavorite(characterId: character.id)
                } else {
                    try await favoritesUseCase.addFavorite(character: character)
                }
                isFavorite.toggle()
            } catch {
                print("Error actualizando favorito: \(error)")
            }
        }
    }
}
