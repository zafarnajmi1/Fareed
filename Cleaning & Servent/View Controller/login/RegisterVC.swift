//
//  RegisterVC.swift
//  Cleaning & Servent
//
//  Created by Apple on 23/10/2018.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit
import DLRadioButton

class RegisterVC: BaseViewController {
    
    var phone_number : String =  ""
    var is_social_login = false
    var isBookingPush = false

    @IBOutlet weak var imgViewBack: UIImageView!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var confirmTxtField: UITextField!
    @IBOutlet weak var radioMale: DLRadioButton!
    @IBOutlet weak var radioFemale: DLRadioButton!
    
    @IBOutlet weak var registerUserBtn: UIButton!
    @IBOutlet weak var registeryourlbl: UITextView!
    @IBOutlet weak var registerlbl: UILabel!
    @IBOutlet weak var selectGenderlbl: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        radioMale.isSelected = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if isArabic(){
            nameTxtField.textAlignment = .right
            emailTxtField.textAlignment = .right
            passwordTxtField.textAlignment = .right
            confirmTxtField.textAlignment = .right
        }else{
            nameTxtField.textAlignment = .left
            emailTxtField.textAlignment = .left
            passwordTxtField.textAlignment = .left
            confirmTxtField.textAlignment = .left
        }
        registerUserBtn.setTitle("Register".localized, for: .normal)
        registerlbl.text = "Register".localized
        selectGenderlbl.text = "Select Gender".localized
        radioMale.setTitle("Male".localized, for: .normal)
        radioFemale.setTitle("Female".localized, for: .normal)
        registeryourlbl.text = "REGISTER YOUR ACCOUNT".localized
        nameTxtField.placeholder = "Name".localized
        emailTxtField.placeholder = "Email".localized
        passwordTxtField.placeholder = "Password".localized
        confirmTxtField.placeholder = "Confirm Password".localized
    }
    
    private func isCheck()->Bool{
        
        guard let name = nameTxtField.text, name.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Name!".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let email = emailTxtField.text, email.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Email!".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        if !email.isValidEmail{
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Valid Email!".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let password = passwordTxtField.text, password.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Password".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        if password.count < 6 {
            let alertView = AlertView.prepare(title: "Error".localized, message: "Please Enter Password Below 6 Characters".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let confirmpassword = confirmTxtField.text, confirmpassword.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Confirm Password".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        if(password != confirmpassword) {
            let alertView = AlertView.prepare(title: "Error".localized, message: "Password do not matched".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    @IBAction func Back(_ sender: Any) {
//        if is_social_login == true
//        {
//            is_social_login = false
////            token = ""
//            DataManager.sharedInstance.logoutUser()
//            
////            self.lblOR.isHidden = false
////            self.lblViewLeft.isHidden = false
////            self.lblViewRight.isHidden = false
////            self.lblSocialLogin.isHidden = false
//        }
//        else
//        {
            DataManager.sharedInstance.logoutUser()
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: HomeVC.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
//        }

    }
    
    @IBAction func Next(_ sender: UIButton){
        if isCheck(){
           APICAll()
        }
    }
    
    func APICAll(){
        self.showLoading()
        var newPAram = [String : AnyObject]()
        let gender = (radioMale.isSelected) ? "male" : "female"
        newPAram["full_name"] = self.nameTxtField.text as AnyObject
        newPAram["email"] = self.emailTxtField.text as AnyObject
        newPAram["gender"] = gender as AnyObject
        newPAram["password"] = self.passwordTxtField.text as AnyObject
        newPAram["password_confirmation"] = self.confirmTxtField.text as AnyObject
            
        NetworkManager.UploadFiles("user/profile", image: UIImage(named: "about")!, withParams: newPAram, onView: self, completion: { (MainResponse) in
            self.hideLoading()
            if(MainResponse?["status_code"] as! Int  == 200){
                print(MainResponse)
                let userMain = User.init(json: MainResponse?["data"] as? [String : AnyObject])
                userMain.session_token =  (DataManager.sharedInstance.getPermanentlySavedUser()?.session_token)!
                userMain.isLogin = true
                DataManager.sharedInstance.user = userMain
                DataManager.sharedInstance.saveUserPermanentally()
//                self.PushViewWithIdentifier(name: "LoginPasswordVC")
                let login_password = self.storyboard?.instantiateViewController(withIdentifier: "LoginPasswordVC") as! LoginPasswordVC
                login_password.isBookingPush = self.isBookingPush
                login_password.phone_number = self.phone_number
                login_password.user_email = self.emailTxtField.text!
                self.navigationController?.pushViewController(login_password, animated: true)
            }
            else{
                self.ShowErrorAlert(message: MainResponse?["message"] as! String )
            }
        })
    }
}

class AlertView {
    
    class func prepare(title: String, message: String, okAction: (() -> ())?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title:kOKBtnTitle, style: .default) { action in
            okAction?()
        }
        
        alertController.addAction(OKAction)
        
        return alertController
    }
    
    class func prepare(title: String, action1 title1: String, action2 title2: String?, message: String, actionOne: (() -> ())?, actionTwo: (() -> ())?, cancelAction: (() -> ())?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let actionOne = UIAlertAction(title: title1, style: .default) { action in
            actionOne?()
        }
        
        alertController.addAction(actionOne)
        
        if let _ = title2 {
            let actionTwo = UIAlertAction(title: title2, style: .cancel) { action in
                actionTwo?()
            }
            
            alertController.addAction(actionTwo)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { action in
            cancelAction?()
        }
        
        alertController.addAction(cancelAction)
        
        return alertController
    }
}

extension String {
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}

