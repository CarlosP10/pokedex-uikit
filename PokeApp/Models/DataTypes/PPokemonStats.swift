//
//  PPokemonStats.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/17/23.
//

import Foundation

struct PPokemonStats: Codable {
    let stat: PPokemonNamedAPIResource
    let effort: Int
    let base_stat: Int
}
