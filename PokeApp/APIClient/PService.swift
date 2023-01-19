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
    
    enum PServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
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
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(PServiceError.failedToCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data, error == nil else  {
                completion(.failure(error ?? PServiceError.failedToGetData))
                return
            }
            
            //Decode response
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        ///Task should end here
        task.resume()
    }
    
    //MARK: - Private
    
    private func request(from pRequest: PRequest) -> URLRequest? {
        guard let url = pRequest.url else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = pRequest.httpMethod
        
        return request
    }
}
