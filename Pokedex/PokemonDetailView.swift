//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Lesther Ruiz on 11/26/24.
//

import SwiftUI

struct PokemonDetailView: View {
    let pokemonName: String
    @State private var pokemonDetails: PokemonDetails?
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Cargando detalles de \(pokemonName.capitalized)...")
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else if let details = pokemonDetails {
                VStack {
                    // Card de Pokémon
                    VStack {
                        AsyncImage(url: URL(string: details.sprites.front_default)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                        } placeholder: {
                            ProgressView()
                        }
                        .padding()

                        Text(details.name.capitalized)
                            .font(.title)
                            .bold()

                        Text("Altura: \(details.height)")
                        Text("Peso: \(details.weight)")
                    }
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
                .padding()
            }
        }
        .navigationTitle(pokemonName.capitalized)
        .task {
            await loadPokemonDetails()
        }
    }

    private func loadPokemonDetails() async {
        do {
            let api = ApiNetwork()
            let details = try await api.getPokemonDetails(for: pokemonName)
            pokemonDetails = details
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}
