//
//  MpesaRepository.swift
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

public class MpesaRepository: MpesaService {
    let config: MpesaConfig
    
    public init(config: MpesaConfig) {
        self.config = config
    }
    
    /// The C2B API Call is used as a standard customer-to-business transaction. Funds from the customer’s mobile money wallet will be deducted and be transferred to the mobile money wallet of the business. To authenticate and authorize this transaction, M-Pesa Payments Gateway will initiate a USSD Push message to the customer to gather and verify the mobile money PIN number. This number is not stored and is used only to authorize the transaction.
    /// - Parameters:
    ///     - paymentRequest: transaction payment request object
    public func c2bPayment(paymentRequest: PaymentRequest, completion: @escaping (Result<PaymentResponse, Error>) -> Void) {
        let apiAddress = config.apiAddress
        
        
        // Create URL
        guard let url = URL(string: "https://\(apiAddress):18352/ipg/v1x/c2bPayment/singleStage/") else {
            NSLog("Error generating URL")
            completion(.failure(MpesaError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 90000)
        
        // Generate token
        guard let token = try? KeyGenerator().generateBearerToken(config: config) else {
            NSLog(MpesaError.invalidToken.rawValue)
            completion(.failure(MpesaError.invalidToken))
            return
        }
        
        // Specify the headers
        let headers = getHeaders(authorization: token)
        request.allHTTPHeaderFields = headers
        
        // Specify the body
        guard let data = try? JSONEncoder().encode(paymentRequest) else {
            NSLog(MpesaError.unableToEncode.rawValue)
            completion(.failure(MpesaError.unableToEncode))
            return
        }
        
        request.httpBody = data
        
        // Set request type
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                NSLog(error.localizedDescription)
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                NSLog(MpesaError.missingData.rawValue)
                completion(.failure(MpesaError.missingData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                NSLog(MpesaError.missingData.rawValue)
                completion(.failure(MpesaError.missingData))
                return
            }
            
            do {
                // Parse the JSON data
                let res = try JSONDecoder().decode(PaymentResponse.self, from: data)
                completion(.success(res))
            } catch {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    if let outputError = json?["output_error"] as? String {
                        NSLog(outputError)
                    } else {
                        NSLog(error.localizedDescription)
                    }
                    
                    completion(.failure(error))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    /// Specify necessary headers
    func getHeaders(authorization: String) -> [String: String] {
        let headers = [
            "Content-Type" : "application/json",
            "Authorization": authorization,
            "Origin"       : "developer.mpesa.vm.co.mz"
        ]
        
        return headers
    }
}
