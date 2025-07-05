//
//  MockGetCharactersUseCase.swift
//  PASETests
//
//  Created by Américo MQ on 04/07/25.
//

import Foundation
@testable import PASE

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
