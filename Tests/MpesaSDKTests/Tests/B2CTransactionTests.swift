//
//  B2CTransactionTests.swift
//  
//
//  Created by ALgy Aly on 15/04/22.
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

import XCTest
@testable import MpesaSDK

class B2CTransactionTests: XCTestCase {
    func testSuccessfullResponse() {
        // Given
        let paymentRequest = PaymentRequest(
            transactionReference: "T25315D",
            customerMSISDN: "258849022333",
            amount: "500",
            thirdPartyReference: "11155",
            serviceProviderCode: "171717"
        )
        let fixtureData = DataFixtures.jsonData("b2c_fixture")
        
        // When
        let networkSession = NetworkSessionMock()
        networkSession.data = fixtureData
        networkSession.error = nil
        
        let networkManager = NetworkManager(session: networkSession)
        let keyGenerator = KeyGeneratorMock()
        let config = MpesaConfig(apiAddress: "api.sandbox.vm.co.mz", apiKey: "", publicKey: "")
        
        let expectedRequestUrl = URL(string: "https://api.sandbox.vm.co.mz:18352/ipg/v1x/b2cPayment/")
        var expectedResults: PaymentResponse?
        var expectedError: Error?
        
        let manager = MpesaManager(config: config, networkManager: networkManager, keyGenerator: keyGenerator)
        
        manager.b2cPayment(paymentRequest: paymentRequest, completion: { response in
                switch response {
                case let .success(result):
                    expectedResults = result
                case let .failure(error):
                    expectedError = error
                }
            }
        )
        
        // Then
        XCTAssert(networkSession.requestUrl == expectedRequestUrl)
        XCTAssertNotNil(expectedResults)
        XCTAssertNil(expectedError)
    }
}
