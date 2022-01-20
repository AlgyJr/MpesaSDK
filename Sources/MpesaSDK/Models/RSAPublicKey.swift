//
//  RSAPublicKey.swift
//  
//
//  Created by ALgy Aly on 17/01/22.
//

import Foundation

internal class RSAPublicKey {
    private(set) var key: SecKey!
    
    init(pemEncoded: String) {
        self.key = createPublicKey(keyString: pemEncoded)
    }
    
    private func createPublicKey(keyString: String) -> SecKey {
        let keyData = Data(base64Encoded: keyString.convertToCorrectFormat())!
        let sizeInBits = keyData.count * 8

        let keyDict: [CFString: Any] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits: NSNumber(value: sizeInBits),
            kSecReturnPersistentRef: true
        ]
        
        var error: Unmanaged<CFError>?
        var key: SecKey? = nil
        
        key = SecKeyCreateWithData(keyData as CFData, keyDict as CFDictionary, &error)
        
        return key!
    }
 }
