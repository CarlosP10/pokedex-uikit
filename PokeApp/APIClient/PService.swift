//
//  PService.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/17/23.
//

import Foundation

/// Primary API service object to get Pokemon data
final class PService {
    /// Shared singleton instance
    static let shared = PService()
    
    /// Privatized constructor
    private init() {}
    
    /// Send Pokemon API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - type: Type of object we expect to get back
    ///   - completion: Callback with data or error
    public func execute<T: Codable>(
        _ request: PRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ){
        
    }
}
