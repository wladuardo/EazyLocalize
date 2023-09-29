//
//  File.swift
//  
//
//  Created by Владислав Ковальский on 22.06.2023.
//

import Foundation

public protocol HTTPClient: AnyObject {
    func sendRequest<T: Decodable>(session: URLSession,
                                   endpoint: any HTTPEndpoint,
                                   responseModel: T.Type) async -> Result<T, HTTPRequestError>
}

public extension HTTPClient {
    func sendRequest<T: Decodable>(session: URLSession = .shared,
                                   endpoint: any HTTPEndpoint,
                                   responseModel: T.Type) async -> Result<T, HTTPRequestError> {
        guard let url = endpoint.url else {
            return .failure(.invalidURL)
        }
        var request: URLRequest = .init(url: url, timeoutInterval: 60)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        request.httpBody = endpoint.body.data
        return await dataTask(with: session, and: request, responseModel: responseModel)
    }

    /// Вспомогательный метод, который делает запрос из готового URLRequest.
    func dataTask<T: Decodable>(with session: URLSession,
                                and request: URLRequest,
                                responseModel: T.Type) async -> Result<T, HTTPRequestError> {
        return await withCheckedContinuation({ continuation in
            let task = session.dataTask(with: request) { [weak self] data, response, error in
                guard let strongSelf = self else {
                    return continuation.resume(returning: .failure(.noResponse))
                }
                return continuation.resume(returning: strongSelf.handlingDataTask(data: data,
                                                                                  response: response,
                                                                                  error: error,
                                                                                  responseModel: responseModel))
            }
            task.resume()
        })
    }

    /// Вспомогательный метод, который обрабатывает ответ от запроса.
    func handlingDataTask<T: Decodable>(data: Data?,
                                        response: URLResponse?,
                                        error: Error?,
                                        responseModel: T.Type) -> Result<T, HTTPRequestError> {
        if let error = error {
            return .failure(.request(localizedDiscription: error.localizedDescription))
        }
        guard let responseCode = (response as? HTTPURLResponse)?.statusCode else {
            return .failure(.noResponse)
        }
        
        switch responseCode {
        case 200...299:
            if responseModel is Data.Type {
                return .success(responseModel as! T)
            }
            
            if let decodedData = data?.decode(model: responseModel) {
                return .success(decodedData)
            } else {
                return .failure(.decode)
            }
            
        case 400:
            if let decodeData = data?.decode(model: ValidatorErrorResponse.self) {
                return .failure(.validator(error: decodeData))
            }
            return .failure(.unexpectedStatusCode(code: responseCode,
                                                  localized: responseCode.localStatusCode))
        case 401:
            return .failure(.unauthorizate)
        default:
            return .failure(.unexpectedStatusCode(code: responseCode,
                                                       localized: responseCode.localStatusCode))
        }
    }
}
