//
//  MpesaManager.swift
//  
//
//  Created by ALgy Aly on 15/01/22.
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

public class MpesaManager: MpesaService {
    private let config        : MpesaConfig
    private let networkManager: NetworkManager
    private let keyGenerator  : KeyGenerator
    
    init(config: MpesaConfig, networkManager: NetworkManager = NetworkManager(), keyGenerator: KeyGenerator = KeyGeneratorImp()) {
        self.config         = config
        self.networkManager = networkManager
        self.keyGenerator   = keyGenerator
    }
    
    public init(config: MpesaConfig) {
        self.config         = config
        self.networkManager = NetworkManager()
        self.keyGenerator   = KeyGeneratorImp()
    }
    
    /// The C2B API Call is used as a standard customer-to-business transaction. Funds from the customer’s mobile money wallet will be deducted and be transferred to the mobile money wallet of the business. To authenticate and authorize this transaction, M-Pesa Payments Gateway will initiate a USSD Push message to the customer to gather and verify the mobile money PIN number. This number is not stored and is used only to authorize the transaction.
    /// - Parameters:
    ///     - paymentRequest: transaction payment request object
    public func c2bPayment(paymentRequest: PaymentRequest, completion: @escaping (Result<PaymentResponse, Error>) -> Void) {
        // Create URL
        guard let url = URL(string: "https://\(config.apiAddress):18352/ipg/v1x/c2bPayment/singleStage/") else {
            NSLog(MpesaError.invalidURL.localizedDescription)
            completion(.failure(MpesaError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 90)
        
        // Specify the body
        guard let data = try? JSONEncoder().encode(paymentRequest) else {
            NSLog(MpesaError.unableToEncode.localizedDescription)
            completion(.failure(MpesaError.unableToEncode))
            return
        }
        
        request.httpBody = data
        
        // Set request type
        request.httpMethod = "POST"
        
        buildRequest(request: &request, data: data, completion: { data, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(data as! PaymentResponse))
            return
        })
    }
    
    /// The B2C API Call is used as standard business-to-customer transaction. Funds from the business' mobile money wallet will be deducted and transferred to the mobile money wallet of the third party customer.
    /// - Parameters:
    ///     - paymentRequest: transaction payment request object
    public func b2cPayment(paymentRequest: PaymentRequest, completion: @escaping (Result<PaymentResponse, Error>) -> Void) {
        // Create URL
        guard let url = URL(string: "https://\(config.apiAddress):18352/ipg/v1x/b2cPayment/") else {
            NSLog(MpesaError.invalidURL.localizedDescription)
            completion(.failure(MpesaError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 90)
        
        // Specify the body
        guard let data = try? JSONEncoder().encode(paymentRequest) else {
            NSLog(MpesaError.unableToEncode.localizedDescription)
            completion(.failure(MpesaError.unableToEncode))
            return
        }
        
        request.httpBody = data
        
        // Set request type
        request.httpMethod = "POST"
        
        buildRequest(request: &request, data: data, completion: { data, error in
            if let error = error {
                completion(.failure(error))
            }
            
            completion(.success(data as! PaymentResponse))
        })
    }
    
    // MARK: Functions
    private func buildRequest(request: inout URLRequest, data: Data, completion: @escaping (Any?, Error?) -> Void) {
        // Generate token
        guard let token = try? keyGenerator.generateBearerToken(publicKey: config.publicKey, apiKey: config.apiKey) else {
            NSLog(MpesaError.invalidToken.localizedDescription)
            completion(nil, MpesaError.invalidToken)
            return
        }
        
        // Specify the headers
        let headers = getHeaders(authorization: token)
        request.allHTTPHeaderFields = headers
        
        networkManager.makeRequest(with: request, decode: PaymentResponse.self, completionHandler: { data, error in
            if let data = data as? Data, let error = error {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let outputError = json["output_error"] as? String {
                            NSLog(outputError)
                            completion(nil, MpesaError.outputError(outputError))
                        } else {
                            NSLog(error.localizedDescription)
                            completion(nil, error)
                        }
                        return
                    }
                } catch {
                    completion(nil, error)
                    return
                }
            }
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let data = data {
                completion(data, nil)
                return
            }
        })
    }
    
    /// Specify necessary headers
    private func getHeaders(authorization: String) -> [String: String] {
        let headers = [
            "Content-Type" : "application/json",
            "Authorization": authorization,
            "Origin"       : "*"
        ]
        
        return headers
    }
}
