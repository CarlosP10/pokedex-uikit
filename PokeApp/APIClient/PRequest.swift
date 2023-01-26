//
//  PRequest.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/17/23.
//

import Foundation

/// Object that represents a single API Call
final class PRequest {
    //Base url
    //Endpoint
    //Path components
    //Query parameters
    
    /// API Constants
    private struct Constants {
        static let baseUrl = "https://pokeapi.co/api/v2"
    }
    
    /// Desired endpoints
    private let endpoint: PEndpoint
    
    /// Path components for API, if any, is set to avoid pass the same path over and over
    private let pathComponents: [String]
    
    /// Query arguments for API, if any
    private let queryParameters: [URLQueryItem]
    
    /// Constructed url for the api request in string format
    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach({
                string += "/\($0)"
            })
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            
            string += argumentString
        }
        
        return string
    }
    
    /// Computed & constructed API url
    public var url: URL? {
        return URL(string: urlString)
    }
    
    /// Desired http method
    public let httpMethod = "GET"
    
    //MARK: - Public
    /// Construct Request
    /// - Parameters:
    ///   - endpoint: Target endpoint
    ///   - pathComponents: Collection of Path components
    ///   - queryParameters: Collection of query parameters
    public init(
        endpoint: PEndpoint,
        pathComponents: [String] = [],
        queryParameters: [URLQueryItem] = []
    ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    /// Attempt to create request
    /// - Parameter url: URL to parse
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl) {
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl+"/", with: "")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0]
                var pathComponents: [String] = []
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                
                if let pEndpoint = PEndpoint(rawValue: endpointString){
                    self.init(endpoint: pEndpoint ,pathComponents: pathComponents)
                    return
                }
            }
        } else if trimmed.contains("?"){
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemsString = components[1]
                //value=name&value=name
                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")
                    
                    return URLQueryItem(name: parts[0], value: parts[1])
                })
                if let pEndpoint = PEndpoint(rawValue: endpointString){
                    self.init(
                        endpoint: pEndpoint,
                        queryParameters: queryItems
                    )
                    return
                }
            }
        }
        
        return nil
    }
}

extension PRequest {
    static let listPokemonsRequest = PRequest(endpoint: .pokemon)
    static let pokemonRequest = PRequest(endpoint: .pokemon)
}
