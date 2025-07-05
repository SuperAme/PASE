//
//  Episode.swift
//  PASE
//
//  Created by Américo MQ on 04/07/25.
//

import Foundation

struct Episode: Codable, Identifiable {
    let id: Int
    let name: String
    let episode: String
}
