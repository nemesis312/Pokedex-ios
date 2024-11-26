import Foundation

// MARK: - Detalles de Pokémon (Global)
struct PokemonDetails: Codable {
    let name: String
    let height: Int
    let weight: Int
    struct Sprites: Codable {
        let front_default: String
    }
    let sprites: Sprites
}

class ApiNetwork {
    struct Wrapper: Codable {
        let count: Int
        let next: String?
        let previous: String?
        let results: [Pokemon]
    }

    struct Pokemon: Codable {
        let name: String
        let url: String
    }

    func getPokemonList() async throws -> Wrapper {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?offset=0&limit=151")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Wrapper.self, from: data)
    }

    func getPokemonDetails(for name: String) async throws -> PokemonDetails {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(name)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(PokemonDetails.self, from: data)
    }
}
