//
//  MainView.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 04.09.2023.
//

import SwiftUI

struct MainView: View {
    @ObservedObject private var viewModel: MainViewModel = .init()
    @State private var projectPath: URL?
    @State private var keyName: String = ""
    @State private var textToTranslate: String = ""
    @State private var needToClear: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                if (projectPath != nil) {
                    Text("Введите пары с переводами")
                        .font(.system(size: 15, weight: .bold))
                    TextField("Введите ключ здесь", text: $keyName)
                        .padding()
                    Text("Запросить перевод в ChatGPT")
                    HStack {
                        TextField("Введите фразу которую нужно перевести", text: $textToTranslate)
                            .padding()
                        Button("Перевести", action: {
                            viewModel.translateText(textToTranslate)
                        })
                    }
                    
                    ForEach(viewModel.fileNames, id: \.self) { fileName in
                        TranslateBlock(fileName: fileName,
                                       viewModel: viewModel,
                                       keyName: $keyName,
                                       needToClear: $needToClear)
                    }
                    
                    Button("Добавить новую локализацию", action: {
                        needToClear.toggle()
                        textToTranslate.removeAll()
                        keyName.removeAll()
                    })
                } else {
                    Text(String.choosePath)
                        .font(.system(size: 15, weight: .bold))
                    Button(action: {
                        projectPath = viewModel.selectProjectPath()
                    }, label: {
                        Text("Выбрать")
                    })
                }
            }
            .padding()
        }
    }
}

struct TranslateBlock: View {
    @State var fileName: String
    @StateObject var viewModel: MainViewModel
    @Binding var keyName: String
    @Binding var needToClear: Bool
    
    @State private var translate: String = ""
    @State private var isSaved: Bool = false
    
    var body: some View {
        HStack {
            TextField(fileName, text: $translate)
                .padding()
            Button(action: {
                if !isSaved {
                    guard !translate.isEmpty else { return }
                    viewModel.addKeyValuePairs(fileName: fileName, key: keyName, translate: translate)
                    translate.removeAll()
                    withAnimation(.easeInOut) {
                        isSaved = true
                    }
                }
            }, label: {
                if !isSaved {
                    Text(String.addTranslation)
                } else {
                    Image(systemName: "checkmark.diamond.fill")
                        .foregroundColor(.green)
                }
            })
            .padding()
        }
        .onReceive(viewModel.$translatesDictionary) { translatesDictionary in
            let languageName = fileName.replacingOccurrences(of: ".lproj", with: "")
            guard let translate = translatesDictionary.first(where: { $0.key == languageName })?.value else { return }
            self.translate = translate
        }
        .onChange(of: needToClear) { isNeeded in
            guard isNeeded else { return }
            translate.removeAll()
            isSaved = false
            needToClear.toggle()
        }
    }
}

