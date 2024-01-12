//
//  AnalyticsService.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 12.01.2024.
//

import FirebaseAnalytics

enum AnalyticsEvents: String {
    case translateAdded
    case gptRequest
    case clearTapped
    case newPathTapped
    case optionsTapped
    case paywallOpened
    case subscriptionSelected
    case buyButtonTapped
    case choosePath
}

final class AnalyticsService {
    static func sendEvent(_ event: AnalyticsEvents) {
        Analytics.logEvent(event.rawValue, parameters: nil)
    }
}
