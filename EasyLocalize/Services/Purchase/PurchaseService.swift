//
//  PurchaseService.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 21.12.2023.
//

import StoreKit

final class PurchaseService: ObservableObject {
    @Published private(set) var products: [Product] = []
    
    var isPremiumActive: Bool {
        return !purchasedProductIDs.isEmpty
    }
    
    static let shared: PurchaseService = .init()
    
    private var purchasedProductIDs = Set<String>()
    
    private let allSubscriptions = ["month_sub", "threeMonths_sub", "oneYear_sub"]
    
    private init() {
        initAllProducts()
    }
    
    func purchase(_ product: Product?) async throws {
        guard let product else { throw NSError(domain: "No such product", code: 0) }
        _ = try await product.purchase()
    }
    
    func getPurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }
            
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
    }
    
    func isTrialAvailable(for product: Product?) async -> Bool {
        guard let product else { return false }
        guard let subscription = product.subscription else { return false }
        return await subscription.isEligibleForIntroOffer
    }
    
    private func initAllProducts() {
        Task {
            do {
                products = try await Product.products(for: allSubscriptions)
                await getPurchasedProducts()
            } catch {
                products = []
            }
        }
    }
}
