//
//  Store.swift
//  Junction
//
//  Created by 송지혁 on 10/9/24.
//

import Foundation
import StoreKit

class Store: ObservableObject {
    @Published private(set) var productInfo: [String: String]
    @Published private(set) var storeProducts: [Product] = []
    @Published private(set) var value = 0
    @Published var errorMessage = ""
    @Published var showAlert = false
    
    var updateListenerTask: Task<Void, Error>? = nil
    
    init() {
        productInfo = Store.loadProducts()
        updateListenerTask = listenForTransactions()
        
        Task {
            await self.requestProducts()
        }
    }
    
    static func loadProducts() -> [String: String] {
        guard let path = Bundle.main.path(forResource: "Products", ofType: "plist"),
              let plist = FileManager.default.contents(atPath: path),
              let data = try? PropertyListSerialization.propertyList(from: plist, options: [], format: nil) as? [String: String] else { return [:] }
        
        return data
    }
    
    @MainActor
    func requestProducts() async {
        do {
            let loadedProducts = try await Product.products(for: productInfo.values)
            storeProducts = loadedProducts
            print("Products loaded successfully: \(storeProducts)")
            
        } catch {
            print("Failed to load products: \(error)")
        }
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    await transaction.finish()
                } catch { self.handleError(StoreError.failedVerification) }
            }
        }
    }
    
    @MainActor
    func purchase(_ product: Product) async -> StoreKit.Transaction? {
        do {
            let result = try await product.purchase()
            
            switch result {
                case .success(let verification):
                    let transaction = try checkVerified(verification)
                    await transaction.finish()

                    return transaction
                    
                case .pending: print("pending")
                case .userCancelled: print("cancel")
                @unknown default:
                    fatalError()
            }
        } catch let error as StoreKitError {
            switch error {
                case .notEntitled:
                    handleError(StoreError.failedVerification)
                case .networkError:
                    handleError(StoreError.networkUnavailable)
                default: handleError(StoreError.unknownError)
            }
        } catch { handleError(StoreError.unknownError) }
        
        return nil
    }
    
    private func incrementCount(_ n: Int) { self.value += n }
    
    private func handleError(_ error: StoreError) {
        switch error {
            case .failedVerification:
                self.errorMessage = "Failed to verify your purchase."
            case .insufficientFunds:
                self.errorMessage = "Insufficient funds for the purchase."
            case .networkUnavailable:
                self.errorMessage = "Network is unavailable. Please check your connection."
            case .unknownError:
                self.errorMessage = "An unknown error occurred. Please try again."
        }
        
        self.showAlert = true
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
            case .unverified:
                throw StoreError.failedVerification
            case .verified(let safe):
                return safe
        }
    }
}
