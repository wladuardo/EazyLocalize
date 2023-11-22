//
//  TransparentVisualEffect.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 22.11.2023.
//

import SwiftUI

struct TransparentVisualEffect: NSViewRepresentable {
    func makeNSView(context: Self.Context) -> NSView {
        let visualEffect = NSVisualEffectView()
        visualEffect.blendingMode = .behindWindow
        visualEffect.state = .active
        visualEffect.material = .fullScreenUI
        return visualEffect
    }
    
    func updateNSView(_ nsView: NSView, context: Context) { }
}
