//
//  CharacterDetailView.swift
//  PASE
//
//  Created by Américo MQ on 04/07/25.
//

import SwiftUI
import MapKit

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
            VStack(spacing: 24) {
                AsyncImage(url: URL(string: viewModel.characterInfo.image)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300)
                        .clipped()
                        .cornerRadius(16)
                        .shadow(radius: 8)
                } placeholder: {
                    ProgressView()
                        .frame(height: 300)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text(viewModel.characterInfo.name)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.primary)

                    HStack(spacing: 16) {
                        Label(viewModel.characterInfo.gender, systemImage: "person.fill")
                        Label(viewModel.characterInfo.species, systemImage: "leaf.fill")
                        Label(viewModel.characterInfo.status, systemImage: "heart.fill")
                            .foregroundColor(viewModel.characterInfo.status.lowercased() == "alive" ? .green : .red)
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.blue)
                        Text(viewModel.characterInfo.location.name)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

                HStack(spacing: 20) {
                    Button(action: {
                        viewModel.toggleFavorite()
                    }) {
                        Label(
                            viewModel.isFavorite ? "Favorito" : "Marcar como favorito",
                            systemImage: viewModel.isFavorite ? "heart.fill" : "heart"
                        )
                        .font(.headline)
                        .foregroundColor(viewModel.isFavorite ? .white : .red)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.isFavorite ? Color.red : Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.red, lineWidth: 2)
                        )
                        .shadow(radius: 4)
                    }

                    NavigationLink {
                        let randomCoordinate = CLLocationCoordinate2D(
                            latitude: Double.random(in: -60...70),
                            longitude: Double.random(in: -160...160)
                        )
                        CharacterMapView(characterName: viewModel.characterInfo.name, coordinate: randomCoordinate)
                    } label: {
                        Label("Ver en mapa", systemImage: "map")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)

                Divider()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Episodios")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)

                    if viewModel.isLoading {
                        ProgressView("Cargando episodios...")
                            .frame(maxWidth: .infinity)
                    } else {
                        ForEach(viewModel.episodes) { episode in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(episode.name)
                                    .fontWeight(.medium)
                                Text("Episodio: \(episode.episode)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(viewModel.characterInfo.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.onAppear()
        }
    }
}

