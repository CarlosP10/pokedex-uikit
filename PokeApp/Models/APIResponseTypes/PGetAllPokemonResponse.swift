//
//  PGetAllPokemonResponse.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/18/23.
//

import Foundation

struct PGetAllPokemonResponse:Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PPokemonNamedAPIResource]
}
