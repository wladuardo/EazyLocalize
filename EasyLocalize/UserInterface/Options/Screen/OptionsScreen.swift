//
//  OptionsScreen.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 22.12.2023.
//

import SwiftUI

struct OptionsScreen: View {
    @StateObject private var viewModel: OptionsViewModel = .init()
    @State private var allOptions = Options.allCases
    @Environment (\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Text("Options")
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
        .frame(width: 300)
    }
    
    private func action(by options: Options) {
        switch options {
        case .privacyPolicy:
            break
        case .termsOfUse:
            break
        case .contact:
            let sharingService = NSSharingService(named: .composeEmail)
            sharingService?.recipients = ["kovalskyvk@icloud.com"]
            sharingService?.subject = "EasyLocalize"
            sharingService?.perform(withItems: [])
        }
    }
}

struct OptionCell: View {
    let option: Options
    let action: () -> Void
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(.purple)
            .overlay {
                HStack {
                    option.image
                    Text(option.title)
                    Spacer()
                }
                .padding()
            }
            .frame(height: 40)
            .onTapGesture { action() }
            .listRowSeparator(.hidden)
            .padding(5)
    }
}

#Preview {
    OptionsScreen()
}
