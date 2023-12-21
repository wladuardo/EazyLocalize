//
//  PaywallViewModel.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 21.12.2023.
//

import Foundation
import StoreKit

final class PaywallViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var choosedProduct: Product?
    
    private let purchaseService: PurchaseService = .shared
    
    init() {
        products = purchaseService.products
        choosedProduct = products.first
    }
    
    func purchaseProduct() {
        Task {
           try await purchaseService.purchase(choosedProduct)
        }
    }
}
