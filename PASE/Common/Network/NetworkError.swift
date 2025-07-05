//
//  NetworkError.swift
//  PASE
//
//  Created by Américo MQ on 04/07/25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidResponse
    case decodingError

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "La respuesta del servidor no es válida."
        case .decodingError:
            return "Error al decodificar los datos."
        }
    }
}
