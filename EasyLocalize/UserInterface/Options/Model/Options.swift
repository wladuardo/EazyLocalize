//
//  Options.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 22.12.2023.
//

import Foundation
import SwiftUI

enum Options: CaseIterable, Identifiable {
    case privacyPolicy
    case termsOfUse
    case contact
    
    var id: UUID {
        .init()
    }
    
    var title: String {
        switch self {
        case .privacyPolicy:
            return .privacyPolicy
        case .termsOfUse:
            return .termsOfUse
        case .contact:
            return .contactSupport
        }
    }
    
    var description: String? {
        switch self {
        case .privacyPolicy:
            return .privacyPolicyDesc
        case .termsOfUse:
            return .termsOfUseDesc
        case .contact:
            return nil
        }
    }
    
    var image: Image {
        switch self {
        case .privacyPolicy:
            return .init(systemName: "person.circle.fill")
        case .termsOfUse:
            return .init(systemName: "doc.plaintext.fill")
        case .contact:
            return .init(systemName: "envelope.circle.fill")
        }
    }
}
