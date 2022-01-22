//
//  PaymentViewController.swift
//  MpesaiOSImplExample
//
//  Created by ALgy Aly on 18/01/22.
//

import UIKit
import MpesaSDK

class ViewController: UIViewController {
    
    // MARK: IBOutlet
    
    // Step 1 View
    @IBOutlet weak var step1View: UIView!
    @IBOutlet weak var serviceProviderImg: UIImageView!
    @IBOutlet weak var serviceProviderNameLbl: UILabel!
    @IBOutlet weak var serviceProviderCodeLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var phoneNumberTxtField: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    
    // Step 2 View
    @IBOutlet weak var processingView: UIView!
    @IBOutlet weak var alertLbl: UILabel!
    @IBOutlet weak var timerLbl: UILabel!
    
    // Success View
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var infoPaymentLbl: UILabel!
    
    // Failed View
    @IBOutlet weak var failedView: UIView!
    
    // MARK: Properties
    var phoneNumber: String = ""
    var amount: Double      = 100.00
    var countdownTimer: Timer!
    var totalTime: Int      = 90
    
    let serviceProviderImageName = "serviceProviderImg"
    let serviceProviderName      = "Vodacom"
    let serviceProviderCode      = "171717"
    let transactionReference     = "T12344C"
    var thirdPartyReference: Int = 0
    
    // MARK: Constants
    let API_ADDRESS = "api.sandbox.vm.co.mz"
    var apiKey   : String = "YOUR_MPESA_API_KEY"
    var publicKey: String = "YOUR_MPESA_PUBLIC_KEY"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeGestures()
        initializeSubViews()
        initializeData()
    }
    
    // To dismiss keyboard on swiping up or down in the view
    func initializeGestures() {
        let swipeUp = UISwipeGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        swipeUp.direction = .up
        
        let swipeDown = UISwipeGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        swipeDown.direction = .down
        
        view.addGestureRecognizer(swipeUp)
        view.addGestureRecognizer(swipeDown)
    }
    
    func initializeSubViews() {
        // Show Step 1 View
        step1View.isHidden = false
        // Hide Processing View
        processingView.isHidden = true
        // Hide Success View
        successView.isHidden = true
        // Hide Failed View
        failedView.isHidden = true
    }
    
    func initializeData() {
        serviceProviderImg.image = UIImage(named: serviceProviderImageName)
        serviceProviderNameLbl.text = serviceProviderName
        serviceProviderCodeLbl.text = serviceProviderCode
        
        amountLbl.text = amount.formatMTCurrency()
    }
    
    func makeTransaction() {
        paymentMpesa() { [self] response, hasSucceed in
            DispatchQueue.main.async {
                // Hide step 2 view
                endTimer()
                
                if hasSucceed {
                    infoPaymentLbl.text = "Your payment of \(amount.formatMTCurrency()) MT was successfully completed"
                    // TODO show Success step View
                    transit(from: processingView, to: successView)
                } else {
                    // TODO show Failed step View
                    transit(from: processingView, to: failedView)
                }
            }
        }
        
        // dismiss keyboard
        view.endEditing(true)
        timerLbl.text = "\(totalTime)"
        
        startTimer()
        
        // Hide step 1 view and Show step Processing view
        transit(from: step1View, to: processingView)
    }
    
    func generateReference() -> Int {
        return Int.random(in: 10000..<19999)
    }
    
    func transit(from: UIView, to: UIView) {
        // Hide
        from.isHidden = true
        // Show
        to.isHidden = false
    }
    
    // MARK: IBAction
    
    @IBAction func payPressed(_ sender: UIButton) {
        // Generate Third Party Reference
        thirdPartyReference = generateReference()
        
        guard let phone = phoneNumberTxtField.text else {
            // show phone number field error to fill it
            errorLbl.text = "Insert the phone number"
            return
        }
        
        if phone.isValidPhone() {
            phoneNumber = phone
            errorLbl.text = ""
        } else {
            // TODO show phone number field error invalid phone number
            errorLbl.text = "Invalid phone number"
            return
        }
        
        phoneNumber.normalizePhoneNumber()
        
        alertLbl.text = "An USSD notification was sent to the number: \(phoneNumber)"
        
        makeTransaction()
    }
    
    @IBAction func retryButton(_ sender: UIButton) {
        // Hide Failed View and show Step 1 View
        transit(from: failedView, to: step1View)
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        // Clear phonenumber field
        phoneNumberTxtField.text = ""
        
        // Hide Success View and show Step 1 View
        transit(from: successView, to: step1View)
    }
    
    // MARK: M-Pesa API Call
    
    func paymentMpesa(completion: @escaping (PaymentResponse?, Bool) -> Void) {
        let config = MpesaConfig(apiAddress: API_ADDRESS, apiKey: apiKey, publicKey: publicKey)
        let service = MpesaRepository(config: config)
        
        let paymentRequest = PaymentRequest(transactionReference: transactionReference, customerMSISDN: phoneNumber, amount: "\(amount)", thirdPartyReference: "\(thirdPartyReference)", serviceProviderCode: serviceProviderCode)
        
        service.c2bPayment(paymentRequest: paymentRequest) { result in
            switch result {
            case .success(let paymentResponse):
                let responseCode = paymentResponse.responseCode
                print(responseCode)
                print(paymentResponse.responseDesc)
                if responseCode == "INS-0" {
                    print("Successs")
                    completion(paymentResponse, true)
                } else {
                    print("No success")
                    completion(paymentResponse, false)
                }
            case .failure(let error):
                completion(nil, false)
                print("Request failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: Timer functions
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        timerLbl.text = "\(totalTime)"
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
            // TIMED OUT
            // show Failed step View
            failedView.isHidden = false
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
        totalTime = 90
    }
}
