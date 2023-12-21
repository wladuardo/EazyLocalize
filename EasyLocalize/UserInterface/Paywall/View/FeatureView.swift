//
//  FeatureView.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 21.12.2023.
//

import SwiftUI

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

#Preview {
    FeatureView()
}
