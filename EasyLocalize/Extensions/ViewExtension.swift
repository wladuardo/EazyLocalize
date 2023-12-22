//
//  ViewExtension.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 21.12.2023.
//

import SwiftUI

extension View {
     public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
         let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
         return clipShape(roundedRect)
              .overlay(roundedRect.strokeBorder(content, lineWidth: width))
     }
    
    public func animatedGradientBackground(colors: [Color], animateGradient: Bool) -> some View {
        modifier(AnimatedGradientBackgroundModifier(colors: colors, animateGradient: animateGradient))
    }
 }
