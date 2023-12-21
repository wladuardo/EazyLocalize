//
//  AppError.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 13.10.2023.
//

import Foundation

enum AppError: LocalizedError {
    case noAccess
    case updateError(description: String)
    case translateError(description: String)
    case emptyTextToTranslate
    
    var title: String {
        switch self {
        case .noAccess:
            return .noAccess
        case .updateError:
            return .updateError
        case .translateError:
            return .translateError
        case .emptyTextToTranslate:
            return .emptyTextToTranslate
        }
    }
    
    var description: String {
        switch self {
        case .noAccess:
            return .noAccessDesc
        case .updateError(let description):
            return description
        case .translateError(let description):
            return description
        case .emptyTextToTranslate:
            return .emptyTextToTranslateDesc
        }
    }
}
