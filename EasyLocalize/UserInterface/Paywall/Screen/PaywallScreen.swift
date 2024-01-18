//
//  Paywall.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 21.12.2023.
//

import SwiftUI
import StoreKit


struct PaywallScreen: View {
    @StateObject private var viewModel: PaywallViewModel = .init()
    @Environment (\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            backgroundImage
            TransparentVisualEffect(blendingMode: .withinWindow,
                                    material: .hudWindow)
            VStack {
                Spacer()
                Text(String.offerTitle)
                    .font(.system(size: 25, weight: .black))
                    .multilineTextAlignment(.center)
                FeatureView()
                Spacer()
                ForEach(viewModel.products) { product in
                    ProductView(product: product, isSelected: product == viewModel.choosedProduct)
                        .onTapGesture { 
                            withAnimation() {
                                viewModel.choosedProduct = product
                            }
                        }
                }
                BuyButton(text: .getPremium,
                          action: viewModel.purchaseProduct)
                    .padding()
                Spacer()
                Text(String.later)
                    .font(.system(size: 13, weight: .semibold))
                    .onTapGesture { dismiss() }
                Spacer()
            }
            .frame(width: 300)
        }
        .frame(width: 300, height: 600)
    }
    
    private var backgroundImage: some View {
        Image(.offerBackground)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}

#Preview {
    PaywallScreen()
}
