//
//  TextWithLeadingAlignment.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 15.09.2023.
//

import SwiftUI

struct TextWithLeadingAlignment: View {
    let text: String
    var body: some View {
        HStack {
            Text(text)
                .font(.system(size: 25, weight: .bold))
                .padding(.leading)
            Spacer()
        }
    }
}
