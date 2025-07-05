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

    @Published var searchText: String = ""

    private let getCharactersUseCase: GetCharactersUseCaseProtocol
    private var currentPage = 1
    private var isLastPage = false
    private var isSearching = false

    init(getCharactersUseCase: GetCharactersUseCaseProtocol) {
        self.getCharactersUseCase = getCharactersUseCase
    }

    func loadInitialCharacters() async {
        characters = []
        currentPage = 1
        isLastPage = false
        await loadCharacters()
    }

    func applySearch() async {
        isSearching = true
        characters = []
        currentPage = 1
        isLastPage = false
        await loadCharacters()
    }

    func loadMoreCharactersIfNeeded(currentCharacter character: Character) async {
        guard !isLoading,
              !isLastPage,
              !isSearching,
              character.id == characters.last?.id else { return }

        currentPage += 1
        await loadCharacters()
    }

    private func loadCharacters() async {
        isLoading = true
        errorMessage = nil

        // Parse searchText into filters
        let (nameFilter, statusFilter, speciesFilter) = parseFilters(from: searchText)

        do {
            let result = try await getCharactersUseCase.execute(
                page: currentPage,
                name: nameFilter,
                status: statusFilter,
                species: speciesFilter
            )

            if result.isEmpty {
                isLastPage = true
            }

            characters += result
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
        isSearching = false
    }

    private func parseFilters(from text: String) -> (String, String, String) {
        let lowercased = text.lowercased()

        // Detect if text contains status keywords
        let statusKeywords = ["alive", "dead", "unknown"]
        let status = statusKeywords.first(where: lowercased.contains) ?? ""

        // Remove status keywords from text
        var filteredText = lowercased
        if !status.isEmpty {
            filteredText = filteredText.replacingOccurrences(of: status, with: "").trimmingCharacters(in: .whitespaces)
        }

        // Asumimos que el resto puede estar en nombre o especie
        let name = filteredText
        let species = filteredText

        return (name, status, species)
    }
}
