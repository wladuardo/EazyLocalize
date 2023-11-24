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
    @State private var isTranslatesAdded: Bool = false
    @State private var isAlertPresented: Bool = false
    @State private var error: AppError?
    
    var body: some View {
        HStack {
            leftBlock
            rightBlock
        }
        .onReceive(viewModel.$isTranslatesAdded) { isTranslatesAdded = $0 }
        .onReceive(viewModel.$error) { onRecieveErrorAction($0) }
        
        .alert(error?.title ?? "Unexpected situation",
               isPresented: $isAlertPresented,
               actions: { Button("OK") { clearView() } },
               message: { Text(error?.description ?? "We got error but error is nil") })
        .alert(String.success,
               isPresented: $isTranslatesAdded,
               actions: { Button("OK") { clearView() } },
               message: { Text(String.translatesAdded) })
    }
    
    private var leftBlock: some View {
        VStack {
            TextWithLeadingAlignment(text: .enterNameForKey)
            TextField(String.enterYourKey, text: $keyName, axis: .vertical)
                .padding()
            
            TextWithLeadingAlignment(text: .getTranslateFromChat)
            HStack {
                TextField(String.enterTextToTranslate, text: $textToTranslate, axis: .vertical)
                    .padding()
                Button(action: { viewModel.translateText(textToTranslate) }, label: {
                    Text(String.translate)
                        .fontWeight(.semibold)
                })
            }
            
            Spacer()
            HStack {
                Button(String.clear, action: clearView)
                Button(String.chooseAnotherPath, action: { projectPath = nil })
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
                    TextWithLeadingAlignment(text: .localizableFound)
                    
                    ForEach(viewModel.fileNames, id: \.self) { fileName in
                        TranslateBlock(fileName: fileName,
                                       viewModel: viewModel,
                                       keyName: $keyName,
                                       needToClear: $needToClear)
                    }
                    
                    Button(action: viewModel.giveSignalToSave) {
                        if viewModel.isSaved {
                            Image(systemName: "checkmark.diamond.fill")
                                .foregroundColor(.green)
                        } else {
                            Text(String.addTranslation)
                                .fontWeight(.semibold)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .scrollDisabled(viewModel.isTranslatingInProgress)
            }
            .blur(radius: viewModel.isTranslatingInProgress ? 5 : 0)
        }
    }
    
    private func clearView() {
        needToClear.toggle()
        textToTranslate.removeAll()
        keyName.removeAll()
        viewModel.isSaved = false
        error = nil
    }
    
    private func onRecieveErrorAction(_ error: AppError?) {
        guard let error else { return }
        self.error = error
        viewModel.error = nil
        isAlertPresented.toggle()
    }
}
