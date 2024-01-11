//
//  OptionCell.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 11.01.2024.
//

import SwiftUI

struct OptionCell: View {
    let option: Options
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                option.image
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                Text(option.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding()
        }
        .background(.purple)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(5)
        .buttonStyle(.borderless)
    }
}

#Preview {
    OptionCell(option: .privacyPolicy, action: {})
}
