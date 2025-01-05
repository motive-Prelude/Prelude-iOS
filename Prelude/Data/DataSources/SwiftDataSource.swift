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
        guard let modelContext else { return }
        do { try modelContext.save() }
        catch { print(error) }
    }
    
    func saveData<T: PersistentModel>(_ data: T) throws(DataSourceError) {
        guard let modelContext else { return }
        modelContext.insert(data)
        try save()
    }
    
    func fetchLatest<T: PersistentModel>(data: T.Type) throws -> T? {
        guard let modelContext else { return nil }
        do {
            let infos = try modelContext.fetch(FetchDescriptor<T>())
            return infos.last
        } catch {
            throw error
        }
    }
    
    func delete<T: PersistentModel>(data: T) throws(DataSourceError) {
        guard let modelContext else { return }
        modelContext.delete(data)
        try save()
    }
    
    func removeAll() throws(DataSourceError) {
        do {
            try deleteAll(of: UserInfo.self)
            try deleteAll(of: HealthInfo.self)
        } catch { throw error }
    }
    
    private func deleteAll<T: PersistentModel>(of type: T.Type) throws(DataSourceError) {
        guard let modelContext else { return }
        
        do {
            let datas = try modelContext.fetch(FetchDescriptor<T>())
            for data in datas { modelContext.delete(data) }
            try modelContext.save()
        } catch { throw .unknown }
    }
    
    private func parseError(_ error: SwiftDataError) -> DataSourceError {
        switch error {
            default: .unknown
        }
    }
}
