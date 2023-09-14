public protocol INetworkService: IChatGPTAPI { }

public final class NetworkService {
    public let chatGPTAPI: IChatGPTAPI
    
    public init() {
        self.chatGPTAPI = ChatGPTAPI()
    }
}

extension NetworkService: INetworkService {
    public func sendMessage(params: ChatGPTSendRequest) async -> Result<ChatGPTSendResponse, HTTPRequestError> {
        return await chatGPTAPI.sendMessage(params: params)
    }
}
