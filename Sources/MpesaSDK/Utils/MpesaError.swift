//
//  MpesaError.swift
//  
//
//  Created by ALgy Aly on 17/01/22.
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

public enum MpesaError: Error {
    case invalidApiAddress
    case invalidURL
    case invalidToken
    case unableToEncode
    case outputError(String)
}

extension MpesaError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidApiAddress:
            return NSLocalizedString("Invalid API Address", comment: "")
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "")
        case .invalidToken:
            return NSLocalizedString("Bad API Key or Public Key", comment: "")
        case .unableToEncode:
            return NSLocalizedString("Unable to encode payment request to JSON", comment: "")
        case .outputError(let output):
            return NSLocalizedString("Failed to process payment: \(output)", comment: "")
        }
    }
}
