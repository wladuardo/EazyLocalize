//
//  ChatGPTModel.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 14.09.2023.
//

import Foundation
import Networking

enum ChatGPTRoles: String {
    case assistant
    case user
    case system
}

enum ChatGPTModel: String {
    case chatGPT3Turbo = "gpt-3.5-turbo-1106"
    case chatGPT4 = "gpt-4-1106-preview"
}

struct SendMessageModel {
    let role: String
    let chatModel: ChatGPTModel
    let content: String
    
    init(role: ChatGPTRoles, chatModel: ChatGPTModel, content: String) {
        self.role = role.rawValue
        self.chatModel = chatModel
        self.content = content
    }
}

extension ChatGPTSendRequest {
    init(model: SendMessageModel) {
        self.init(model: model.chatModel.rawValue,
                  temperature: Constants.defaultTemperature,
                  messages: [.init(role: model.role, content: model.content)],
                  stream: true)
    }
}
