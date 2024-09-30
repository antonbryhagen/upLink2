//
//  KeychainHandler.swift
//  upLink 2
//
//  Created by Anton Bryhagen on 2024-09-30.
//

import Foundation

class KeychainHandler{
    func saveToKeychain(key: String, value: String){
        let valueData = value.data(using: .utf8)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: valueData!,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if (status == errSecSuccess){
            print("Value \(key) saved to keychain")
        }else{
            print("Failed to save value \(key)")
        }
    }
    
    func getFromKeychain(key: String) -> String?{
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var valueData: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &valueData)
        
        if status == errSecSuccess {
            if let data = valueData as? Data,
               let value = String(data: data, encoding: .utf8) {
                return value
            }
        }else {
            print("Error getting value \(key) from keychain")
        }
        return nil
    }
}
