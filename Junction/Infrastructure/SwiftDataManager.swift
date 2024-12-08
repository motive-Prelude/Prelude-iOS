//
//  SwiftDataManager.swift
//  Junction
//
//  Created by 송지혁 on 10/11/24.
//

import Foundation
import SwiftData
import Combine

class SwiftDataManager {
    static let shared = SwiftDataManager()
    
    private(set) var container: ModelContainer
    private var modelContext: ModelContext
    
    private init() {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true, allowsSave: true, cloudKitDatabase: .none)
            let schema = Schema([UserInfo.self, HealthInfo.self])
            container = try ModelContainer(for: schema, configurations: config)
        } catch { fatalError("\(error.localizedDescription)") }
        
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
    
    func fetchLatest<T: PersistentModel>(data: T.Type) -> T? {
        do {
            let healthInfos = try modelContext.fetch(FetchDescriptor<T>())
            return healthInfos.last
        } catch { print(error) }
        
        return nil
    }
    
    func delete<T: PersistentModel>(data: T) {
        modelContext.delete(data)
        save()
    }
}
