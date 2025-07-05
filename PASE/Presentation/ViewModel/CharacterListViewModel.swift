//
//  CharacterListViewModel.swift
//  PASE
//
//  Created by Américo MQ on 04/07/25.
//

import Foundation

@MainActor
class CharacterListViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let getCharactersUseCase: GetCharactersUseCase
    private var currentPage = 1
    private var isLastPage = false

    init(getCharactersUseCase: GetCharactersUseCase) {
        self.getCharactersUseCase = getCharactersUseCase
    }

    func loadInitialCharacters() async {
        characters = []
        currentPage = 1
        isLastPage = false
        await loadCharacters()
    }

    func loadMoreCharactersIfNeeded(currentCharacter character: Character) async {
        guard !isLoading,
              !isLastPage,
              character.id == characters.last?.id else { return }

        currentPage += 1
        await loadCharacters()
    }

    private func loadCharacters() async {
        isLoading = true
        errorMessage = nil

        do {
            let newCharacters = try await getCharactersUseCase.execute(page: currentPage)

            if newCharacters.isEmpty {
                isLastPage = true
            }

            characters += newCharacters
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

