//
//  Paywall.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 21.12.2023.
//

import SwiftUI
import StoreKit

enum Features: CaseIterable {
    case unlimitedTranslates
    case chatGPT
    
    var title: String {
        switch self {
        case .unlimitedTranslates:
            return "Unlimited amount of translates"
        case .chatGPT:
            return "Use ChatGPT for fast translate"
        }
    }
}

struct PaywallScreen: View {
    @StateObject private var viewModel: PaywallViewModel = .init()
    
    var body: some View {
        ZStack {
            backgroundImage
            TransparentVisualEffect(blendingMode: .withinWindow,
                                    material: .hudWindow)
            VStack {
                Text("Unlock all premium features")
                    .font(.system(size: 25, weight: .black))
                FeatureView()
                ForEach(viewModel.products) { product in
                    ProductView(product: product, isSelected: product == viewModel.choosedProduct)
                        .onTapGesture { viewModel.choosedProduct = product }
                }
                Button(action: viewModel.purchaseProduct) {
                    Text("Buy")
                }
            }
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

struct FeatureView: View {
    private var features = Features.allCases
    
    var body: some View {
        VStack {
            ForEach(features, id: \.title) { feature in
                HStack {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.green)
                    Text(feature.title)
                        .font(.system(size: 14, weight: .medium))
                }
                .padding(10)
            }
        }
        .padding()
    }
}

struct ProductView: View {
    let product: Product
    let isSelected: Bool
    
    var body: some View {
        HStack {
            VStack {
                Text(product.displayName)
                    .font(.system(size: 18, weight: .bold))
                    .multilineTextAlignment(.leading)
                Text(product.displayPrice)
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.leading)
            }
            .padding()
        }
        .frame(width: 150)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.orange)
                .addBorder(isSelected ? .green : .clear, width: 3, cornerRadius: 20)
        }
    }
}
