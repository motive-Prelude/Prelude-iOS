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
    
    private(set) var container: ModelContainer
    private var modelContext: ModelContext
    
    private init() {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: false, allowsSave: true, cloudKitDatabase: .none)
            let schema = Schema([UserInfo.self, HealthInfo.self])
            container = try ModelContainer(for: schema, configurations: config)
        } catch { print(error)
            fatalError("SHUT DOWN")
        }
        
        modelContext = ModelContext(container)
    }
    
    private func save() {
        do { try modelContext.save() }
        catch { print(error) }
    }
    
    func saveData<T: PersistentModel>(_ data: T) {
        print(#function)
        modelContext.insert(data)
        save()
    }
    
    func fetchLatest<T: PersistentModel>(data: T.Type) throws -> T? {
        do {
            let infos = try modelContext.fetch(FetchDescriptor<T>())
            return infos.last
        } catch {
            throw error
        }
    }
    
    func delete<T: PersistentModel>(data: T) {
        modelContext.delete(data)
        save()
    }
    
    func removeAll() throws {
        try deleteAll(of: UserInfo.self)
        try deleteAll(of: HealthInfo.self)
    }
    
    private func deleteAll<T: PersistentModel>(of type: T.Type) throws {
        let datas = try modelContext.fetch(FetchDescriptor<T>())
        
        for data in datas {
            modelContext.delete(data)
        }
        try modelContext.save()
    }
}
