//
//  Character.swift
//  PASE
//
//  Created by Américo MQ on 04/07/25.
//

import Foundation

struct Character: Identifiable, Codable {
    let id: Int
    let name, status, species, type, gender, image, url, created: String
    let origin, location: Location
    let episode: [String]
}

// MARK: - Location
struct Location: Codable {
    let name: String
    let url: String
}
