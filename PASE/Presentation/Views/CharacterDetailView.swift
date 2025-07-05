//
//  CharacterDetailView.swift
//  PASE
//
//  Created by Américo MQ on 04/07/25.
//

import SwiftUI

struct CharacterDetailView: View {
    @StateObject private var viewModel: CharacterDetailViewModel

    init(character: Character) {
        let repository = CharacterRepositoryImpl()
        let getEpisodesUseCase = GetEpisodesUseCase(repository: repository)
        let favoritesRepository = FavoritesRepositoryCoreData()
        let favoritesUseCase = FavoritesUseCase(repository: favoritesRepository)
        _viewModel = StateObject(wrappedValue: CharacterDetailViewModel(
            character: character,
            getEpisodesUseCase: getEpisodesUseCase,
            favoritesUseCase: favoritesUseCase
        ))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                AsyncImage(url: URL(string: viewModel.characterInfo.image)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity, maxHeight: 300)

                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.characterInfo.name)
                        .font(.title)
                        .fontWeight(.bold)

                    Text("Género: \(viewModel.characterInfo.gender)")
                    Text("Especie: \(viewModel.characterInfo.species)")
                    Text("Estado: \(viewModel.characterInfo.status)")
                    Text("Ubicación: \(viewModel.characterInfo.location.name)")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

                Button(action: {
                    viewModel.toggleFavorite()
                }) {
                    Label(
                        viewModel.isFavorite ? "Favorito" : "Marcar como favorito",
                        systemImage: viewModel.isFavorite ? "heart.fill" : "heart"
                    )
                    .foregroundColor(.red)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }

                Divider()

                if viewModel.isLoading {
                    ProgressView("Cargando episodios...")
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Episodios")
                            .font(.headline)

                        ForEach(viewModel.episodes) { episode in
                            VStack(alignment: .leading) {
                                Text(episode.name)
                                    .fontWeight(.semibold)
                                Text("Episodio: \(episode.episode)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(viewModel.characterInfo.name)
        .onAppear {
            viewModel.onAppear()
        }
    }
}

