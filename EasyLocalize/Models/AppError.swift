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
            return "Нет разрешения на запись файла"
        case .updateError:
            return "Ошибка обновления файла"
        case .translateError:
            return "Ошибка при получении перевода"
        case .emptyTextToTranslate:
            return "Нечего переводить"
        }
    }
    
    var description: String {
        switch self {
        case .noAccess:
            return "У вас нет разрешения на запись файла \"Localizable.strings\""
        case .updateError(let description):
            return description
        case .translateError(let description):
            return description
        case .emptyTextToTranslate:
            return "Вы не ввели текст который нужно перевести"
        }
    }
}
