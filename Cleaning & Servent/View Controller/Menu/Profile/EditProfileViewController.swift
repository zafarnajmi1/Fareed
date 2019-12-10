//
//  EditProfileViewController.swift
//  Servent
//
//  Created by waseem on 10/02/2018.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit
import AAPickerView


class EditProfileViewController: BaseViewController{
   let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imgViewBack: UIImageView!
    
    @IBOutlet weak var lbl_Password_HEading : UILabel!
    @IBOutlet weak var lbl_Password_Text : UILabel!
    @IBOutlet weak var btn_Password_Cancel: UIButton!
    @IBOutlet weak var btn_Password_Ok: UIButton!
    @IBOutlet weak var txt_Password_Old : UITextField!
    @IBOutlet weak var txt_Password_New : UITextField!
    @IBOutlet weak var txt_Password_Confirm : UITextField!
    
    
    @IBOutlet weak var lbl_Gender_HEading : UILabel!
    @IBOutlet weak var lbl_Gender_Text: UILabel!
    @IBOutlet weak var lbl_Gender_Value: UILabel!
    @IBOutlet weak var lbl_Gender_Male: UILabel!
    @IBOutlet weak var lbl_Gender_Feamle: UILabel!
    @IBOutlet weak var btn_Gender_Cancel: UIButton!
    @IBOutlet weak var btn_Gender_Ok: UIButton!
    
    
    @IBOutlet weak var lblHEading: UILabel!
    
    @IBOutlet weak var btnLogout: UIButton!
    
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
//    @IBOutlet weak var lbl_popUpHEading: UILabel!
//    @IBOutlet weak var lbl_popUpText: UILabel!
    
    @IBOutlet weak var IMG_User: UIImageView!
    
    @IBOutlet weak var IMG_Gender_female: UIImageView!
    
      @IBOutlet weak var IMG_Gender_male: UIImageView!
    var selectedGender = ""
    
    
    @IBOutlet var TF_Gender : AAPickerView!
    @IBOutlet var TF_PAssword : AAPickerView!
    
    @IBOutlet weak var LBL_userphone: UILabel!
    @IBOutlet var viewChange : UIView!
    @IBOutlet var lbl_ChangePAsswordValue : UILabel!
    @IBOutlet var lblTitlePopUp : UILabel!
    @IBOutlet var lblDiscPopUp : UILabel!
    @IBOutlet var TF_PopUp : UITextField!
    
    @IBOutlet weak var UpdatePasswordView: RoundView!
    //@IBOutlet var imgViewMain : UIImageView!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblEmail : UILabel!
    @IBOutlet var lblEmailMain : UILabel!
    @IBOutlet var lblPhone : UILabel!
    @IBOutlet weak var EditGenderView: UIView!
    var login_user:User!
    override func viewDidLoad() {
        super.viewDidLoad()
         imagePicker.delegate = self
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
            
            txt_Password_New.textAlignment = .right
            txt_Password_Old.textAlignment = .right
            txt_Password_Confirm.textAlignment = .right
        }
        
        login_user = DataManager.sharedInstance.getPermanentlySavedUser()
        setData(user : login_user)
        self.EditGenderView.isHidden = true
        
//        self.lbl_Gender_Value.text = "Gender".localized
//        self.lbl_ChangePAsswordValue.placeholder = "Change Password".localized
        self.lbl_ChangePAsswordValue.text = "Change Password".localized
        self.lbl_Password_Text.text = "Reste your password".localized
        self.lbl_Password_HEading.text = "Edit Password".localized
        self.txt_Password_New.placeholder = "New Password".localized
        self.txt_Password_Old.placeholder = "Current Password".localized
        self.txt_Password_Confirm.placeholder = "Confirm Password".localized
        self.btn_Password_Ok.setTitle("Update".localized, for: .normal)
        self.btn_Password_Cancel.setTitle("Cancel".localized, for: .normal)
        
