//
//  PEndpoint.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/17/23.
//

import Foundation

/// Represents unique API endpoint
@frozen enum PEndpoint: String {
    /// Endpoint to get pokemon info
    case pokemon //"pokemon"
    /// Endpoint to get stat info
    case stat
    /// Endpoint to get pokemonColor info
    case pokemonColor
    /// Endpoint to get type info
    case type
    /// Endpoint to get item info
    case item
    /// Endpoint to get location info
    case location
    /// Endpoint to get evolutionChain info
    case evolutionChain
}
