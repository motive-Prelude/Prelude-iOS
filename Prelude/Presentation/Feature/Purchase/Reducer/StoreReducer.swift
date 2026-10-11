//
//  StoreFeature.swift
//  Prelude
//
//  Created by 송지혁 on 5/18/25.
//

import ComposableArchitecture
import StoreKit
import SwiftUI

final class StoreKitClient {
    func requestProducts<Identifiers>(for identifiers: Identifiers) async throws -> [Product] where Identifiers: Collection, Identifiers.Element == String {
        try await Product.products(for: identifiers)
    }
    
    func purchase(_ product: Product) async throws -> StoreKit.Transaction {
        let result = try await product.purchase()
        
        switch result {
            case .success(let verificationResult):
                let transaction = try checkVerified(verificationResult)
                await transaction.finish()
                return transaction
                
            case .pending, .userCancelled:
                throw StoreKitError.userCancelled
            @unknown default:
                throw StoreKitError.unknown
        }
    }
    
    func observeTransactions() -> AsyncStream<StoreKit.Transaction> {
        AsyncStream { continuation in
            Task {
                for await update in Transaction.updates {
                    do {
                        let transaction = try self.checkVerified(update)
                        await transaction.finish()
                        continuation.yield(transaction)
                    } catch {
                        
                    }
                }
            }
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
            case .verified(let safe): return safe
            case .unverified: throw StoreError.failedVerification
        }
    }
}

@Reducer
struct StoreReducer {
    @ObservableState
    struct State {
        @Shared(.inMemory("session")) var session: Session = .init()
        var selectedSeeds: Int = 0
        var productInfo: [String: String] = [:]
        var storeProducts: [Product] = []
        var value = 0
        var errorMessage = ""
        var showAlert = false
        let productAmountMap: [String: Int] = [
            "com.prelude.seeds.1usd": 10,
            "com.prelude.seeds.2usd": 20,
            "com.prelude.seeds.3usd": 30,
            "com.prelude.seeds.4usd": 40,
            "com.prelude.seeds.5usd": 50,
            "com.prelude.seeds.6usd": 60,
            "com.prelude.seeds.7usd": 70,
            "com.prelude.seeds.8usd": 80,
            "com.prelude.seeds.9usd": 90,
            "com.prelude.seeds.10usd": 100
        ]
        
        var remainingSeeds: UInt {
            guard let userInfo = session.userInfo else { return 0 }
            return userInfo.remainingTimes
        }
        
        var totalPrice: String {
            let price = Decimal(selectedSeeds) * 0.1
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
    
            return formatter.string(for: price) ?? "0.00"
        }
    }
    
    enum Action: BindableAction {
        case onAppear
        case productsLoaded([Product])
        case incrementCurrencyCount(String, Int)
        case incrementCurrencyResponse(Result<UserInfo, DomainError>)
        
        case backButtonTapped
        case purchaseButtonTapped
        case purchaseResponse(Result<StoreKit.Transaction, StoreError>)
        case transactionUpdate(StoreKit.Transaction)
        case dismiss
        case binding(BindingAction<State>)
        
        case setToast(ToastEvent)
        
    }
    
    enum CancelID {
        case transactionObservation
    }
    
    @Dependency(\.eventBus) var eventBus
    @Dependency(\.storekitClient) var storeKitClient
    @Dependency(\.addCurrencyUseCase) var addCurrencyUseCase
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                case .onAppear:
                    state.productInfo = Self.loadProducts()
                    let productsIdentifier = state.productInfo.values
                    return .merge(
                        .run { send in
                            let products = try await storeKitClient.requestProducts(for: productsIdentifier)
                            await send(.productsLoaded(products))
                        },
                        .run { send in
                            for await transaction in storeKitClient.observeTransactions() {
                                await send(.transactionUpdate(transaction))
                            }
                        }
                            .cancellable(id: CancelID.transactionObservation)
                    )
                    
                case .productsLoaded(let products):
                    state.storeProducts = products
                    return .none
                    
                case .purchaseButtonTapped:
                    let productID = String(state.selectedSeeds / 10)
                    print(productID)
                    guard let product = state.storeProducts.first(where: { $0.id == "com.prelude.seeds.\(productID)usd" }) else { return .none }
                    
                    return .run { send in
                        do {
                            let result = try await storeKitClient.purchase(product)
                            await send(.purchaseResponse(.success(result)))
                        } catch let error as StoreError { await send(.purchaseResponse(.failure(error))) }
                    }
                    
                case .backButtonTapped:
                    return .run { _ in await dismiss() }
                    
                case .purchaseResponse(.success(let transaction)):
                    guard let currency = state.productAmountMap[transaction.productID] else { return .none }
                    guard let id = state.session.userInfo?.id else { return .none }
                    
                    return .send(.incrementCurrencyCount(id, currency))
                    
                    
                case let .incrementCurrencyCount(id, amount):
                    return .run { send in
                        do {
                            let updatedUserInfo = try await addCurrencyUseCase.execute(id: id, amount: amount)
                            await send(.incrementCurrencyResponse(.success(updatedUserInfo)))
                            await send(.setToast(.intent(.purchaseCompleted(amount))))
                            
                        } catch let error as DomainError { await send(.incrementCurrencyResponse(.failure(error))) }
                    }
                    
                case .incrementCurrencyResponse(.success(let userInfo)):
                    state.$session.userInfo.withLock { $0 = userInfo }
                    return .run { _ in await dismiss() }
                    
                case .incrementCurrencyResponse(.failure(let error)):
                    return .none
                    
                case .purchaseResponse(.failure(let error)):
                    return .none
                    
                case .transactionUpdate(let transaction):
                    guard let amount = state.productAmountMap[transaction.productID],
                          let id = state.session.userInfo?.id else { return .none }
                    
                    return .send(.incrementCurrencyCount(id, amount))
                    
                case .setToast(let event):
                    return .run { _ in await eventBus.send(.toast(event)) }
                    
                case .binding(_): return .none
                    
                case .dismiss:
                    return .none
            }
        }
    }
    
    static func loadProducts() -> [String: String] {
        guard let path = Bundle.main.path(forResource: "Products", ofType: "plist"),
              let plist = FileManager.default.contents(atPath: path),
              let data = try? PropertyListSerialization.propertyList(from: plist, options: [], format: nil) as? [String: String] else { return [:] }
        
        return data
    }
}
