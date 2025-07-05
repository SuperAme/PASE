//
//  CharacterDTO.swift
//  PASE
//
//  Created by Américo MQ on 04/07/25.
//

import Foundation

struct CharacterDTO: Decodable {
    let id: Int
    let name, status, species, type, gender, image, url, created: String
    let origin, location: LocationDTO
    let episode: [String]
}

struct LocationDTO: Decodable {
    let name: String
    let url: String
}

extension CharacterDTO {
    func toDomain() -> Character {
        return Character(
            id: id,
            name: name,
            status: status,
            species: species,
            type: type,
            gender: gender,
            image: image,
            url: url,
            created: created,
            origin: Location(name: origin.name, url: origin.url),
            location: Location(name: location.name, url: location.url),
            episode: episode
        )
    }
}

