//
//  FirestoreDataSource.swift
//  Junction
//
//  Created by 송지혁 on 12/8/24.
//

import FirebaseFirestore
import Foundation

class FirestoreDataSource<Data: Codable & Identifiable & Equatable> where Data.ID == String {
    private let db = Firestore.firestore()
    
    func create(collection: String, data: Data) async throws {
        let document = db.collection(collection).document(data.id)
        
        do { try document.setData(from: data) }
        catch { throw error }
    }
    
    func fetch(collection: String, documentID: String) async -> Data? {
        let docRef = db.collection(collection).document(documentID)
        do {
            let result = try await docRef.getDocument(as: Data.self)
            return result
        } catch { print(error) }
        return nil
    }
    
    func update(collection: String, data: Data) async throws {
        let docRef = db.collection(collection).document(data.id)
        
        do {
            var dataWithLastModified = try Firestore.Encoder().encode(data)
            dataWithLastModified["lastModified"] = Date()
            try await docRef.setData(dataWithLastModified)
        } catch {
            print(error)
            throw error
        }

    }
    
    func update(collection: String, documentID: String, fields: [String: Any]) async throws {
        var updatedFields = fields
        updatedFields["lastModified"] = Date()
        let docRef = db.collection(collection).document(documentID)
        try await docRef.updateData(updatedFields)
    }
    
    func delete(collection: String, documentID: String) {
        let docRef = db.collection(collection).document(documentID)
        docRef.delete()
    }
}
