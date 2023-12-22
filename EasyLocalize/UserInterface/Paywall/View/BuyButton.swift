//
//  BuyButton.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 22.12.2023.
//

import SwiftUI

struct BuyButton: View {
    let text: String
    let action: () -> Void
    
    @State private var animateGradient: Bool = false
    @State private var animateScale: Bool = false
    
    var body: some View {
        TransparentVisualEffect(blendingMode: .withinWindow, material: .fullScreenUI)
            .animatedGradientBackground(colors: [.purple, .pink, .red, .yellow, .white],
                                        animateGradient: animateGradient)
            .overlay {
                Text(text)
                    .font(.system(size: 20, weight: .bold))
            }
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .scaleEffect(.init(width: animateScale ? 1.05 : 1,
                               height: animateScale ? 1.05 : 1))
            .frame(width: 250, height: 50)
            .onAppear {
                withAnimation(.bouncy(duration: 3).repeatForever()) {
                    animateGradient.toggle()
                }
                withAnimation(.bouncy(duration: 2).repeatForever()) {
                    animateScale.toggle()
                }
            }
            .onTapGesture { action() }
    }
}

#Preview {
    BuyButton(text: "Buy", action: {})
}
