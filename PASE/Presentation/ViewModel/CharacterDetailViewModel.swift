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

    init(character: Character, getEpisodesUseCase: GetEpisodesUseCase) {
        self.character = character
        self.getEpisodesUseCase = getEpisodesUseCase

        loadFavoriteStatus()
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
        var favorites = UserDefaults.standard.array(forKey: "favorites") as? [Int] ?? []
        if isFavorite {
            favorites.removeAll { $0 == character.id }
        } else {
            favorites.append(character.id)
        }
        UserDefaults.standard.set(favorites, forKey: "favorites")
        isFavorite.toggle()
    }

    private func loadFavoriteStatus() {
            let favorites = UserDefaults.standard.array(forKey: "favorites") as? [Int] ?? []
            isFavorite = favorites.contains(character.id)
        }
}
