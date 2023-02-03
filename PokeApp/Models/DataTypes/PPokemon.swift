//
//  PPokemon.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/13/23.
//

import Foundation

struct PPokemon: Codable {
    
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
    
    var heightString: String {
        let cm = String(format: "%.2f", Double(height) * 2.54)
        return "\(height)\" (\(cm) cm)"
    }
    
    var weightString: String {
        let kg = String(format: "%.2f", Double(weight) / 2.204)
        return "\(weight) lbs (\(kg) kg)"
    }
    
    var abilitiesString: String {
        let abilitiesNames: [String] = abilities.compactMap({
            return $0.ability.name.capitalized
        })
        return abilitiesNames.joined(separator: ", ")
    }
    
    var typeString: String {
        let typeNames: [String] = types.compactMap({
            return $0.type.name.capitalized
        })
        return typeNames.joined(separator: ", ")
    }
    
}
