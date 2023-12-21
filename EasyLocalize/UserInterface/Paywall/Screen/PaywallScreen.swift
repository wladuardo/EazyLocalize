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
    
    var body: some View {
        ZStack {
            backgroundImage
            TransparentVisualEffect(blendingMode: .withinWindow,
                                    material: .hudWindow)
            VStack {
                Spacer()
                Text("Unlock all premium features")
                    .font(.system(size: 25, weight: .black))
                    .multilineTextAlignment(.center)
                FeatureView()
                Spacer()
                ForEach(viewModel.products) { product in
                    ProductView(product: product, isSelected: product == viewModel.choosedProduct)
                        .onTapGesture { viewModel.choosedProduct = product }
                }
                Button(action: viewModel.purchaseProduct) {
                    Text("Buy")
                }
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
