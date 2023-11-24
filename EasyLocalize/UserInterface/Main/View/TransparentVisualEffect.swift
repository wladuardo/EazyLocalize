//
//  TransparentVisualEffect.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 22.11.2023.
//

import SwiftUI

struct TransparentVisualEffect: NSViewRepresentable {
    func makeNSView(context: Self.Context) -> NSView {
        return BlurEffectUIView()
    }
    
    func updateNSView(_ nsView: NSView, context: Context) { }
}

class BlurEffectUIView: NSVisualEffectView {
    override func viewDidMoveToWindow() {
        blendingMode = .behindWindow
        state = .active
        material = .menu
    }
}
