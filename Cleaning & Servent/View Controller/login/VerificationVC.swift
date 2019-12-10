//
//  VerificationVC.swift
//  Servent
//
//  Created by Jawad ali on 2/10/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit
import SwiftyJSON
class VerificationVC: BaseViewController {
   var phone_number : String =  ""
   var is_social_login = false
    var isBookingPush = false
    @IBOutlet weak var imgViewBack: UIImageView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lbldes: UILabel!

    @IBOutlet weak var label_text: UITextView!
    @IBOutlet weak var TF_verification_code: UITextField!
    //@IBOutlet weak var imgViewBack: UIImageView!
    
    @IBOutlet weak var resend_text: UIButton!
    @IBOutlet weak var next_text: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.lblHeading.text = "Verification".localized
        self.lbldes.text = "Fareed Services".localized //"Cleaning & Maintenance Services".localized
        if self.isArabic() {
           // self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
            self.TF_verification_code.textAlignment = .right
        }else{
            self.TF_verification_code.textAlignment = .left
        }
        self.TF_verification_code.placeholder = "Verfication code".localized
        self.resend_text.setTitle("Resend".localized, for: .normal)
        self.next_text.setTitle("NEXT".localized, for: .normal)
        self.label_text.text = "Please Enter Verification code send to ".localized + "\(phone_number)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func onClick_back(_ sender: Any){
        DataManager.sharedInstance.logoutUser()
        navigationController?.popViewController(animated: true)
    }
    @IBAction func Next(_ sender: Any)
    {
        if(self.TF_verification_code.text != "")
        {
            self.showLoading()
            var param = [String : AnyObject]()
            param["verification_code"] =  self.TF_verification_code.text as AnyObject
            NetworkManager.post(WebServiceName.Verification_Code.rawValue, isLoading: true, withParams: param, onView: self, hnadler: { (response) in
               // print(response)
                self.hideLoading()
                print("Login Response :\(JSON((response?["data"])!))")
                if(response?["status_code"] as! Int  == 200)
                 {
                    if self.is_social_login == true
                    {
                        
                        let userMain = User.init(json: response?["data"] as? [String : AnyObject])
                        userMain.session_token = response?["token"] as! String
                        userMain.isLogin = true
                        
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
                                        self.PushViewWithIdentifier(name: "HistoryViewController")
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
                    else
                    {
                        let register = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
                        
                        register.isBookingPush = self.isBookingPush
                        register.phone_number = self.phone_number
                        
                        self.navigationController?.pushViewController(register, animated: true)
//                       self.PushViewWithIdentifier(name: "RegisterVC")
                    }
                    
                 }
                 else
                 {
                    self.hideLoading()
                    self.ShowErrorAlert(message: response?["message"] as! String )
                 }
            })
         }
    }
    @IBAction func Resend(_ sender: Any) {
        self.showLoading()
        NetworkManager.get(WebServiceName.ResendVerificationCode.rawValue, isLoading: true, onView: self, hnadler: { (response) in
            self.hideLoading()
            print(response)
            if(response?["status_code"] as! Int  == 200){
                self.ShowErrorAlert(message: response?["message"] as! String )
            }else{
                self.hideLoading()
                self.ShowErrorAlert(message: response?["message"] as! String )
            }
        })
    }
}
