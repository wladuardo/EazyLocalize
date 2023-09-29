//
//  MainLocalizeView.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 15.09.2023.
//

import SwiftUI

struct MainLocalizeView: View {
    @ObservedObject var viewModel: MainViewModel
    @Binding var projectPath: URL?
    
    @State private var keyName: String = ""
    @State private var textToTranslate: String = ""
    @State private var needToClear: Bool = false
    
    var body: some View {
        HStack {
            leftBlock
            rightBlock
        }
    }
    
    private var leftBlock: some View {
        VStack {
            TextWithLeadingAlignment(text: "Введите название для ключа")
            TextField(String.enterYourKey, text: $keyName)
                .padding()
                .textFieldStyle(.roundedBorder)
            
            TextWithLeadingAlignment(text: "Запросить перевод в ChatGPT")
            HStack {
                TextField(String.enterTextToTranslate, text: $textToTranslate)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                Button(action: { viewModel.translateText(textToTranslate) }, label: {
                    Text("Перевести")
                        .fontWeight(.semibold)
                })
            }
            
            Spacer()
            HStack {
                Button("Добавить новую локализацию", action: {
                    needToClear.toggle()
                    textToTranslate.removeAll()
                    keyName.removeAll()
                    viewModel.isSaved.toggle()
                })
                Button(String.chooseAnotherPath, action: {
                    projectPath = nil
                })
            }
            Spacer()
        }
    }
    
    private var rightBlock: some View {
        ZStack {
            if viewModel.isTranslatingInProgress {
                ProgressView()
            }
            VStack {
                ScrollView {
                    TextWithLeadingAlignment(text: "Обнаружены следующие Localizable.strings файлы в вашем проекте:")
                    ForEach(viewModel.fileNames, id: \.self) { fileName in
                        TranslateBlock(fileName: fileName,
                                       viewModel: viewModel,
                                       keyName: $keyName,
                                       needToClear: $needToClear)
                    }
                    Button(action: { viewModel.giveSignalToSave() }, label: {
                        if !viewModel.isSaved {
                            Text(String.addTranslation)
                                .fontWeight(.semibold)
                        } else {
                            Image(systemName: "checkmark.diamond.fill")
                                .foregroundColor(.green)
                        }
                    })
                }
                .scrollIndicators(.hidden)
                .scrollDisabled(viewModel.isTranslatingInProgress)
            }
            .blur(radius: viewModel.isTranslatingInProgress ? 5 : 0)
        }
    }
}
