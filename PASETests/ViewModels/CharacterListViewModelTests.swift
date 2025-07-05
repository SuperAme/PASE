//
//  CharacterListViewModelTests.swift
//  PASE
//
//  Created by Américo MQ on 04/07/25.
//

import XCTest
@testable import PASE

final class CharacterListViewModelTests: XCTestCase {

    class MockGetCharactersUseCase: GetCharactersUseCaseProtocol {
        var charactersToReturn: [Character] = []
        var shouldThrowError = false

        func execute(
            page: Int = 1,
            name: String = "",
            status: String = "",
            species: String = ""
        ) async throws -> [Character] {
            if shouldThrowError {
                throw NSError(domain: "TestError", code: 1, userInfo: nil)
            }
            return charactersToReturn
        }
    }

    var viewModel: CharacterListViewModel!
    var mockUseCase: MockGetCharactersUseCase!

    @MainActor
    override func setUp() {
        super.setUp()
        mockUseCase = MockGetCharactersUseCase()
        viewModel = CharacterListViewModel(getCharactersUseCase: mockUseCase)
    }

    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        super.tearDown()
    }

    @MainActor
    func testLoadInitialCharactersSuccess() async {
        // Given
        let character = Character(
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
        mockUseCase.charactersToReturn = [character]

        // When
        await viewModel.loadInitialCharacters()

        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.characters.count, 1)
        XCTAssertEqual(viewModel.characters.first?.name, "Rick Sanchez")
        XCTAssertNil(viewModel.errorMessage)
    }

    @MainActor
    func testApplySearchFiltersCharacters() async {
        // Given
        let character1 = Character(
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
        let character2 = Character(
            id: 2,
            name: "Morty Smith",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
            url: "",
            created: "",
            origin: Location(name: "Earth", url: ""),
            location: Location(name: "Earth", url: ""),
            episode: []
        )

        mockUseCase.charactersToReturn = [character1, character2]

        // Simulate user typing "alive" to filter by status
        viewModel.searchText = "alive"

        // When
        await viewModel.applySearch()

        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.characters.count, 2)
        XCTAssertNil(viewModel.errorMessage)
    }

    @MainActor
    func testLoadCharactersFailure() async {
        // Given
        mockUseCase.shouldThrowError = true

        // When
        await viewModel.loadInitialCharacters()

        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.characters.count, 0)
        XCTAssertNotNil(viewModel.errorMessage)
    }
}
