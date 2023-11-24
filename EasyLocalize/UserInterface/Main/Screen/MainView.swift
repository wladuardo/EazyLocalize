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
    }
}

