//
//  RSAHelper.swift
//  
//
//  Created by ALgy Aly on 17/01/22.
//

import Foundation

internal class RSAHelper {
    
    /// Encrypt the given String with RSA algorithm
    /// - Parameters:
    ///     - apiKey:  String to be encrypted
    ///     - publicKey: Public key to encrypt
    /// - Returns: Encrypted String (token)
    static func encrypt(apiKey: String, publicKey: RSAPublicKey) -> String {
        var error: Unmanaged<CFError>?
        
        let data = Data(apiKey.utf8)
        
        let encryptedData = SecKeyCreateEncryptedData(publicKey.key, .rsaEncryptionPKCS1, data as CFData, &error)! as Data
        
        return encryptedData.base64EncodedString()
    }
}

extension String {
    func convertToCorrectFormat() -> String {
        let keyArray = self.components(separatedBy: "\n")
        
        var keyOutput: String = ""
        
        for item in keyArray {
            if !item.contains("-----") {
                keyOutput += item
            }
        }
        return keyOutput
    }
}