        self.lbl_Gender_Male.text = "Male".localized
        self.lbl_Gender_Feamle.text = "Female".localized
        self.lbl_Gender_HEading.text = "Edit Gender".localized
        self.lbl_Gender_Text.text = "Please select your gender.".localized
        self.btn_Gender_Ok.setTitle("Update".localized, for: .normal)
        self.btn_Gender_Cancel.setTitle("Cancel".localized, for: .normal)
        
        self.lblHEading.text = "Profile".localized
        self.btnLogout.setTitle("LOGOUT".localized, for: .normal)
        self.btnOK.setTitle("Update".localized, for: .normal)
        self.btnCancel.setTitle("Cancel".localized, for: .normal)
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        
        if (userDefaults.value(forKey: "L") as! String) == "0" {
            
//            Language.language = Language.english
//
//            userDefaults.set("0", forKey: "L")
//            userDefaults.synchronize()
//            IQKeyboardManager.sharedManager().enable = true
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            
        }else {
//            let userDefaults = UserDefaults.standard
//            Language.language = Language.arabic
//            userDefaults.set("1", forKey: "L")
//            userDefaults.synchronize()
//            IQKeyboardManager.sharedManager().enable = true
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        
        
        self.TF_Gender.delegate = self
        self.TF_Gender.pickerType = .string(data: ["Male".localized,"Female".localized])
       // self.TF_Gender.stringPickerData = ["Male".localized,"Female".localized]
        self.TF_Gender.valueDidChange =  { value in
            print("value " , value)
            
            let gender = self.lbl_Gender_Value.text?.lowercased() == "Male".localized ? "male": "female"
            self.APICAll(key: "gender", value: gender)
            
//            self.lbl_Gender_Value.text = value
//            self.TF_Gender.text = ""
        }
        
    }
    func setData(user : User) {
      //  self.lblName.text = user.full_name
       // self.lblEmail.text = user.email
        
        print(user.image)
        
        self.lbl_Gender_Value.text = user.gender.capitalized.localized
        print(user.gender)
        print(self.lbl_Gender_Value.text)
       // self.lblEmail.text = user.email
        self.IMG_User.sd_setImage(with: URL.init(string: user.image)) { (image, error, chache, url) in
            print(url ?? "kk")
        }
        self.lblEmailMain.text = user.email
        self.lblPhone.text = user.full_name
        self.LBL_userphone.text = user.mobile
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnClickChangePassword(_ sender: Any) {
        self.UpdatePasswordView.isHidden = false
    }
    
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
  
    
    @IBAction func OnClickEditImage(_ sender: Any) {
        showMediaChoosingOptions()
//        imagePicker.allowsEditing = false
//        imagePicker.sourceType = .photoLibrary
//        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func Edit_Phone(sender : UIButton){
        self.lblTitlePopUp.text = "Edit Name".localized
        self.lblDiscPopUp.text = "Please Enter your Name".localized
        self.TF_PopUp.text = DataManager.sharedInstance.user?.full_name
        self.TF_PopUp.placeholder = "Name".localized
        self.TF_PopUp.keyboardType = .default
        self.lblDiscPopUp.textColor =  UIColor.darkGray
         self.TF_PopUp.textColor =  UIColor.darkGray
        self.viewChange.isHidden = false
    }
    
    @IBAction func Edit_Email(sender : UIButton){
        self.lblTitlePopUp.text = "Edit Email".localized
        self.lblDiscPopUp.text = "Please Enter your Email".localized
        self.lblDiscPopUp.textColor =  UIColor.darkGray
        self.TF_PopUp.text = DataManager.sharedInstance.user?.email
        self.TF_PopUp.textColor =  UIColor.darkGray
        self.TF_PopUp.placeholder = "Email".localized
        self.TF_PopUp.keyboardType = .emailAddress
        
        self.viewChange.isHidden = false
    }
    
    
    @IBAction func OnClickEditGender(_ sender: Any) {
         self.EditGenderView.isHidden = false
        if(DataManager.sharedInstance.user?.gender == "male".localized){
            self.IMG_Gender_male.image = #imageLiteral(resourceName: "radio_button_check")
            self.IMG_Gender_female.image = #imageLiteral(resourceName: "radio_button_uncheck")
            selectedGender = "male"
        }else{
            self.IMG_Gender_male.image = #imageLiteral(resourceName: "radio_button_uncheck")
            self.IMG_Gender_female.image = #imageLiteral(resourceName: "radio_button_check")
            selectedGender = "female"
        }
    }
    
    
    @IBAction func OnClickGenderPopUPOK(_ sender: Any) {
        self.EditGenderView.isHidden = true
        if(selectedGender == "male"){
            DataManager.sharedInstance.user?.gender = "Male".localized
            self.lbl_Gender_Value.text = DataManager.sharedInstance.user?.gender.capitalized
        }else{
            DataManager.sharedInstance.user?.gender = "Female".localized
            self.lbl_Gender_Value.text = DataManager.sharedInstance.user?.gender.capitalized
        }
//        let gender = self.lbl_Gender_Value.text?.lowercased() == "Male".localized ? "male": "female"
        self.APICAll(key: "gender", value: selectedGender)
    }
    
    @IBAction func btnEditPhoneClick(_ sender: Any)
    {
        self.lblTitlePopUp.text = "Edit Phone".localized
        self.lblDiscPopUp.text = "Please Enter Phone".localized
        self.TF_PopUp.text = DataManager.sharedInstance.user?.mobile
        self.TF_PopUp.placeholder = "Name".localized
        self.TF_PopUp.keyboardType = .default
        self.lblDiscPopUp.textColor =  UIColor.darkGray
        self.TF_PopUp.textColor =  UIColor.darkGray
        self.viewChange.isHidden = false
    }
    
    
    @IBAction func OnClickGenderPopUPCancel(_ sender: Any) {
       self.EditGenderView.isHidden = true
    }
    @IBAction func OnClickGenderMale(_ sender: Any) {
        self.IMG_Gender_male.image = #imageLiteral(resourceName: "radio_button_check")
        self.IMG_Gender_female.image = #imageLiteral(resourceName: "radio_button_uncheck")
        selectedGender = "male"
    }
    
    @IBAction func OnClickPasswordPopUpCancel(_ sender: Any) {
        self.UpdatePasswordView.isHidden = true
        clearPasswordView()
    }
    @IBAction func OnClickPasswordPopUpOK(_ sender: Any) {
        
        if self.txt_Password_Old.text == ""
        {
            self.ShowErrorAlert(message: "Enter Current Password".localized)
        }
        else if self.txt_Password_New.text == ""
        {
            self.ShowErrorAlert(message: "Enter New Password".localized)
        }
        else if self.txt_Password_New.text!.count < 6
        {
            self.ShowErrorAlert(message: "Please Enter Password Above 6 Characters".localized.localized)
        }
        else if self.txt_Password_Confirm.text != self.txt_Password_New.text
        {
            self.ShowErrorAlert(message: "The password confirmation does not match".localized)
        }
        else{
            let params = ["current_password" : txt_Password_Old.text,
                          "password" : txt_Password_New.text,
                          "password_confirmation" : txt_Password_Confirm.text
            ] as [String : AnyObject]
            showLoading()
           
            NetworkManager.post(WebServiceName.ChangePassword.rawValue, isLoading: false, withParams: params, onView: self) { (response) in
                self.hideLoading()
                print("Change Password Response :\(response!)")
                if(response?["status_code"] as! Int  == 200)
                {
//                    print(MainResponse)
                    let userMain = User.init(json: response?["data"] as? [String : AnyObject])
                    userMain.session_token =  (DataManager.sharedInstance.getPermanentlySavedUser()?.session_token)!
                    userMain.isLogin = true
                    let savedUser = DataManager.sharedInstance.getPermanentlySavedUser()
                    savedUser?.email = userMain.email
                    savedUser?.mobile = userMain.mobile
                    savedUser?.full_name = userMain.full_name
                    savedUser?.gender = userMain.gender
                    savedUser?.password = self.txt_Password_New.text!
                    
                    DataManager.sharedInstance.user = savedUser
//                    DataManager.sharedInstance.user = userMain
                    DataManager.sharedInstance.saveUserPermanentally()
                    
                    self.UpdatePasswordView.isHidden = true
                    self.clearPasswordView()
                    self.ShowSuccessAlert(message: response?["message"] as! String)
                }
                else
                {
                    self.hideLoading()
                    self.ShowErrorAlert(message: response?["message"] as! String )
                }
                self.hideLoading()
                
            }
        }
        
        
        
        
//        NetworkManager.post(WebServiceName.Logout.rawValue, isLoading: true, onView: self, hnadler: { (response) in
//            print(response)
//            DataManager.sharedInstance.logoutUser()
//            //            self.PushViewWithIdentifier(name: "LoginVC")
//            //            self.Back()
//            self.PushViewWithIdentifier(name: "HomeVC")
//        })
        
        
        
    }
    func clearPasswordView(){
        self.txt_Password_Old.text = ""
        self.txt_Password_New.text = ""
        self.txt_Password_Confirm.text = ""
    }
    
    @IBAction func OnClickGenderFemale(_ sender: Any) {
        self.IMG_Gender_male.image = #imageLiteral(resourceName: "radio_button_uncheck")
        self.IMG_Gender_female.image = #imageLiteral(resourceName: "radio_button_check")
        selectedGender = "female"
    }
    @IBAction func Done_PopUP(sender : UIButton){
        if self.lblTitlePopUp.text == "Edit Email".localized
        {
            if self.TF_PopUp.text?.count == 0{
                
                self.ShowErrorAlert(message: "Invalid Email".localized)
            }
            else{
                
                DataManager.sharedInstance.user?.email = self.TF_PopUp.text!
                self.TF_PopUp.text = DataManager.sharedInstance.user?.email.capitalized
                self.lblEmailMain.text = DataManager.sharedInstance.user?.email
                
                self.viewChange.isHidden =  true
                self.APICAll(key: "email", value: TF_PopUp.text!)
            }
            
        }
        else if self.lblTitlePopUp.text == "Edit Phone".localized
        {
            if self.TF_PopUp.text?.count == 0{
                self.ShowErrorAlert(message: "Invalid Phone Number".localized)
            }
            else{
                DataManager.sharedInstance.user?.mobile = self.TF_PopUp.text!
                self.TF_PopUp.text = DataManager.sharedInstance.user?.mobile.capitalized
                
                
                
                self.LBL_userphone.text = DataManager.sharedInstance.user?.mobile
                self.viewChange.isHidden =  true
                
                self.APICAll(key: "mobile", value: TF_PopUp.text!)
            }
            
        }
        else  {
            if self.TF_PopUp.text?.count == 0{
                self.ShowErrorAlert(message: "Invalid Name".localized)
            }
            else{
                DataManager.sharedInstance.user?.full_name = self.TF_PopUp.text!
                self.TF_PopUp.text = DataManager.sharedInstance.user?.full_name.capitalized
               
                self.lblPhone.text = DataManager.sharedInstance.user?.full_name
                
                self.viewChange.isHidden =  true
                self.APICAll(key: "full_name", value: TF_PopUp.text!)
            }
            
        }
        
        
        
        
        
//        if self.TF_PopUp.text?.count == 0
//        {
//            if self.lblTitlePopUp.text == "Edit Email".localized
//            {
//                self.ShowErrorAlert(message: "Invalid Email".localized)
//            }
//            else if self.lblTitlePopUp.text == "Edit Phone".localized
//            {
//                self.ShowErrorAlert(message: "Invalid Phone Number".localized)
//            }
//            else  {
//                self.ShowErrorAlert(message: "Invalid Name".localized)
//            }
//
//            return
//        }
//        self.viewChange.isHidden = true
//
//        if self.lblTitlePopUp.text == "Edit Email".localized
//        {
//            self.lblEmailMain.text = self.TF_PopUp.text
//        }
//        else if self.lblTitlePopUp.text == "Edit Phone".localized
//        {
//            self.LBL_userphone.text = self.TF_PopUp.text
//        }
//        else
//        {
//            self.lblPhone.text = self.TF_PopUp.text
//        }
//
//       self.APICAll()
    }
    
    
    func APICAll(key : String = "", value : String = "", image : UIImage? = nil){
        self.showLoading()
        var newPAram = [String : AnyObject]()
        if image == nil {
            newPAram[key] = value as AnyObject
        }
//        else{
//            newPAram = nil
//            
//        }
        
//        print(self.TF_Gender.text)
////        self.lbl_Gender_Value.text = self.TF_Gender.text
//        self.TF_Gender.text = ""
//        newPAram["mobile"] = self.LBL_userphone.text as AnyObject
//        newPAram["full_name"] = self.lblPhone.text as AnyObject
//        newPAram["email"] = self.lblEmailMain.text as AnyObject
//    // newPAram["gender"] = self.lbl_Gender_Value.text?.lowercased() as AnyObject
//        let gender = self.lbl_Gender_Value.text?.lowercased() == "Male".localized ? "male": "female"
//         newPAram["gender"] = gender as AnyObject
       
        
        
        NetworkManager.UploadFiles("user/profile", image: image, imageName: "image", withParams: newPAram, onView: self, completion: { (MainResponse) in
            
            self.hideLoading()
            if(MainResponse?["status_code"] as! Int  == 200)
            {
                print(MainResponse)
                
                let userMain = User.init(json: MainResponse?["data"] as? [String : AnyObject])
                userMain.session_token =  (DataManager.sharedInstance.getPermanentlySavedUser()?.session_token)!
                userMain.isLogin = true
                
                let savedUser = DataManager.sharedInstance.getPermanentlySavedUser()
                savedUser?.email = userMain.email
                savedUser?.mobile = userMain.mobile
                savedUser?.full_name = userMain.full_name
                savedUser?.gender = userMain.gender
                
                
                DataManager.sharedInstance.user = savedUser
                DataManager.sharedInstance.saveUserPermanentally()
                self.ShowSuccessAlertWithNoAction(message: MainResponse?["message"] as! String)
//                self.ShowSuccessAlert(message: MainResponse?["message"] as! String)
            }
            else
            {
                self.ShowErrorAlert(message: MainResponse?["message"] as! String )
            }
          
            
        })
    }
    
    @IBAction func Cancel_PopUP(sender : UIButton){
        self.viewChange.isHidden = true
    }
    
    
    @IBAction func Back_Action(sender : UIButton){
//        for controller in self.navigationController!.viewControllers as Array {
//            if controller.isKind(of: HomeVC.self) {
//                self.navigationController!.popToViewController(controller, animated: false)
//                break
//            }
//        }
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func Logout_Action(sender : UIButton){
        self.showLoading()
        NetworkManager.get(WebServiceName.Logout.rawValue, isLoading: true, onView: self, hnadler: { (response) in
             self.hideLoading()
            print(response)
            DataManager.sharedInstance.logoutUser()
//            self.PushViewWithIdentifier(name: "LoginVC")
//            self.Back()
            self.PushViewWithIdentifier(name: "HomeVC")
        })
       
    }
    
    
    
    override func selectedImage(image: UIImage) {
        self.IMG_User.image = image
        self.APICAll(image: image)
    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
////    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            self.IMG_User.image = pickedImage
//        }
//        dismiss(animated: true, completion: nil)
//
//        self.APICAll()
//    }
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField == TF_Gender {
////            self.OnClickEditGender(UIButton.init())
//            return false
//        }
//
//        return true
//    }
//
//    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
}

extension EditProfileViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == TF_Gender {
            //            self.OnClickEditGender(UIButton.init())
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
