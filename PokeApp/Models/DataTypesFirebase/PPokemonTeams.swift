//
//  PPokemonTeams.swift
//  PokeApp
//
//  Created by Carlos Paredes on 2/8/23.
//

import Foundation

struct PPokemonTeams: Codable {
    let teamName: String
    let createdDate: Double?
    let updateDate: Double?
    let pokemons: [PPokemon]?
    
    init(
        teamName: String,
        createdDate: Double? = nil,
        updateDate: Double? = nil,
        pokemons: [PPokemon]? = nil
    ) {
        self.teamName = teamName
        self.createdDate = createdDate
        self.updateDate = updateDate
        self.pokemons = pokemons
    }
}
