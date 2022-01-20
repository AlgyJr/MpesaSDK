//
//  KeyGenerator.swift
//  
//
//  Created by ALgy Aly on 15/01/22.
//

import Foundation

internal class KeyGenerator {
    func generateBearerToken(config: MpesaConfig) throws -> String? {
        assert(config.apiKey != nil, "API Key should not be nil")
        assert(config.publicKey != nil, "Public Key should not be nil")
        
        let publicKey = RSAPublicKey(pemEncoded: config.publicKey!)
        
        let token = RSAHelper.encrypt(apiKey: config.apiKey!, publicKey: publicKey)
        return "Bearer \(token)"
    }
}
