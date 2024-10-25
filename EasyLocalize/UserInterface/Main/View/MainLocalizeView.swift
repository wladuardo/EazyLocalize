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
    @State private var isPaywallPresented: Bool = false
    @State private var isAllTranslatesChoosed: Bool = true
    @State private var isOptionsPresented: Bool = false
    
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
                MainButton(text: .translate, color: .purple) {
                    if PurchaseService.shared.isPremiumActive {
                        viewModel.translateText(textToTranslate)
                    } else if KeychainService.getIsFreeAvailable(for: .gptUsage) {
                        viewModel.translateText(textToTranslate)
                        KeychainService.updateFreeCount(for: .gptUsage,
                                                        with: 1,
                                                        isAdding: false)
                    } else {
                        isPaywallPresented.toggle()
                    }
                }
            }
            Spacer()
            HStack {
                MainButton(text: .clear,
                           color: .red) {
                    AnalyticsService.sendEvent(.clearTapped)
                    clearView()
                }
                
                MainButton(text: .chooseAnotherPath,
                           color: .purple) {
                    AnalyticsService.sendEvent(.newPathTapped)
                    projectPath = nil
                }
                
                MainButton(text: .options,
                           color: .purple) {
                    AnalyticsService.sendEvent(.optionsTapped)
                    isOptionsPresented.toggle()
                }
            }
            Spacer()
        }
        .sheet(isPresented: $isOptionsPresented) { OptionsScreen() }
        .sheet(isPresented: $isPaywallPresented) { PaywallScreen() }
    }
    
    private var rightBlock: some View {
        ZStack {
            if viewModel.isTranslatingInProgress {
                ProgressView()
            }
            VStack {
                ScrollView {
                    TextWithLeadingAlignment(text: .localizableFound)
                        .padding(.bottom)
                    chooseAllBlock
                    ForEach(viewModel.fileNames, id: \.self) { fileName in
                        TranslateBlock(fileName: fileName,
                                       viewModel: viewModel,
                                       keyName: $keyName,
                                       needToClear: $needToClear)
                    }
                    MainButton(text: viewModel.isTranslatesAdded
                               ? "Translation added"
                               : .addTranslation,
                               color: .purple) {
                        if PurchaseService.shared.isPremiumActive {
                            viewModel.giveSignalToSave()
                        } else if KeychainService.getIsFreeAvailable(for: .addingTranslation) {
                            viewModel.giveSignalToSave()
                            KeychainService.updateFreeCount(for: .addingTranslation,
                                                            with: 1,
                                                            isAdding: false)
                        } else {
                            isPaywallPresented.toggle()
                        }
                    }
                               .padding()
                }
                .scrollIndicators(.hidden)
                .scrollDisabled(viewModel.isTranslatingInProgress)
            }
            .blur(radius: viewModel.isTranslatingInProgress ? 5 : 0)
        }
    }
    
    private var chooseAllBlock: some View {
        return HStack {
            Text(String.chooseAll)
                .font(.system(size: 14, weight: .medium))
            Spacer()
            Toggle(isOn: $isAllTranslatesChoosed) {}
        }
        .onChange(of: isAllTranslatesChoosed) { value in
            viewModel.needToChooseAllTranslates(value)
        }
        .padding()
    }
    
    private func clearView() {
        needToClear.toggle()
        textToTranslate.removeAll()
        keyName.removeAll()
        viewModel.isTranslatesAdded = false
        error = nil
    }
    
    private func onRecieveErrorAction(_ error: AppError?) {
        guard let error else { return }
        self.error = error
        viewModel.error = nil
        isAlertPresented.toggle()
    }
}

#Preview {
    MainLocalizeView(viewModel: .init(), projectPath: .constant(nil))
}
