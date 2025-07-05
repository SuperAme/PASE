//
//  GetCharacterUseCase.swift
//  PASE
//
//  Created by Américo MQ on 04/07/25.
//

import Foundation

protocol GetCharactersUseCaseProtocol {
    func execute(
        page: Int,
        name: String,
        status: String,
        species: String
    ) async throws -> [Character]
}


struct GetCharactersUseCase: GetCharactersUseCaseProtocol {
    let repository: CharacterRepository

    func execute(
        page: Int = 1,
        name: String = "",
        status: String = "",
        species: String = ""
    ) async throws -> [Character] {
        try await repository.fetchCharacters(
            page: page,
            name: name,
            status: status,
            species: species
        )
    }
}
