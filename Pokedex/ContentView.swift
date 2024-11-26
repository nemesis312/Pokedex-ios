//
//  ContentView.swift
//  Pokedex
//
//  Created by Lesther Ruiz on 11/26/24.
//

import SwiftUI

struct ContentView: View {
    @State private var pokemonList: [ApiNetwork.Pokemon] = []
    @State private var filteredPokemonList: [ApiNetwork.Pokemon] = []
    @State private var searchText: String = ""
    @State private var isLoading = true
    @State private var errorMessage: String? = nil

    var body: some View {
        NavigationView {
            VStack {
                // Campo de texto para buscar
                TextField("Buscar Pokémon", text: $searchText)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)

                if isLoading {
                    ProgressView("Cargando Pokémon...")
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    // Lista de Pokémon (Filtrada)
                    List(filteredPokemonList, id: \.name) { pokemon in
                        NavigationLink(destination: PokemonDetailView(pokemonName: pokemon.name)) {
                            Text(pokemon.name.capitalized)
                        }
                    }
                }
            }
            .navigationTitle("Pokémon List")
            .onChange(of: searchText) {
                filterPokemonList()
            }
        }
        .task {
            await loadPokemon()
        }
    }

    // Función para cargar los datos
    private func loadPokemon() async {
        do {
            let api = ApiNetwork()
            let wrapper = try await api.getPokemonList()
            pokemonList = wrapper.results
            filteredPokemonList = pokemonList // Inicialmente, la lista completa
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    // Función para filtrar la lista de Pokémon
    private func filterPokemonList() {
        if searchText.isEmpty {
            filteredPokemonList = pokemonList // Si el texto está vacío, muestra todo
        } else {
            filteredPokemonList = pokemonList.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}


#Preview {
    ContentView()
}
