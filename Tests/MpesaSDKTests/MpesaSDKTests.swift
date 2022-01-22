import XCTest
@testable import MpesaSDK

final class MpesaSDKTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
//        XCTAssertEqual(MpesaSDK().text, "Hello, World!")
        let exp = self.expectation(description: "myExpectation")
        
        let apiKey = "wdi46yxgmhav0p9iatoqn5i5ey5ea26t"
        let publicKey = "MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAmptSWqV7cGUUJJhUBxsMLonux24u+FoTlrb+4Kgc6092JIszmI1QUoMohaDDXSVueXx6IXwYGsjjWY32HGXj1iQhkALXfObJ4DqXn5h6E8y5/xQYNAyd5bpN5Z8r892B6toGzZQVB7qtebH4apDjmvTi5FGZVjVYxalyyQkj4uQbbRQjgCkubSi45Xl4CGtLqZztsKssWz3mcKncgTnq3DHGYYEYiKq0xIj100LGbnvNz20Sgqmw/cH+Bua4GJsWYLEqf/h/yiMgiBbxFxsnwZl0im5vXDlwKPw+QnO2fscDhxZFAwV06bgG0oEoWm9FnjMsfvwm0rUNYFlZ+TOtCEhmhtFp+Tsx9jPCuOd5h2emGdSKD8A6jtwhNa7oQ8RtLEEqwAn44orENa1ibOkxMiiiFpmmJkwgZPOG/zMCjXIrrhDWTDUOZaPx/lEQoInJoE2i43VN/HTGCCw8dKQAwg0jsEXau5ixD0GUothqvuX3B9taoeoFAIvUPEq35YulprMM7ThdKodSHvhnwKG82dCsodRwY428kg2xM/UjiTENog4B6zzZfPhMxFlOSFX4MnrqkAS+8Jamhy1GgoHkEMrsT5+/ofjCx0HjKbT5NuA2V/lmzgJLl3jIERadLzuTYnKGWxVJcGLkWXlEPYLbiaKzbJb2sYxt+Kt5OxQqC1MCAwEAAQ=="
        
        let config = MpesaConfig(apiAddress: "api.sandbox.vm.co.mz", apiKey: apiKey, publicKey: publicKey)
        let service = MpesaRepository(config: config)
        
        let paymentRequest = PaymentRequest(transactionReference: "T15315D", customerMSISDN: "258849022333", amount: "500", thirdPartyReference: "11155", serviceProviderCode: "171717")
        
        service.c2bPayment(paymentRequest: paymentRequest) { result in
            switch result {
                case .success(let paymentResponse):
                    let responseCode = paymentResponse.responseCode
                    print(responseCode)
                    // Do something depending on the response code
                    
                    print(paymentResponse.responseDesc)
                    XCTAssertEqual(paymentRequest.thirdPartyReference, paymentResponse.thirdPartyReference)
                case .failure(let error):
                    // Do something depending on the error
                    switch error {
                        case MpesaError.invalidToken:
                            print(MpesaError.invalidToken.rawValue)
                            print("API Key or Public Key incorrect")
                        case MpesaError.invalidURL:
                            print(MpesaError.invalidURL.rawValue)
                            // or
                            print("Invalid URL")
                        default:
                            print("Request failed with error: \(error.localizedDescription)")
                    }
            }
        }
        
        waitForExpectations(timeout: 60, handler: nil)
    }
}
