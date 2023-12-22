//
//  ChoosePathBlock.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 15.09.2023.
//

import SwiftUI

struct ChoosePathBlock: View {
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text(String.choosePath)
                .font(.system(size: 25, weight: .bold))
            MainButton(text: .choose.capitalized,
                       color: .purple,
                       action: action)
        }
        .padding()
    }
}

#Preview {
    ChoosePathBlock {}
}
