//
//  SearchBarView.swift
//  PASE
//
//  Created by Américo MQ on 04/07/25.
//

import SwiftUI

struct SearchBarView: View {
    @ObservedObject var viewModel: CharacterListViewModel

    var body: some View {
        HStack {
            TextField("Buscar personajes", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onSubmit {
                    Task {
                        await viewModel.applySearch()
                    }
                }

            Button("Buscar") {
                Task {
                    await viewModel.applySearch()
                }
            }
        }
        .padding()
    }
}
