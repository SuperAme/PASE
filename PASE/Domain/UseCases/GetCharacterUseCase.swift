//
//  GetCharacterUseCase.swift
//  PASE
//
//  Created by Américo MQ on 04/07/25.
//

import Foundation

struct GetCharactersUseCase {
    let repository: CharacterRepository

    func execute(page: Int = 1) async throws -> [Character] {
        try await repository.fetchCharacters(page: page)
    }
}
