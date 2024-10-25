//
//  AnimatedGradientBackgroundModifier.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 22.12.2023.
//

import SwiftUI

struct AnimatedGradientBackgroundModifier: ViewModifier {
    let colors: [Color]
    let animateGradient: Bool
    
    func body(content: Content) -> some View {
        let gradient = LinearGradient(
            colors: colors,
            startPoint: animateGradient ? .topLeading : .topTrailing,
            endPoint: animateGradient ? .bottomTrailing : .bottomLeading
        )
        
        return content
            .background(gradient.mask(content))
    }
}
