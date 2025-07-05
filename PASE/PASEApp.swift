//
//  PASEApp.swift
//  PASE
//
//  Created by Américo MQ on 04/07/25.
//

import SwiftUI

@main
struct PASEApp: App {
    var body: some Scene {
        WindowGroup {
            let networkService = NetworkServiceImpl()
            let repository = CharacterRepositoryImpl(networkService: networkService)
            let useCase = GetCharactersUseCase(repository: repository)
            let viewModel = CharacterListViewModel(getCharactersUseCase: useCase)
            CharacterListView(viewModel: viewModel)
        }
    }
}

