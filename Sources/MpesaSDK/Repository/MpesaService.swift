//
//  MpesaService.swift
//  
//
//  Created by ALgy Aly on 15/01/22.
//

import Foundation

protocol MpesaService {
    /// The C2B API Call is used as a standard customer-to-business transaction. Funds from the customer’s mobile money wallet will be deducted and be transferred to the mobile money wallet of the business. To authenticate and authorize this transaction, M-Pesa Payments Gateway will initiate a USSD Push message to the customer to gather and verify the mobile money PIN number. This number is not stored and is used only to authorize the transaction.
    func c2bPayment(paymentRequest: PaymentRequest, completion: @escaping (Result<PaymentResponse, Error>) -> Void)
}
