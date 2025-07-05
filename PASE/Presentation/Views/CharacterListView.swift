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
            VStack(spacing: 0) {
                SearchBarView(viewModel: viewModel)

                Group {
                    if viewModel.isLoading && viewModel.characters.isEmpty {
                        ProgressView("Cargando personajes...")
                            .frame(maxHeight: .infinity)
                    } else if let error = viewModel.errorMessage {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        List(viewModel.characters) { character in
                            HStack(spacing: 16) {
                                AsyncImage(url: URL(string: character.image)) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .shadow(radius: 3)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(character.name)
                                        .font(.headline)

                                    Text(character.species)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)

                                    Text("Estado: \(character.status)")
                                        .font(.caption)
                                        .foregroundColor(character.status.lowercased() == "alive" ? .green : .red)
                                }
                            }
                            .padding(.vertical, 4)
                            .task {
                                await viewModel.loadMoreCharactersIfNeeded(currentCharacter: character)
                            }
                        }
                        .listStyle(.plain)
                        .refreshable {
                            await viewModel.loadInitialCharacters()
                        }
                    }
                }
            }
            .navigationTitle("Rick & Morty")
        }
        .task {
            await viewModel.loadInitialCharacters()
        }
    }
}

