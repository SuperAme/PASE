//
//  CharacterListView.swift
//  PASE
//
//  Created by Américo MQ on 04/07/25.
//

import SwiftUI

struct CharacterListView: View {
    @StateObject var viewModel: CharacterListViewModel
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading && viewModel.characters.isEmpty {
                    ProgressView("Cargando personajes...")
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                } else {
                    List(viewModel.characters) { character in
                        HStack {
                            AsyncImage(url: URL(string: character.image)) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            
                            VStack(alignment: .leading) {
                                Text(character.name)
                                    .font(.headline)
                                Text(character.species)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Estado: \(character.status)")
                                    .font(.caption)
                                    .foregroundColor(character.status.lowercased() == "alive" ? .green : .red)
                            }
                        }
                        .task {
                            await viewModel.loadMoreCharactersIfNeeded(currentCharacter: character)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Rick & Morty")
        }
        .task {
            await viewModel.loadInitialCharacters()
        }
    }
}
