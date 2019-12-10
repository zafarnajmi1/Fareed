//
//  PayPalVC.swift
//  HomeMadeSuppliers
//
//  Created by apple on 6/21/19.
//  Copyright © 2019 mytechnology. All rights reserved.
//

import UIKit

class PayPalVC: BaseViewController {
    
    //MARK:-   private properties
    private var environment:String = PayPalEnvironmentSandbox {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    
    
    
    private var payPalConfig = PayPalConfiguration()
    
    
    
    //MARK:-  class public properties
    var paymentId: String?
    var callBack: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configPayPal()
        PayPalMobile.preconnect(withEnvironment: environment)
    }
    
    func configPayPal(){
        payPalConfig.acceptCreditCards = false
        payPalConfig.merchantName = "HomeMadeSuppliers"
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .payPal
        print("PayPal iOS SDK Version: \(PayPalMobile.libraryVersion())")
    }
    
    /*
    func moveToPaypalVC(){
        
        var paypalItems = [PayPalItem]()
        let quantity = cartList.compactMap({$0.quantity}).reduce(0, +)
        let totalProducts = AppSettings.shared.cartItems//cartList.compactMap{$0.product}.count
        let name = "Toal Products: \(totalProducts)"
        let amount = billAmount.usd?.formattedAmount
        //for item in cartList {
        
        let obj = PayPalItem(name: name,
                             withQuantity: 1,
                             withPrice: NSDecimalNumber(string: amount),
                             withCurrency: "USD",
                             withSku: "Hip-0037")
        paypalItems.append(obj)
        
        //}
        
        
        let subtotal = PayPalItem.totalPrice(forItems: paypalItems) //This is the total price of all the items
        let payment = PayPalPayment(amount: subtotal, currencyCode: "USD", shortDescription: "Total Amount", intent: .sale)
        payment.items = paypalItems
        // payment.paymentDetails = paymentDetails
        if payment.processable {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            present(paymentViewController!, animated: true, completion: nil)
        }
        else {
            let msg = "Payment not processalbe: (payment)"
            self.alertMessage(message: msg, btnTitle: "cancel".capitalized.localized) {
                return
            }
            
        }
    }
    */
    func paymentSuccess() {
        
    }
    
}


extension PayPalVC: PayPalPaymentDelegate, PayPalProfileSharingDelegate{

    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController){
        paymentViewController.dismiss(animated: true, completion: nil)
    }

    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment)
    {
        print("PayPal Payment Success !")

        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")

            let dict = completedPayment.confirmation
            print("dict data is ====%@", dict)

            let paymentResultDic = completedPayment.confirmation as NSDictionary
            let dicResponse: AnyObject? = paymentResultDic.object(forKey: "response") as AnyObject?

            let paycreatetime:String = dicResponse!["create_time"] as! String
            let payauid:String = dicResponse!["id"] as! String
            let paystate:String = dicResponse!["state"] as! String
            let payintent:String = dicResponse!["intent"] as! String

            print("id is  --->%@",payauid)
            print("created  time ---%@",paycreatetime)
            print("paystate is ----->%@",paystate)
            print("payintent is ----->%@",payintent)
            
            self.paymentId = payauid
            self.paymentSuccess()
//            self.callBack?()
        })
    }

    func userDidCancel(_ profileSharingViewController: PayPalProfileSharingViewController){
        print("PayPal Profile Sharing Authorization Canceled")
    }

    func payPalProfileSharingViewController(_ profileSharingViewController: PayPalProfileSharingViewController, userDidLogInWithAuthorization profileSharingAuthorization: [AnyHashable : Any]){
        print("PayPal Profile Sharing Authorization Canceled")
    }

}
