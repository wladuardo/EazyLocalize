//
//  OptionsViewModel.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 22.12.2023.
//

import Foundation
import AppKit

final class OptionsViewModel: NSObject, ObservableObject {
    @Published var isLoading: Bool = false
    @Published var selectedOption: Options?
    
    private let sharingService: NSSharingService?
    
    override init() {
        self.sharingService = .init(named: .composeEmail)
        super.init()
        self.sharingService?.delegate = self
    }
    
    func buttonAction(_ type: Options) {
        switch type {
        case .contact:
            contactSupportAction()
        default:
            selectedOption = type
        }
    }
    
    func contactSupportAction() {
        sharingService?.recipients = ["kovalskyvk@icloud.com"]
        sharingService?.subject = "EasyLocalize"
        sharingService?.perform(withItems: [])
    }
}

extension OptionsViewModel: NSSharingServiceDelegate {
    func sharingService(_ sharingService: NSSharingService, willShareItems items: [Any]) {
        isLoading = true
    }
    
    func sharingService(_ sharingService: NSSharingService, didShareItems items: [Any]) {
        isLoading = false
    }
}
