//
//  SwiftDataManager.swift
//  Junction
//
//  Created by 송지혁 on 10/11/24.
//

import Foundation
import SwiftData

class SwiftDataSource {
    static let shared = SwiftDataSource()
    
    private(set) var container: ModelContainer?
    private var modelContext: ModelContext?
    
    private init() {
        do {
            self.container = try setupContainer()
            if let container { modelContext = ModelContext(container) }
        } catch {
            self.container = nil
            self.modelContext = nil
        }
    }
    
    private func setupContainer() throws(DataSourceError) -> ModelContainer {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: false, allowsSave: true, cloudKitDatabase: .none)
            let schema = Schema([UserInfo.self, HealthInfo.self])
            return try ModelContainer(for: schema, configurations: config)
        } catch let error as SwiftDataError { throw parseError(error) }
        catch { throw .unknown }
    }
    
    private func save() throws(DataSourceError) {
        guard let modelContext else { throw .unknown }
        do { try modelContext.save() }
        catch let error as SwiftDataError { throw parseError(error) }
        catch { throw .unknown }
    }
    
    func saveData<T: PersistentModel>(_ data: T) throws(DataSourceError) {
        guard let modelContext else { throw .unknown }
        modelContext.insert(data)
        try save()
    }
    
    func fetchLatest<T: PersistentModel>(data: T.Type) throws(DataSourceError) -> T {
        guard let modelContext else { throw .unknown }
        
        do {
            let infos = try modelContext.fetch(FetchDescriptor<T>())
            guard let last = infos.last else { throw DataSourceError.notFound }
            return last
        } catch let error as DataSourceError {
            throw error
        } catch let error as SwiftDataError {
            throw parseError(error)
        } catch { throw .unknown }
    }
    
    func delete<T: PersistentModel>(data: T) throws(DataSourceError) {
        guard let modelContext else { throw .unknown }
        modelContext.delete(data)
        try save()
    }
    
    func removeAll<T: PersistentModel>(type data: T.Type) throws(DataSourceError) {
        do {
            try deleteAll(of: data)
        } catch { throw error }
    }
    
    private func deleteAll<T: PersistentModel>(of type: T.Type) throws(DataSourceError) {
        guard let modelContext else { throw .unknown }
        
        do {
            let datas = try modelContext.fetch(FetchDescriptor<T>())
            for data in datas { modelContext.delete(data) }
            try modelContext.save()
        } catch let error as SwiftDataError { throw parseError(error) }
        catch { throw .unknown }
    }
    
    private func parseError(_ error: SwiftDataError) -> DataSourceError {
        switch error {
            case .unknownSchema: return .notFound
            case .missingModelContext: return .notFound
            default: return .unknown
        }
    }
}
