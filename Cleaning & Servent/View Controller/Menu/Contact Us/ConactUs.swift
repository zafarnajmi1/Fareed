//
//  CompanyInfoViewController.swift
//  Servent
//
//  Created by waseem on 21/02/2018.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit


class ConactUs: BaseViewController , UITextViewDelegate {

    @IBOutlet weak var imgViewBack: UIImageView!
    @IBOutlet var txtField_Name : UITextField!
    @IBOutlet var txtField_Phone : UITextField!
    @IBOutlet var txtField_Email : UITextField!
    @IBOutlet var txtView_Message : UITextView!
    
    
    @IBOutlet var lbl_Heading : UILabel!
    @IBOutlet var lbl_Name : UILabel!
    @IBOutlet var lbl_Email : UILabel!
    @IBOutlet var lbl_Phone : UILabel!
    @IBOutlet var lbl_Message : UILabel!
    
    @IBOutlet var btnSubmit : UIButton!

    var fb = ""
    var linkdin = ""
    var insta = ""
    var twitter = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
            txtField_Name.textAlignment = .right
            txtField_Phone.textAlignment = .right
            txtField_Email.textAlignment = .right
            txtView_Message.textAlignment = .right
        }
        else{
            txtField_Name.textAlignment = .left
            txtField_Phone.textAlignment = .left
            txtField_Email.textAlignment = .left
            txtView_Message.textAlignment = .left
        }
        
        self.txtView_Message.text = "Message".localized
        self.lbl_Name.text = "Name".localized
        self.lbl_Email.text = "Email".localized
        self.lbl_Phone.text = "Phone".localized
        self.lbl_Message.text = "Message".localized
        self.lbl_Heading.text = "Contact Us".localized
        self.txtField_Name.placeholder = "Name".localized
        self.txtField_Email.placeholder = "Email".localized
        self.txtField_Phone.placeholder = "Phone".localized
//        self.txtView_Message.text = "Write message".localized
        
        
        self.btnSubmit.setTitle("Submit".localized, for: .normal)
        
        self.txtView_Message.delegate = self
        
        self.txtView_Message.textColor = UIColor.lightGray
        // Do any additional setup after loading the view.
        self.showLoading()
        NetworkManager.get("settings", isLoading: true, onView: self) { (response) in
            print(response)
            self.hideLoading()
            if let data = response?["data"] as? [String:Any] {
                if let pages = data["site_settings"] as? [String:Any]
                {
                    self.twitter = (pages["twitter"] as? String)!
                    self.fb = (pages["facebook"] as? String)!
                    self.insta = (pages["instagram"] as? String)!
                    
                }
            }
            
        }
        
    }

    @IBAction func BAck_Action(sender : UIButton){
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            self.txtView_Message.text = "Message".localized
            self.txtView_Message.textColor = UIColor.lightGray
        }
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Message".localized {
            self.txtView_Message.text = ""
            self.txtView_Message.textColor = UIColor.black
        }
    }
    
    @IBAction func btnTwitterClick(_ sender: Any)
    {
        UIApplication.shared.open(URL(string: self.twitter)! as URL, options: [:], completionHandler: nil)

    }
    
    @IBAction func btnInstagramClick(_ sender: Any)
    {
        UIApplication.shared.open(URL(string: self.insta)! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func btnFacebookClick(_ sender: Any)
    {
        
        print("fb link = \(self.fb)")
        
        UIApplication.shared.open(URL(string: self.fb)! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func btnLinkdinClick(_ sender: Any)
    {
        if let url = URL(string: "https://pk.linkedin.com/") {
                  if UIApplication.shared.canOpenURL(url) {
                      UIApplication.shared.open(url, options: [:], completionHandler: nil)
                  }
              }
        
    }
    
    
    @IBAction func Submit_Action(sender : UIButton){
        if !txtField_Name.hasText {
            self.ShowErrorAlert(message: "Please Enter Name!".localized)
            return
        }
        
        if !txtField_Email.hasText {
            self.ShowErrorAlert(message: "Please Enter Email!".localized)
            return
        }
        
        if(!self.EmailValidation(textField: txtField_Email)){
            self.ShowErrorAlert(message: "Please Enter Valid Email!".localized)
            return
        }
        
        if !txtField_Phone.hasText {
            self.ShowErrorAlert(message: "Please Enter your Phone Number".localized)
            return
        }
        
        if (txtField_Phone.text?.count)! < 10 {
            self.ShowErrorAlert(message: "Invalid Phone Number".localized)
            return
        }
        
       
        
        if txtView_Message.text ==   "Message".localized || txtView_Message.text == ""   {
            self.ShowErrorAlert(message: "Write Message".localized)
            return
        }
        
        
        var paramNew  = [String : AnyObject]()
        paramNew["message_text"] = self.txtView_Message.text as AnyObject
        paramNew["email"] = self.txtField_Email.text as AnyObject
        paramNew["subject"] = self.txtField_Phone.text as AnyObject
        paramNew["full_name"] = self.txtField_Name.text as AnyObject
        
        self.showLoading()
        NetworkManager.post("contact-us", isLoading: true, withParams: paramNew, onView: self) { (MainResponse) in
            print(MainResponse)
            self.hideLoading()
            if MainResponse?["status_code"] as! Int == 200 {
                
//                self.ShowErrorAlert(message: (MainResponse["message"] as! String),AlertTitle: "")
                //"Thank you for contacting us. We will contact you soon. ".localized
                self.ShowSuccessAlert(message: MainResponse?["message"] as! String)
                self.txtView_Message.text = "Message".localized
                self.txtView_Message.textColor = UIColor.lightGray
                self.txtField_Email.text = ""
                self.txtField_Phone.text = ""
                self.txtField_Name.text = ""
            }else {
                self.hideLoading()
            }
            
        }
    }
    
    
}
