//
//  MpesaError.swift
//  
//
//  Created by ALgy Aly on 17/01/22.
//

import Foundation

public enum MpesaError: String, Error {
    case invalidApiAddress = "Invalid API Address"
    case invalidURL        = "Invalid URL"
    case invalidToken      = "API Key or Public Key incorrect"
    case missingData       = "The data couldn't be read because it is missing"
    case unableToEncode    = "Unable to encode payment request to JSON"
    case outputError       = "An error occurred on request"
}
