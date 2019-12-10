//
//  LoginPasswordVC.swift
//  Servent
//
//  Created by MAC MINI on .
//  Copyright © 2018. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginPasswordVC: BaseViewController {
    var phone_number : String =  ""
    var user_email : String = ""
    @IBOutlet weak var label_text: UITextView!
    @IBOutlet weak var TF_password: UITextField!
    
    @IBOutlet weak var lblHEading: UILabel!
    @IBOutlet weak var lblText1: UILabel!
    @IBOutlet weak var lblPassword: UIButton!
    
    @IBOutlet weak var btnNExt: UIButton!
    
    @IBOutlet weak var imgViewBack: UIImageView!
    var isBookingPush = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Testing
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
            self.TF_password.textAlignment = .right
        }else{
            self.TF_password.textAlignment = .left
        }
        
        self.lblHEading.text = "Login".localized
        self.lblText1.text = "Fareed Services".localized//"Cleaning & Maintenance Services".localized
        self.lblPassword.setTitle("Forget password?".localized, for: .normal)
        self.btnNExt.setTitle("NEXT".localized, for: .normal)
        //self.label_text.text = "Enter Account Password For".localized + " \n" + phone_number
        self.label_text.text = "ENTER PASSWORD".localized
        self.TF_password.placeholder = "Password".localized
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func ForgetPassword(_ sender: Any) {
        var param = [String : AnyObject]()
        param["email"] =  self.user_email as AnyObject
        self.showLoading()
        NetworkManager.post("user/forgot-password", isLoading: true, withParams: param, onView: self) { (Response) in
            self.hideLoading()
            self.ShowSuccessAlertWithNoAction(message: "we have e-mailed your password reset link!".localized)
        }
        
    }
    @IBAction func Back(_ sender: Any) {
        if DataManager.sharedInstance.user != nil {
            DataManager.sharedInstance.logoutUser()
            self.GotoHome()
            
        }else {
            DataManager.sharedInstance.logoutUser()
            self.Back()
            
        }
        
//        DataManager.sharedInstance.logoutUser()
//        for controller in self.navigationController!.viewControllers as Array {
//            if controller.isKind(of: HomeVC.self) {
//                self.navigationController!.popToViewController(controller, animated: true)
//                break
//            }
//        }
    
    }
    
    @IBAction func Next_btn_Click(_ sender: Any) {
        
        
        
        
        if(self.TF_password.text != ""){
            if((self.TF_password.text?.count)! < 6){
                self.ShowErrorAlert(message: "Password cannot be less than 6 Characters".localized)
            }else{
                var param = [String : AnyObject]()
                param["mobile"] =  phone_number as AnyObject
                param["password"]  =  TF_password.text as AnyObject
                param["fcm_token"]  = (DataManager.sharedInstance.fcm_token ?? "") as AnyObject
                self.showLoading()
                NetworkManager.post(WebServiceName.Login.rawValue, isLoading: true, withParams: param, onView: self, hnadler: { (response) in
                    self.hideLoading()
                    print("Login Response :\(JSON((response?["data"])!))")
                    
                    if(response?["message"] as! String == "Login successful".localized)
                    {
                        let userMain = User.init(json: response?["data"] as? [String : AnyObject])
                        userMain.session_token = response?["token"] as! String
                        userMain.isLogin = true
                        
                        userMain.password = self.TF_password.text!
                        userMain.mobile = self.phone_number
                        
                        
                        DataManager.sharedInstance.user = userMain
                        DataManager.sharedInstance.saveUserPermanentally()
                        
                        if self.isBookingPush
                        {
                            for controller in self.navigationController!.viewControllers as Array {
                                if controller.isKind(of: ComponyDetailVC.self) {
                                    self.navigationController!.popToViewController(controller, animated: false)
                                    break
                                }
                            }
                        }
                        else
                        {
                            if DataManager.sharedInstance.getPermanentlySavedUser()?.user_type == "company"{
                                (UIApplication.shared.delegate as! AppDelegate).isRefreshAfterCancel = true
                                self.PushViewWithIdentifier(name: "HistoryViewController")
                            }else {
                                 if self.appdelegate.viewMove == 2 {
                                    if self.isCompony() {
                                        // Open Client
                                        self.PushView(nameViewController: "ClientVC", nameStoryBoard: "Booking")
                                    }else{
                                        (UIApplication.shared.delegate as! AppDelegate).isRefreshAfterCancel = true
                                        self.PushViewWithIdentifierHome(name: "HistoryViewController")
                                    }
                                }else if self.appdelegate.viewMove == 3 {
                                     self.PushViewWithIdentifierHome(name: "AddressBookVC")
                                }else if self.appdelegate.viewMove == 4 {
                                    if self.isCompony() {
                                        // Open Usr Profile
                                        self.PushViewWithIdentifier(name: "EditProfileViewController")
                                    }else{
                                        self.PushViewWithIdentifierHome(name: "NotificationVC")
                                    }
                                }else if self.appdelegate.viewMove == 5 {
                                    self.PushViewWithIdentifierHome(name: "EditProfileViewController")
                                }else if self.appdelegate.viewMove == 6 {
                                    if self.isCompony() {
                                        // Open Manage Cleaners
                                    }else{
                                        self.PushViewWithIdentifierHome(name: "CompanyInfoViewController")
                                    }
                                }else {
                                     self.PushViewWithIdentifier(name: "HomeVC")
                                }
                                                     
                                
                            }
                        }
                    }
                    else{
                        self.hideLoading()
                        self.ShowErrorAlert(message:  response?["message"] as! String)
                    }
                })
            }
        }else{
            self.ShowErrorAlert(message: "Please Enter Password".localized)
        }
    }
    
}
