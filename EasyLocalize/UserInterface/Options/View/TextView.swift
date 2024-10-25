//
//  TextView.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 11.01.2024.
//

import SwiftUI

struct TextView: View {
    let type: Options
    
    @Environment (\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Text(type.title)
                    .font(.system(size: 25, weight: .bold))
                Spacer()
                Button(action: dismiss.callAsFunction) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(.borderless)
            }
            ScrollView {
                Text(type.description ?? .init())
                    .font(.system(size: 15, weight: .semibold))
            }
        }
        .padding()
        .frame(width: 400, height: 500)
    }
}

#Preview {
    TextView(type: .privacyPolicy)
}
