//
//  FavoritesView.swift
//  PASE
//
//  Created by Américo MQ on 05/07/25.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel: FavoritesViewModel

    init(favoritesUseCase: FavoritesUseCase, getEpisodesUseCase: GetEpisodesUseCase) {
        _viewModel = StateObject(wrappedValue: FavoritesViewModel(favoritesUseCase: favoritesUseCase, getEpisodesUseCase: getEpisodesUseCase))
    }

    var body: some View {
        List {
            if viewModel.favorites.isEmpty {
                Text("No hay personajes favoritos.")
                    .foregroundColor(.secondary)
            } else {
                ForEach(viewModel.favorites) { character in
                    NavigationLink(destination: CharacterDetailView(character: character)) {
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

                            VStack(alignment: .leading) {
                                Text(character.name)
                                    .font(.headline)
                                Text(character.species)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Favoritos")
        .task {
            await viewModel.loadFavorites()
        }
    }
}
