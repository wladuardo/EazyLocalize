//
//  EasyLocalizeApp.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 04.09.2023.
//

import SwiftUI

@main
struct EasyLocalizeApp: App {
    private let purchaseService: PurchaseService = .shared
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear(perform: customizeWindow)
                .background {
                    TransparentVisualEffect(blendingMode: .behindWindow, material: .menu)
                        .ignoresSafeArea()
                }
        }
        .windowResizability(.contentSize)
        .defaultPosition(.center)
    }
    
    private func customizeWindow() {
        guard let window = NSApplication.shared.windows.first else { return }
        window.titlebarAppearsTransparent = true
        window.styleMask.insert(.fullSizeContentView)
    }
}
