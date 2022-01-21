
# M-Pesa SDK

Swift package for M-Pesa API (Mozambique)

Ready Methods/APIs

- [x] C2B
- [ ] B2B
- [ ] B2C
- [ ] TRANSACTION STATUS
- [ ] REVERSAL
## Requisites

- API Key
- Public Key

These keys will be used to generate your access token.

PS: You can get these keys getting an account on the Vodacom Mozambique M-Pesa [website](https://developer.mpesa.vm.co.mz/)
## Usage

Add a Swift package to your project:

1. on Xcode, go to File -> Add Packages...
2. paste the package repository URL (https://github.com/Algy-Jr12/MpesaSDK) into Search Bar
3. Next next next :) and enjoy

Import in your [iOS/macOS/watchOS/tvOS] or plain Swift app.

```swift
import MpesaSDK
```

#### Create an M-pesa service
```swift
let config = MpesaConfig(apiAddress: apiAddress, apiKey: apiKey, publicKey: publicKey)
let service = MpesaRepository(config: config)
```
### C2B API Call

##### Create a payment request
```swift
let paymentRequest = PaymentRequest(
  transactionReference: "transactionReference",
  customerMSISDN: "25884*******",
  amount: "amount",
  thirdPartyReference: "thirdPartyReference",
  serviceProviderCode: "serviceProviderCode"
)
```

##### Perform the network call

```swift
service.c2bPayment(paymentRequest: paymentRequest) { result in
  // TODO handle response
}
```

##### Handle the response

```swift
service.c2bPayment(paymentRequest: paymentRequest) { result in
    switch result {
        case .success(let paymentResponse):
            let responseCode = paymentResponse.responseCode
            print(responseCode)
            // Do something depending on the response code

            print(paymentResponse.responseDesc)
        case .failure(let error):
            // Do something depending on the error
            switch error {
                case MpesaError.invalidToken:
                    print(MpesaError.invalidToken.rawValue)
                    // OR your message
                    print("API Key or Public Key incorrect")
                case MpesaError.invalidURL:
                    print(MpesaError.invalidURL.rawValue)
                    // OR your message
                    print("Invalid URL")
                default:
                    print("Request failed with error: \(error.localizedDescription)")
            }
    }
}
```
## Example/Screenshots :camera_flash:
ASAP...

## License

```
MIT License

Copyright (c) 2022 Algy Ali

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
