//
//  PFirestoreRequest.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/28/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

/// Primary API service object to get,save, delete pokemon data from firabse
final class PFirestoreService {
    /// Shared singleton instance
    static let shared = PFirestoreService()
    
    /// Privatized constructos
    private init() {}
    
    //Instancia de conexion a la base de datos
    private let db = Firestore.firestore()
    
    enum PFirestoreServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
        case failedToDeleteData
        case failedToSaveData
    }
    
    public func getData(
        _ collection: PFirestoreCollections,
        _ document: String,
        completion: @escaping (DocumentSnapshot?, Error?) -> Void
    ) {
        db.collection(collection.rawValue).document(document).getDocument(completion: completion)
    }
    
    public func getDocs(
        _ collection: PFirestoreCollections,
        completion: @escaping (QuerySnapshot?, Error?) -> Void
    ) {
        db.collection(collection.rawValue).getDocuments(completion: completion)
    }
    
    public func setData(
        _ collection: PFirestoreCollections,
        _ document: String,
        _ type: Codable
    ) {
        do {
            try db.collection(collection.rawValue).document(document).setData(from: type)
        } catch  {
            print("Failed to save data \(PFirestoreServiceError.failedToSaveData)")
        }
        
    }
    
    public func deleteData(
        _ collection: PFirestoreCollections,
        _ document: String
    ) {
        db.collection(collection.rawValue).document(document).delete()
    }
}

