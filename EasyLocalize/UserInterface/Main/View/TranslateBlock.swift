//
//  TranslateBlock.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 14.09.2023.
//

import SwiftUI

struct TranslateBlock: View {
    @State var fileName: String
    @StateObject var viewModel: MainViewModel
    @Binding var keyName: String
    @Binding var needToClear: Bool
    
    @State private var translate: String = ""
    @State private var isNeededToSave: Bool = true
    
    var body: some View {
        VStack {
            HStack {
                Text(viewModel.getFullLanguageName(from: fileName).capitalized)
                    .font(.system(size: 14, weight: .medium))
                Spacer()
            }
            HStack {
                TextField(fileName, text: $translate, axis: .vertical)
                Toggle(isOn: $isNeededToSave, label: {})
            }
        }
        .padding()
        .onReceive(viewModel.$chooseAllTranslates) { value in
            isNeededToSave = value
        }
        .onReceive(viewModel.$saveSignal) { saveSignal in
            guard isNeededToSave else { return }
            guard !translate.isEmpty else { return }
            viewModel.addKeyValuePairs(fileName: fileName,
                                       key: keyName,
                                       translate: translate)
            translate.removeAll()
        }
        .onReceive(viewModel.$translatesDictionary) { translatesDictionary in
            let languageName = fileName.replacingOccurrences(of: ".lproj", with: "")
            guard let translate = translatesDictionary.first(where: { $0.key == languageName })?.value else { return }
            self.translate = translate
        }
        .onChange(of: needToClear) { isNeeded in
            guard isNeeded else { return }
            translate.removeAll()
            needToClear.toggle()
        }
    }
}

#Preview {
    TranslateBlock(fileName: .addTranslation,
                   viewModel: .init(),
                   keyName: .constant("Hello"),
                   needToClear: .constant(false))
}
