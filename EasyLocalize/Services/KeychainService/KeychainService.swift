//
//  KeychainService.swift
//  EasyLocalize
//
//  Created by Владислав Ковальский on 22.12.2023.
//

import Foundation
import Security

final class KeychainService {
    static private let translatesCoundID = "translatesCoundID"
    static private let isFirstLaunchID = "isFirstLaunchID"
    
    @discardableResult
    static func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrSynchronizable as String: false] as [String: Any]
        
        SecItemDelete(query as CFDictionary)
        
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    @discardableResult
    static func load(key: String) -> Data? {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecAttrSynchronizable as String: false] as [String: Any]
        
        var dataTypeRef: AnyObject?
        
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == noErr {
            return dataTypeRef as! Data?
        } else {
            return nil
        }
    }
    
    @discardableResult
    static func remove(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecValueData as String: data ] as [String: Any]
        
        return SecItemDelete(query as CFDictionary)
    }
}

// MARK: Free translates methods
extension KeychainService {
    static func updateFreeTracksCount(with count: Int, isAdding: Bool) {
        let resultData = load(key: translatesCoundID)
        let result = resultData?.to(type: Int.self)
        guard var result else { return }
        
        if isAdding {
            result += count
        } else {
            result -= count
        }
        
        save(key: translatesCoundID,
             data: Data(value: result))
    }
    
    static func getIsFreeTranslatesAvailable() -> Bool {
        let resultData = load(key: translatesCoundID)
        let result = resultData?.to(type: Int.self)
        guard let result else { return false }
        if result > 0 {
            return true
        } else {
            return false
        }
    }
    
    static func setupFreeTranslates() {
        let isFirstLaunchData = load(key: isFirstLaunchID)
        let isFirstLaunch = isFirstLaunchData?.to(type: Bool.self)
        
        guard let isFirstLaunch,
              isFirstLaunch else { return }
        let freeTracks = Data(value: 5)
        save(key: translatesCoundID,
             data: freeTracks)
    }
    
    static func setupIsFirstLaunch() {
        if load(key: isFirstLaunchID) != nil {
            save(key: isFirstLaunchID,
                 data: Data(value: false))
        } else {
            save(key: isFirstLaunchID,
                 data: Data(value: true))
        }
    }
}
