//
//  CharacterRepository.swift
//  PASE
//
//  Created by Américo MQ on 04/07/25.
//

import Foundation

protocol CharacterRepository {
    func fetchCharacters(page: Int) async throws -> [Character]
}
