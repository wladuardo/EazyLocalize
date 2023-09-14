//
//  MainViewModel.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 04.09.2023.
//

import Foundation
import AppKit

class MainViewModel: ObservableObject {
    @Published var fileNames: [String] = []
    @Published var translatesDictionary: [String: String] = [:]
    
    private var localizableStringPaths: [URL] = []
    private let networkingService: NetworkingService = .shared
    
    func selectProjectPath() -> URL? {
        let dialog = NSOpenPanel()
        dialog.title = "Выберите Xcode проект"
        dialog.canChooseFiles = false
        dialog.canChooseDirectories = true
        dialog.allowsMultipleSelection = false
        
        guard dialog.runModal() == NSApplication.ModalResponse.OK else { return nil }
        guard let url = dialog.url else { return nil }
        localizableStringPaths = localizableStringsPaths(in: url)
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
                        print("У вас нет разрешения на запись файла \"Localizable.strings\" в папке \(fileName)")
                        return
                    }
                    
                    try existingKeyValuePairs.write(to: localizableStringPath, atomically: true, encoding: .utf8)
                }
            } catch {
                print("Ошибка при обновлении файла: \(error.localizedDescription)")
            }
        }
    }
    
    func translateText(_ textToTranslate: String) {
        Task {
            guard !textToTranslate.isEmpty
                && textToTranslate.count > 1 else { return }
            let languageNames = fileNames.map { $0.replacingOccurrences(of: ".lproj", with: "") }
            let translates = try await networkingService.sendRequest(with: textToTranslate, targetLanguages: languageNames)
            await MainActor.run {
                translatesDictionary = translates
            }
        }
    }
    
    private func localizableStringsPaths(in projectPath: URL) -> [URL] {
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
    
    private func getFileNames() {
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
}
