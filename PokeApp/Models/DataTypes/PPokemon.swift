//
//  PPokemon.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/13/23.
//

import Foundation

struct PPokemon: Codable, PPokemonDataRender {
    
    let id: Int
    let name: String
    let base_experience: Int
    let height: Int
    let order: Int
    let weight: Int
    let abilities: [PPokemonAbility]
    let stats: [PPokemonStats]
    let types: [PPokemonTypes]
    
    
    /// Computed Property to get base image
    var baseImage: String {
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
    }
    
    /// Computed Property to get svg image
    var proImage: String {
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/\(id).svg"
    }
}
