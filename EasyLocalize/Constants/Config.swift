//
//  Config.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 14.09.2023.
//

import Foundation

final class Config {
    static let chatGPTAPIKey = "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"
    static let responseDescription  = ". Отправь ответ в формате Dictionary где ключ это краткое обозначение перевода, а значение - сам перевод. Например [en: text]"
    static let promtInstruction = { (textToTranslate: String) in
        return "Переведи этот текст: '\(textToTranslate)' на"
    }
}
