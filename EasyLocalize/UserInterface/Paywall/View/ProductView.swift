//
//  ProductView.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 21.12.2023.
//

import SwiftUI
import StoreKit

struct ProductView: View {
    let product: Product
    let isSelected: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(product.displayName)
                    .font(.system(size: 18, weight: .bold))
                Text(product.displayPrice)
                    .font(.system(size: 24, weight: .bold))
            }
            .padding(.leading)
            Spacer()
        }
        .frame(width: 250, height: 70)
        .background {
            TransparentVisualEffect(blendingMode: .withinWindow,
                                               material: .menu)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .addBorder(isSelected ? .purple : .clear, width: 1, cornerRadius: 20)
        }
    }
}

#Preview {
    ProductView(product: PurchaseService.shared.products.first!, isSelected: true)
}
