//
//  PaymentResponse.swift
//  
//
//  Created by ALgy Aly on 15/01/22.
//

import Foundation

/// Struct that represents the response from the Customer-to-Business (C2B) or Business-to-Customer (B2C) M-Pesa Transactions
/// @responseCode: This gets generated by the iPG platform to indicate the status of the transaction
/// @responseDesc: This gets generated by the iPG platform to indicate the status of the transaction
/// @transactionID: This gets generated by the Mobile Money platform. This is used to query transactions on the Mobile Money Platform
/// @conversactionID: This gets generated by the Mobile Money platform. This is used to query transactions on the Mobile Money Platform
/// @thirdPartyReference: This is the reference of the third party system. When there are queries about transactions, this will usually be used to track a transaction

public struct PaymentResponse: Decodable {
    public let responseCode       : String
    public let responseDesc       : String
    public let transactionID      : String?
    public let conversactionID    : String?
    public let thirdPartyReference: String
    
    public init(responseCode: String, responseDesc: String, transactionID: String?, conversactionID: String?, thirdPartyReference: String) {
        self.responseCode        = responseCode
        self.responseDesc        = responseDesc
        self.transactionID       = transactionID
        self.conversactionID     = conversactionID
        self.thirdPartyReference = thirdPartyReference
    }
    
    enum CodingKeys: String, CodingKey {
        case responseCode        = "output_ResponseCode"
        case responseDesc        = "output_ResponseDesc"
        case transactionID       = "output_TransactionID"
        case conversactionID     = "output_ConversationID"
        case thirdPartyReference = "output_ThirdPartyReference"
    }
}
