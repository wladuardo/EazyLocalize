//
//  EasyLocalizeApp.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 04.09.2023.
//

import SwiftUI
import FirebaseCore
import AppKit

@main
struct EasyLocalizeApp: App {    
    private let purchaseService: PurchaseService = .shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .background {
                    TransparentVisualEffect(blendingMode: .behindWindow, material: .menu)
                        .ignoresSafeArea()
                }
                .task {
                    KeychainService.setup()
                }
                .onAppear {
                    setupFirebase()
                    customizeWindow()
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
    
    private func setupFirebase() {
        UserDefaults.standard.register(defaults: ["NSApplicationCrashOnExceptions" : true])
        FirebaseApp.configure()
    }
}
