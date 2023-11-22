//
//  MainView.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 04.09.2023.
//

import SwiftUI
import StoreKit

struct MainView: View {
    @ObservedObject private var viewModel: MainViewModel = .init()
    
    @State private var projectPath: URL?
    @State private var error: AppError?
    @State private var isAlertPresented: Bool = false
    
    var body: some View {
        VStack {
            if projectPath != nil {
                MainLocalizeView(viewModel: viewModel,
                                 projectPath: $projectPath)
                .frame(width: 1000, height: 600)
                .padding()
            } else {
                ChoosePathBlock() {
                    projectPath = viewModel.selectProjectPath()
                }
                .frame(width: 600, height: 200)
                .padding()
            }
        }
        .alert(isPresented: $isAlertPresented) {
            Alert(title: Text(error?.title ?? "Unexpected situation"),
                  message: Text(error?.description ?? "We got error but error is nil"),
                  dismissButton: .cancel(Text("OK")){ self.error = nil })
        }
        .onReceive(viewModel.$error) { error in
            guard let error else { return }
            self.error = error
            viewModel.error = nil
            isAlertPresented.toggle()
        }
    }
}

