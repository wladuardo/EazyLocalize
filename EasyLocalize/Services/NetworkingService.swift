//
//  ChatGPTAPI.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 14.09.2023.
//

import Foundation
import Networking

final class NetworkingService {
    static let shared: NetworkingService = .init()
    
    private let networkService: NetworkService
    
    private init() {
        self.networkService = .init()
    }
    
    public func sendRequest(with textToTranslate: String, targetLanguages: [String]) async throws -> [String: String] {
        let model: SendMessageModel = .init(role: .user, content: getPromt(with: textToTranslate, targetLanguages: targetLanguages))
        let requestModel: ChatGPTSendRequest = .init(model: model)
        let result = await networkService.chatGPTAPI.sendMessage(params: requestModel)
        
        switch result {
        case .success(let success):
            let result: [String]? = success.choices?.compactMap { return $0.message.content }
            guard let stringResult = result?.first else {
                throw NSError(domain: "Response is nil", code: 0)
            }
            
            return try decodeJsonString(stringResult)
        case .failure(let failure):
            throw failure
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
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: String] {
                    return jsonObject
                } else {
                    throw NSError(domain: "Cannot get Dictionary from JSONString", code: 0)
                }
            } catch {
                throw error
            }
        } else {
            throw NSError(domain: "Cannot get data from JSONString", code: 0)
        }
    }
}
