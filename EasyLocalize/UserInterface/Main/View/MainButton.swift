//
//  MainButton.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 22.12.2023.
//

import SwiftUI

struct MainButton: View {
    let text: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .fontWeight(.semibold)
                .padding(5)
        }
        .background {
            RoundedRectangle(cornerRadius: Config.buttonCornerRadius)
                .foregroundStyle(color)
        }
        .clipShape(RoundedRectangle(cornerRadius: Config.buttonCornerRadius))
    }
}

#Preview {
    MainButton(text: "Hello", color: .purple) {}
}
