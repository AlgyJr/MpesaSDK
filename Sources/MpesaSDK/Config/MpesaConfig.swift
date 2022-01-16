//
//  MpesaConfig.swift
//  
//
//  Created by ALgy Aly on 15/01/22.
//

import Foundation

class MpesaConfig {
    let apiHost  : String?
    let apiKey   : String?
    let publicKey: String?
    
    init(apiHost: String, apiKey: String, publicKey: String) {
        self.apiHost   = apiHost
        self.apiKey    = apiKey
        self.publicKey = publicKey
    }
}
