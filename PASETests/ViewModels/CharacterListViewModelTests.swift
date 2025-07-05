//
//  CharacterListViewModelTests.swift
//  PASE
//
//  Created by Américo MQ on 04/07/25.
//

import XCTest
@testable import PASE

final class CharacterListViewModelTests: XCTestCase {
    class MockCharacterRepository: CharacterRepository {
        var shouldThrowError = false

        func fetchCharacters() async throws -> [Character] {
            if shouldThrowError {
                throw NSError(domain: "Test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error"])
            }

            return [
                Character(
                    id: 1,
                    name: "Rick Sanchez",
                    status: "Alive",
                    species: "Human",
                    type: "",
                    gender: "Male",
                    image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                    url: "",
                    created: "",
                    origin: Location(name: "Earth", url: ""),
                    location: Location(name: "Earth", url: ""),
                    episode: []
                )
            ]
        }
    }
    
    @MainActor
    func testLoadCharactersSuccess() async {
        let repository = MockCharacterRepository()
        let useCase = GetCharactersUseCase(repository: repository)
        let viewModel = await CharacterListViewModel(getCharactersUseCase: useCase)

        await viewModel.loadCharacters()

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.characters.count, 1)
        XCTAssertNil(viewModel.errorMessage)
    }

    @MainActor
    func testLoadCharactersFailure() async {
        let repository = MockCharacterRepository()
        repository.shouldThrowError = true
        let useCase = GetCharactersUseCase(repository: repository)
        let viewModel = CharacterListViewModel(getCharactersUseCase: useCase)

        await viewModel.loadCharacters()

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.characters.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
    }
}

