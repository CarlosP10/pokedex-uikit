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
    ///   - completion: Callback with data or error
    public func execute(_ request: PRequest, completion: @escaping () -> Void){
        
    }
}
