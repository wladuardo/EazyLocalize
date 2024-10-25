//
//  OptionsScreen.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 22.12.2023.
//

import SwiftUI

struct OptionsScreen: View {
    @StateObject private var viewModel: OptionsViewModel = .init()
    @Environment (\.dismiss) private var dismiss
    
    @State private var allOptions = Options.allCases
    @State private var isTextViewPresented: Bool = false
    
    var body: some View {
        ZStack {
            if viewModel.isLoading { ProgressView() }
            VStack {
                HStack {
                    Text(String.options)
                        .font(.system(size: 25, weight: .bold))
                    Spacer()
                    Button(action: dismiss.callAsFunction) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .buttonStyle(.borderless)
                }
                .padding(.horizontal)
                .padding(.bottom, 25)
                
                ForEach(allOptions) { option in
                    OptionCell(option: option) { action(by: option) }
                }
            }
            .padding()
            .blur(radius: viewModel.isLoading ? 5 : 0)
            .frame(width: 360)
        }
        .sheet(isPresented: $isTextViewPresented) {
            if let selectedOption = viewModel.selectedOption {
                TextView(type: selectedOption)
            }
        }
        .onReceive(viewModel.$selectedOption) { option in
            guard let option else { return }
            isTextViewPresented.toggle()
        }
    }
    
    private func action(by options: Options) {
        viewModel.buttonAction(options)
    }
}

#Preview {
    OptionsScreen()
}
