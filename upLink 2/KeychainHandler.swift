//
//  KeychainHandler.swift
//  upLink 2
//
//  Created by Anton Bryhagen on 2024-09-30.
//

import Foundation

class KeychainHandler{
    func saveToKeychain(token: String){
        let tokenData = token.data(using: .utf8)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "jwtToken",
            kSecValueData as String: tokenData!,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if (status == errSecSuccess){
            print("Token saved to keychain")
        }else{
            print("Failed to save token")
        }
    }
    
    func getFromKeychain() -> String?{
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "jwtToken",
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var tokenData: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &tokenData)
        
        if status == errSecSuccess {
            if let data = tokenData as? Data,
               let token = String(data: data, encoding: .utf8) {
                return token
            }
        }else {
            print("Error getting token from keychain")
        }
        return nil
    }
}
