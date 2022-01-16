//
//  PaymentRequest.swift
//  
//
//  Created by ALgy Aly on 14/01/22.
//

import Foundation

public struct PaymentRequest: Encodable {
    public let transactionReference: String
    public let customerMSISDN      : String
    public let amount              : String
    public let thirdPartyReference : String
    public let serviceProviderCode : String
    
    enum CodingKeys: String, CodingKey {
        case transactionReference = "input_TransactionReference"
        case customerMSISDN       = "input_CustomerMSISDN"
        case amount               = "input_Amount"
        case thirdPartyReference  = "input_ThirdPartyReference"
        case serviceProviderCode  = "input_ServiceProviderCode"
    }
}
