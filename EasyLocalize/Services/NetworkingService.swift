//
//  ChatGPTAPI.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 14.09.2023.
//

import Foundation
import Networking

enum JsonDecodingError: Error {
    case invalidData
    case decodingFailure
}

final class NetworkingService {
    static let shared: NetworkingService = .init()
    
    private let networkService: NetworkService
    
    private init() {
        self.networkService = .init()
    }
    
    public func sendRequest(with textToTranslate: String, targetLanguages: [String]) async throws -> [String: String] {
        let model: SendMessageModel = .init(role: .user,
                                            chatModel: .chatGPT3Turbo,
                                            content: getPromt(with: textToTranslate, targetLanguages: targetLanguages))
        let requestModel: ChatGPTSendRequest = .init(model: model)
        
        do {
            let result = try await networkService.chatGPTAPI.sendMessage(params: requestModel)
            let choices: [String]? = result.choices?.compactMap { return $0.message.content }
            
            guard let stringResult = choices?.first else {
                throw NSError(domain: "Response is nil", code: 0)
            }
            
            return try decodeJsonString(stringResult)
        } catch {
            throw error
        }
    }
    
    private func getPromt(with textToTranslate: String, targetLanguages: [String]) -> String {
        var promtString: String = Config.promtInstruction(textToTranslate)
        let languageList = targetLanguages.joined(separator: ", ")
        promtString += " " + languageList
        promtString.append(contentsOf: Config.responseDescription)
        return promtString
    }
    
    private func decodeJsonString(_ jsonString: String) throws -> [String: String] {
        guard let jsonData = jsonString.data(using: .utf8) else {
            throw JsonDecodingError.invalidData
        }
        
        guard let jsonObject = try JSONSerialization.jsonObject(with: jsonData) as? [String: String] else {
            throw JsonDecodingError.decodingFailure
        }
        
        return jsonObject
    }
}
