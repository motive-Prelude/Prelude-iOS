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
    
    func create(collection: String, data: Data) async throws(DataSourceError) {
        let document = db.collection(collection).document(data.id)
        
        do { try document.setData(from: data) }
        catch let error as NSError {
            throw parseFirestoreError(error)
        } catch { throw .unknown }
        
    }
    
    func fetch(collection: String, documentID: String) async throws(DataSourceError) -> Data {
        let docRef = db.collection(collection).document(documentID)
        do {
            let result = try await docRef.getDocument(as: Data.self)
            return result
        } catch _ as DecodingError { throw .notFound }
        catch let error as NSError { throw parseFirestoreError(error) }
        catch { throw .unknown }
    }
    
    func update(collection: String, data: Data) async throws(DataSourceError) {
        let docRef = db.collection(collection).document(data.id)
        
        do {
            var dataWithLastModified = try Firestore.Encoder().encode(data)
            dataWithLastModified["lastModified"] = Date()
            try await docRef.updateData(dataWithLastModified)
        } catch let error as NSError {
            throw parseFirestoreError(error)
        } catch { throw .unknown }
    }
    
    func update(collection: String, documentID: String, fields: [String: Any]) async throws(DataSourceError) {
        var updatedFields = fields
        updatedFields["lastModified"] = Date()
        let docRef = db.collection(collection).document(documentID)
        
        do { try await docRef.updateData(updatedFields) }
        catch let error as NSError {
            throw parseFirestoreError(error)
        } catch { throw .unknown }
    }
    
    func delete(collection: String, documentID: String) async throws(DataSourceError) {
        let docRef = db.collection(collection).document(documentID)
        do { try await docRef.delete() }
        catch let error as NSError {
            throw parseFirestoreError(error)
        } catch { throw .unknown }
    }
    
    private func parseFirestoreError(_ error: NSError) -> DataSourceError {
        let error = FirestoreErrorCode(_nsError: error)
        
        switch error.code {
            case .deadlineExceeded: return .timeout
            case .unauthenticated: return .unauthenticated
            case .permissionDenied: return .permissionDenied
            case .notFound: return .notFound
            default: return .unknown
        }
    }
}
