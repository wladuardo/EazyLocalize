//
//  TransparentVisualEffect.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 22.11.2023.
//

import SwiftUI

struct TransparentVisualEffect: NSViewRepresentable {
    let blendingMode: NSVisualEffectView.BlendingMode
    let material: NSVisualEffectView.Material
    
    func makeNSView(context: Self.Context) -> NSView {
        return BlurEffectUIView(blendingMode: blendingMode, material: material)
    }
    
    func updateNSView(_ nsView: NSView, context: Context) { }
}

class BlurEffectUIView: NSVisualEffectView {
    private let customBlendingMode: NSVisualEffectView.BlendingMode
    private let customMaterial: NSVisualEffectView.Material
    
    init(blendingMode: NSVisualEffectView.BlendingMode,
         material: NSVisualEffectView.Material) {
        self.customBlendingMode = blendingMode
        self.customMaterial = material
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        self.customBlendingMode = .behindWindow
        self.customMaterial = .menu
        super.init(coder: coder)
    }
    
    override func viewDidMoveToWindow() {
        blendingMode = customBlendingMode
        state = .active
        material = customMaterial
    }
}
