//
//  PPokemonCollectionViewCellViewModel.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/18/23.
//

import Foundation

final class PPokemonCollectionViewCellViewModel: Hashable, Equatable {
    
    public let pokemonName: String
    private let pokemonImageUrl: URL?
    
    init(
        pokemonName: String,
        pokemonImageUrl: URL?
    ) {
        self.pokemonName = pokemonName
        self.pokemonImageUrl = pokemonImageUrl
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = pokemonImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        PImageLoader.shared.downloadImage(url, completion: completion)
    }
    
    //MARK: - Hashable
    static func == (lhs: PPokemonCollectionViewCellViewModel, rhs: PPokemonCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(pokemonName)
        hasher.combine(pokemonImageUrl)
    }
    
}
