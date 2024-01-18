//
//  FeatureModel.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 21.12.2023.
//

import Foundation

enum Features: CaseIterable {
    case unlimitedTranslates
    case chatGPT
    
    var title: String {
        switch self {
        case .unlimitedTranslates:
            return .unlimitedTranslates
        case .chatGPT:
            return .freeGptUsage
        }
    }
}
