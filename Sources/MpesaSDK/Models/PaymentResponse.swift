//
//  PaymentResponse.swift
//  
//
//  Created by ALgy Aly on 15/01/22.
//

import Foundation

public struct PaymentResponse: Decodable {
    public let responseCode       : String
    public let responseDesc       : String
    public let transactionID      : String?
    public let conversactionID    : String?
    public let thirdPartyReference: String
    
    enum CodingKeys: String, CodingKey {
        case responseCode        = "output_ResponseCode"
        case responseDesc        = "output_ResponseDesc"
        case transactionID       = "output_TransactionID"
        case conversactionID     = "output_ConversationID"
        case thirdPartyReference = "output_ThirdPartyReference"
    }
}
