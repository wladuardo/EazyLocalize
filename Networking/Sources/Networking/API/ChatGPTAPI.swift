//
//  File.swift
//  
//
//  Created by Владислав Ковальский on 22.06.2023.
//

import Foundation

public protocol IChatGPTAPI {
    func sendMessage(params: ChatGPTSendRequest) async -> Result<ChatGPTSendResponse, HTTPRequestError>
}

public final class ChatGPTAPI: HTTPClient, IChatGPTAPI {
    public func sendMessage(params: ChatGPTSendRequest) async -> Result<ChatGPTSendResponse, HTTPRequestError> {
        return await sendRequest(endpoint: ChatGPTEndpoint.sendMessage(params: params),
                                 responseModel: ChatGPTSendResponse.self)
    }
}
