//
//  GetEpisodesUseCase.swift
//  PASE
//
//  Created by Américo MQ on 04/07/25.
//

import Foundation

struct GetEpisodesUseCase {
    let repository: CharacterRepository

    func execute(ids: [Int]) async throws -> [Episode] {
        try await repository.fetchEpisodes(ids: ids)
    }
}
