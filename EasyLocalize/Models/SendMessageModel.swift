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

struct SendMessageModel {
    let role: String
    let content: String
    
    init(role: ChatGPTRoles, content: String) {
        self.role = role.rawValue
        self.content = content
    }
}

extension ChatGPTSendRequest {
    init(model: SendMessageModel) {
        self.init(model: Constants.defaultModel,
                  temperature: Constants.defaultTemperature,
                  messages: [.init(role: model.role, content: model.content)],
                  stream: true)
    }
}
