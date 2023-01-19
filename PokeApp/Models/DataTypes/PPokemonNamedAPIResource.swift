//
//  PPokemonNamedAPIResource.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/17/23.
//

import Foundation

struct PPokemonNamedAPIResource: Codable {
    let name: String
    let url: String
    
    /// Computed Property to get base image
    var baseImage: String {
        if !url.isEmpty {
            let id = url.components(separatedBy: "/").dropLast().last!
            return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
        }
        return ""
    }
}
