//
//  MainViewModel.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 04.09.2023.
//

import Foundation
import AppKit

final class MainViewModel: ObservableObject {
    @Published var fileNames: [String] = []
    @Published var translatesDictionary: [String: String] = [:]
    @Published var isTranslatingInProgress: Bool = false
    @Published var saveSignal: Bool = true
    @Published var isSaved: Bool = false
    @Published var isTranslatesAdded: Bool = false
    @Published var error: AppError?
    
    private var localizableStringPaths: [URL] = []
    private let networkingService: NetworkingService = .shared
    
    func selectProjectPath() -> URL? {
        let dialog = NSOpenPanel()
        dialog.title = String.choosePath
        dialog.canChooseFiles = false
        dialog.canChooseDirectories = true
        dialog.allowsMultipleSelection = false
        
        guard dialog.runModal() == NSApplication.ModalResponse.OK else { return nil }
        guard let url = dialog.url else { return nil }
        localizableStringPaths = getLocalizableStringsPaths(in: url)
        getFileNames()
        return dialog.url
    }
    
    func addKeyValuePairs(fileName: String, key: String, translate: String) {
        for localizableStringPath in localizableStringPaths {
            do {
                if localizableStringPath.pathComponents.contains(where: { $0 == fileName }) {
                    var existingKeyValuePairs = try String(contentsOf: localizableStringPath)
                    
                    let newKeyValuePair = "\"\(key)\" = \"\(translate)\";"
                    existingKeyValuePairs.append("\n\(newKeyValuePair)")
                    
                    guard FileManager.default.isWritableFile(atPath: localizableStringPath.path) else {
                        showError(.noAccess)
                        return
                    }
                    
                    try existingKeyValuePairs.write(to: localizableStringPath, atomically: true, encoding: .utf8)
                    isTranslatesAdded = true
                }
            } catch {
                showError(.updateError(description: error.localizedDescription))
            }
        }
    }
    
    func translateText(_ textToTranslate: String) {
        Task {
            do {
                guard !textToTranslate.isEmpty && textToTranslate.count > 1 else {
                    showError(.emptyTextToTranslate)
                    return
                }
                await MainActor.run { isTranslatingInProgress = true }
                let languageNames = fileNames.map { $0.replacingOccurrences(of: ".lproj", with: "") }
                let translates = try await networkingService.sendRequest(with: textToTranslate, targetLanguages: languageNames)
                await MainActor.run {
                    isTranslatingInProgress = false
                    translatesDictionary = translates
                }
            } catch {
                await MainActor.run { isTranslatingInProgress = false }
                showError(.translateError(description: error.localizedDescription))
            }
        }
    }
    
    func giveSignalToSave() {
        Task {
            await MainActor.run {
                saveSignal = true
                isSaved = true
            }
        }
    }
    
    func getFullLanguageName(from localizedFileName: String) -> String {
        let languageCode = localizedFileName.components(separatedBy: ".").first ?? "en"
        let locale = Locale(identifier: languageCode)
        return locale.localizedString(forIdentifier: languageCode) ?? ""
    }
}

private extension MainViewModel {
    func getLocalizableStringsPaths(in projectPath: URL) -> [URL] {
        let fileManager = FileManager.default
        let enumerator = fileManager.enumerator(at: projectPath, includingPropertiesForKeys: nil)
        var localizableStringsPaths: [URL] = []
        
        while let fileURL = enumerator?.nextObject() as? URL {
            if fileURL.pathExtension == "strings" && fileURL.lastPathComponent.hasPrefix("Localizable") {
                localizableStringsPaths.append(fileURL)
            }
        }
        
        return localizableStringsPaths
    }
    
    func getFileNames() {
        guard !localizableStringPaths.isEmpty else { return }
        localizableStringPaths.forEach({ url in
            if let decodedURLString = url.absoluteString.removingPercentEncoding {
                let elements = decodedURLString.components(separatedBy: "/")
                if elements.count > 1 {
                    let fileName = elements[elements.count - 2]
                    fileNames.append(fileName)
                }
            }
        })
    }
    
    func showError(_ error: AppError) {
        Task {
            await MainActor.run {
                self.error = error
            }
        }
    }
}
