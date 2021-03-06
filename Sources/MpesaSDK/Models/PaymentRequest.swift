//
//  PaymentRequest.swift
//  
//
//  Created by ALgy Aly on 14/01/22.
//
//  MIT License
//
//  Copyright (c) 2022 Algy Ali
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

/// Struct with all the fields required to perfom a Customer-to-Business (C2B) or Business-to-Customer (B2C) transaction Payment to M-Pesa API
/// @transactionReference: This is the reference of the transaction for the customer or business making the transaction. This can be a smartcard number for a TV subscription or a reference number of a utility bill
/// @customerMSISDN: MSISDN of the customer for the transaction
/// @amount: The amount for the transaction
/// @thirdPartyReference: This is the unique reference of the third party system. When there are queries about transactions, this will usually be used to track a transaction
/// @serviceProviderCode: Shortcode of the business where funds will be credited to

public struct PaymentRequest: Encodable {
    public let transactionReference: String
    public let customerMSISDN      : String
    public let amount              : String
    public let thirdPartyReference : String
    public let serviceProviderCode : String
    
    public init(transactionReference: String, customerMSISDN: String, amount: String, thirdPartyReference : String, serviceProviderCode : String) {
        self.transactionReference = transactionReference
        self.customerMSISDN       = customerMSISDN
        self.amount               = amount
        self.thirdPartyReference  = thirdPartyReference
        self.serviceProviderCode  = serviceProviderCode
    }
    
    enum CodingKeys: String, CodingKey {
        case transactionReference = "input_TransactionReference"
        case customerMSISDN       = "input_CustomerMSISDN"
        case amount               = "input_Amount"
        case thirdPartyReference  = "input_ThirdPartyReference"
        case serviceProviderCode  = "input_ServiceProviderCode"
    }
}
