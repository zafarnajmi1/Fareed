//
//  LoginVC.swift
//  Servent
//
//  Created by MAC MINI on .
//  Copyright © 2018. All rights reserved.
//

import UIKit
import libPhoneNumber_iOS
import GoogleSignIn
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit


class LoginVC: BaseViewController , UITableViewDelegate , UITableViewDataSource, GIDSignInUIDelegate, GIDSignInDelegate{
    var isAccept_TC :Bool = false
    var selected_country_code = "+968"
    
    var isBookingPush = false
    
    @IBOutlet weak var imgViewBack: UIImageView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var lblText2: UITextView!
    @IBOutlet weak var lblAgree: UILabel!
    @IBOutlet weak var lblTerms: UILabel!
    @IBOutlet weak var btnNExt: UIButton!
    
    var selected_country_code_text = "OM"
    @IBOutlet weak var selecte_country_text: UILabel!
    @IBOutlet weak var TF_Search_Country: UITextField!
    @IBOutlet weak var TF_phone: UITextField!
    @IBOutlet weak var selected_country: UIImageView!
    var country : [Country] =  [Country]()
    @IBOutlet weak var country_tbl_view: UITableView!
    @IBOutlet weak var blur_view: UIButton!
    @IBOutlet weak var select_country_view: RoundView!
    @IBOutlet weak var terms_condition_checkbox_img: UIImageView!
    
    @IBOutlet weak var lblOR: UILabel!
    @IBOutlet weak var lblViewLeft: UIView!
    @IBOutlet weak var lblViewRight: UIView!
    @IBOutlet weak var lblSocialLogin: UIStackView!
    
    var is_social_login = false
    var token = ""
    
    fileprivate func getAllCountries() {
        DispatchQueue.main.async {
           
            self.country = self.getCountryList()
            self.selected_country_code = self.getCountryCallingCode(countryRegionCode: Locale.current.regionCode!)
            self.selected_country_code_text = Locale.current.regionCode!
            self.selecte_country_text.text = self.selected_country_code_text + " " + self.selected_country_code
            let selectedCountry = self.selected_country_code_text
            
            print("Selected Country = \(selectedCountry)")
            let bundle = "assets.bundle/"
            if let img : UIImage = UIImage(named: bundle + (self.selected_country_code_text.lowercased()) + ".png", in: Bundle.main, compatibleWith: nil){
                
                self.selected_country.image = img
            }
            
            
            print(self.getCountryCallingCode(countryRegionCode: Locale.current.regionCode!))
            self.country_tbl_view.register(UINib(nibName: "CountryCell", bundle: nil), forCellReuseIdentifier: "CountryCell")
            self.country_tbl_view.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.terms_condition_checkbox_img.image = UIImage.init(named: "uncheckselectedcheckbox")
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
      self.blur_view.isHidden = true
        self.TF_Search_Country.delegate = self
        
        TF_Search_Country.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)

        getAllCountries()
         
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
                self.country.removeAll()
                if(textField.text?.count ?? 0 == 0){
        
                    self.country = self.getCountryList()
                }else{
        
                    var newText = ""
                    if textField.text?.count ?? 0 > 0 {
        
                        newText = textField.text!
                            //+ string
                        for cn in self.getCountryList(){
                            let str : String = (newText.lowercased())
                            if cn.country_name.lowercased().range(of: str) != nil {
                                self.country.append(cn)
                            }else if cn.country_code.lowercased().range(of: str) != nil{
                                self.country.append(cn)
                            }else if cn.country_code_text.lowercased().range(of: str) != nil{
                                self.country.append(cn)
                            }
                        }
        
                    }else {
        
                        let name: String = textField.text!
                        let truncated = String(name[..<name.endIndex])
        
                        for cn in self.getCountryList(){
                            let str : String = (truncated.lowercased())
                            if cn.country_name.lowercased().range(of: str) != nil {
                                self.country.append(cn)
                            }else if cn.country_code.lowercased().range(of: str) != nil{
                                self.country.append(cn)
                            }else if cn.country_code_text.lowercased().range(of: str) != nil{
                                self.country.append(cn)
                            }
                        }
                    }
                }
                self.country_tbl_view.reloadData()
            }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
            self.TF_phone.textAlignment = .right
            self.TF_Search_Country.textAlignment = .right
            
        }else{
            self.TF_phone.textAlignment = .left
            self.TF_Search_Country.textAlignment = .left
        }
        self.lblOR.text = "OR".localized
        self.lblCountry.text = "Select a country".localized
        self.TF_Search_Country.placeholder = "Search".localized
        self.lblHeading.text = "Login".localized
        self.lblText.text = "Fareed Services".localized //"Cleaning & Maintenance Services".localized
        self.lblText2.text = "Please enter your mobile number to link it with your order".localized
        self.lblAgree.text = "Agree to ".localized
        self.lblTerms.text = "Terms & Conditions".localized
        self.TF_phone.placeholder = "Phone".localized
        self.btnNExt.setTitle("NEXT".localized, for: .normal)
        
//        DispatchQueue.main.async {
//            self.country = self.getCountryList()
//            self.selected_country_code = self.getCountryCallingCode(countryRegionCode: Locale.current.regionCode!)
//            self.selected_country_code_text = Locale.current.regionCode!
//            self.selecte_country_text.text = self.selected_country_code_text + " " + self.selected_country_code
//            let selectedCountry = self.selected_country_code_text
//
//            print("Selected Country = \(selectedCountry)")
//            let bundle = "assets.bundle/"
//            if let img : UIImage = UIImage(named: bundle + (self.selected_country_code_text.lowercased()) + ".png", in: Bundle.main, compatibleWith: nil){
//
//                self.selected_country.image = img
//            }
//
//
//            print(self.getCountryCallingCode(countryRegionCode: Locale.current.regionCode!))
//            self.country_tbl_view.register(UINib(nibName: "CountryCell", bundle: nil), forCellReuseIdentifier: "CountryCell")
//            self.country_tbl_view.reloadData()
//        }
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first {
//            if (touch.view == self.select_country_view || touch.view == self.blur_view) {
//                self.blur_view.isHidden = true
//                self.select_country_view.isHidden = true
//
//            }
//        }
//    }
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
    @IBAction func OnClickBlurButton(_ sender: Any){
        
        self.blur_view.isHidden = true
        self.select_country_view.isHidden = true
        
    }
    @IBAction func OnClickBack(_ sender: Any) {
        
        if is_social_login == true
        {
            is_social_login = false
            token = ""
            DataManager.sharedInstance.logoutUser()
            
            self.lblOR.isHidden = false
            self.lblViewLeft.isHidden = false
            self.lblViewRight.isHidden = false
            self.lblSocialLogin.isHidden = false
        }
        else
        {
//            if self.isBookingPush {
//                self.Back()
//            }else if DataManager.sharedInstance.user != nil {
                self.Back()
//            }else {
//                self.PushView(nameViewController: "HomeVC", nameStoryBoard: "Main")
//            }
        }
    }
    
    
    @IBAction func SelectCountryCode(_ sender: Any) {
        self.blur_view.isHidden = false
        self.select_country_view.isHidden = false
    }
    
    
    //self.showLoadingView(parentView.view)
    
    @IBAction func Next_btn_click(_ sender: Any) {
//        if self.TF_phone.text == "0" { // Simple User
//            self.TF_phone.text = "37123456"
//            self.selected_country_code = "+971"
//        }else if self.TF_phone.text == "1" { // Cleaner company
//            self.TF_phone.text = "37876541"
//            self.selected_country_code = "+971"
//        }else if self.TF_phone.text == "2" { // Maintenance company
//            self.TF_phone.text = "37897895"
//            self.selected_country_code = "+971"
//        }
       
        if(self.TF_phone.text?.count == 0){
            self.ShowErrorAlert(message: "Invalid Phone".localized)
        } else if(self.TF_phone.text!.count <= 7){
            self.ShowErrorAlert(message: "Please Enter a valid Phone Number".localized)
        }else if (self.isAccept_TC == false ) {
            self.ShowErrorAlert(message: "Required Accepting Terms & Conditions".localized)
        }else{
                      self.showLoading()
            
                    let param : [String : AnyObject] = ["mobile" : "\(self.selected_country_code)\(self.TF_phone.text!)" as AnyObject]
                    NetworkManager.post(WebServiceName.RegisterPhone.rawValue, isLoading: true, withParams: param, withToken: false, onView: self, hnadler: { (response) in
                        self.hideLoading()
                        print(response)
                        
                        if(self.is_social_login == true)
                        {
                            if(response?["status_code"] as! Int  == 200)
                            {
                                self.hideLoading()
                                if let data  = response?["data"] as? [String : Any]
                                {
                                    if(data["email_verified"] as! Int  == 1)
                                    {
                                        
                                        print(response)
                                    }
                                    else
                                    {
                                        self.hideLoading()
                                         print(response)
                                        
                                        let dict = [String:AnyObject]()
                                        let userMain = User(json: dict)
                                        userMain.session_token = self.token
                                        userMain.mobile = "\(self.selected_country_code)\(self.TF_phone.text!)"
                                        DataManager.sharedInstance.user = userMain
                                        DataManager.sharedInstance.saveUserPermanentally()
                                        
                                        let verfication_code_VC = self.storyboard?.instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
                                        verfication_code_VC.isBookingPush = self.isBookingPush
                                        verfication_code_VC.phone_number = self.selected_country_code + "\(self.TF_phone.text ?? "")"
                                        verfication_code_VC.is_social_login = true
                                        
                                        self.navigationController?.pushViewController(verfication_code_VC, animated: true)
                                    }
                                }
                                else
                                {
                                    self.hideLoading()
                                    self.ShowErrorAlert(message: response?["message"] as! String )
                                }
                            }
                            else
                            {
                                self.hideLoading()
                                self.ShowErrorAlert(message: response?["message"] as! String )
                            }
                        }
                        else
                        {
                            if(response?["status_code"] as! Int  == 200)
                            {
                                if let data  = response?["data"] as? [String : Any]
                                {
                                    if(data["email_verified"] as! Int  == 1)
                                    {
                                        let login_password = self.storyboard?.instantiateViewController(withIdentifier: "LoginPasswordVC") as! LoginPasswordVC
                                        login_password.isBookingPush = self.isBookingPush
                                        login_password.phone_number = self.selected_country_code + "\(self.TF_phone.text ?? "22345678")"
                                        login_password.user_email = data["email"] as? String ?? "test"
                                        self.navigationController?.pushViewController(login_password, animated: true)
                                    }else{
                                        let dict = [String:AnyObject]()
                                        let userMain = User(json: dict)
                                        userMain.session_token = response?["token"] as! String
                                        userMain.mobile = "\(self.selected_country_code)\(self.TF_phone.text!)"
                                        DataManager.sharedInstance.user = userMain
                                        DataManager.sharedInstance.saveUserPermanentally()
                                        let verfication_code_VC = self.storyboard?.instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
                                        verfication_code_VC.phone_number = self.selected_country_code + "\(self.TF_phone.text ?? "")"
                                        verfication_code_VC.is_social_login = false
                                        self.navigationController?.pushViewController(verfication_code_VC, animated: true)
                                    }
                                }else {
                                    self.hideLoading()
                                    self.ShowErrorAlert(message: response?["message"] as! String )
                                }
                            }else{
                                self.hideLoading()
                                self.ShowErrorAlert(message: response?["message"] as! String )
                            }
                        }
                    })
          
        }
    }
    
    @IBAction func Term_Condition_Button_Click(_ sender: Any) {
        if(isAccept_TC){
            isAccept_TC = false
            self.terms_condition_checkbox_img.image = UIImage.init(named: "uncheckselectedcheckbox")// #imageLiteral(resourceName: "check_box")
        }else{
            isAccept_TC = true
            self.terms_condition_checkbox_img.image = UIImage.init(named: "selectedcheckbox") // #imageLiteral(resourceName: "check_box_checked")
        }
    }
    
    @IBAction func actn_ToTermsCondition(_ sender: Any) {
        let toTermsAndCondition = self.storyboard?.instantiateViewController(withIdentifier: "TermsConditionVC") as! TermsConditionVC
       
        self.navigationController?.pushViewController(toTermsAndCondition, animated: true)
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//    }
    
    @IBAction func btnFacebookClick(_ sender: Any)
    {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
            
            if error != nil
            {
                print(error?.localizedDescription ?? "Nothing")
            }
            else if (result?.isCancelled)!
            {
                print("Cancel")
            }
            else
            {
                if (result?.grantedPermissions.contains("email"))!
                {
                    self.logInFromFacebook()
                }
                else
                {
                    self.PushViewWithIdentifier(name: "SocialSignUp")
                }
            }
        }
    }
    
    func logInFromFacebook() {
        if (FBSDKAccessToken.current() != nil) {

            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, first_name, last_name, email, gender, picture.type(large)"]).start { (connection, result, error) in
                
                if error != nil
                {
                    print(error?.localizedDescription ?? "Nothing")
                    return
                }
                else
                {
                    guard let results = result as? NSDictionary else { return }
                    print(results)
//                    guard let facebookId = results["id"] as? String,
//                        let email = results["email"] as? String,
//                        let fullName = results["name"] as? String else {
//                            return
//                    }
                    
                    //checkIsSocialLogin(check: 0, googleID : googleID)
                    self.socialLogin(type : 1, social_id : (results["id"] as? String)! , name : "", email : "")
                }
            }
        }
    }
    
    @IBAction func btnGoogleClick(_ sender: Any)
    {
        let googleSignIn = GIDSignIn.sharedInstance()
        googleSignIn?.shouldFetchBasicProfile = true
        googleSignIn?.scopes = ["profile", "email"]
        googleSignIn?.delegate = self
        googleSignIn?.signIn()
    }
    
    @IBAction func btnInstaGramClick(_ sender: Any)
    {
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error
        {
            print(error.localizedDescription)
        }
        if error == nil
        {
            self.socialLogin(type : 2, social_id : user.userID, name : user.profile.name, email : user.profile.email)
        }
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        self.country.removeAll()
//        if(textField.text?.count == 0){
//            self.country = self.getCountryList()
//        }else{
//
//            var newText = ""
//            if string.count > 0 {
//                 newText = textField.text! + string
//
//                for cn in self.getCountryList(){
//                    let str : String = (newText.lowercased())
//                    if cn.country_name.lowercased().range(of: str) != nil {
//                        self.country.append(cn)
//                    }
//                }
//
//            }else {
//                var name: String = textField.text!
//                var truncated = name.substring(to: name.index(before: name.endIndex))
//
//                for cn in self.getCountryList(){
//                    let str : String = (truncated.lowercased())
//                    if cn.country_name.lowercased().range(of: str) != nil {
//                        self.country.append(cn)
//                    }
//                }
//
//            }
//
//        }
//        self.country_tbl_view.reloadData()
//        return true;
//    }
    
    func socialLogin(type : Int, social_id : String, name : String, email : String)
    {
        var param = [String : AnyObject]()
        
        if (type == 1) // facebook
        {
            param["facebook_id"] =  social_id as AnyObject
        }
        else if (type == 2) // google
        {
            param["google_id"] =  social_id as AnyObject
            param["full_name"] =  name as AnyObject
            param["email"] =  email as AnyObject
        }
        else if (type == 3) // instagram
        {
            param["instagram_id"] =  social_id as AnyObject
        }
          self.showLoading()
        NetworkManager.post(WebServiceName.SocialLogin.rawValue, isLoading: true, withParams: param, onView: self, hnadler: { (response) in
            print(response)
            self.hideLoading()
            if(response?["status_code"] as! Int  == 200)
            {
                if let data  = response?["data"] as? [String : Any]
                {
                    if(data["email_verified"] as! Int  == 1)
                    {
//                        let login_password = self.storyboard?.instantiateViewController(withIdentifier: "LoginPasswordVC") as! LoginPasswordVC
//                        login_password.isBookingPush = self.isBookingPush
//                        login_password.phone_number = self.selected_country_code + "\(self.TF_phone.text ?? "22345678")"
//                        login_password.user_email = data["email"] as? String ?? "test"
//                        self.navigationController?.pushViewController(login_password, animated: true)
                        
                        let alert = UIAlertController(title: "Alert".localized , message: "Login successful".localized as! String, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: kOKBtnTitle, style: .default)
                        { action in
                            
                            let userMain = User.init(json: response?["data"] as? [String : AnyObject])
                            userMain.session_token = response?["token"] as! String
                            userMain.isLogin = true
                            
//                            userMain.password = self.TF_password.text!
                             userMain.mobile = self.selected_country_code + "\(self.TF_phone.text ?? "")"
                            
                            
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
                            
                            alert.dismiss(animated: true, completion: nil)
                        
                        })
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    else
                    {
                        let alert = UIAlertController(title: "Alert".localized , message: "Please Enter Your Phone Number".localized, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: kOKBtnTitle, style: .default)
                        { action in
                            
                            self.lblOR.isHidden = true
                            self.lblViewLeft.isHidden = true
                            self.lblViewRight.isHidden = true
                            self.lblSocialLogin.isHidden = true
                            
                            self.token = response?["token"] as! String
                            self.is_social_login = true
                            
                            let dict = [String:AnyObject]()
                            let userMain = User(json: dict)
                            
                            userMain.session_token = response?["token"] as! String
                            DataManager.sharedInstance.user = userMain
                            DataManager.sharedInstance.saveUserPermanentally()
                            
                            
                            alert.dismiss(animated: true, completion: nil)
                        })
                        self.present(alert, animated: true, completion: nil)

                    }
                }
                else
                {
                    self.hideLoading()
                    self.ShowErrorAlert(message: response?["message"] as! String )
                }
            }
            else
            {
                self.hideLoading()
                self.ShowErrorAlert(message: response?["message"] as! String )
            }
        })
        
    }
    
    @IBAction func RegisterAccount(_ sender: Any) {
        self.PushViewWithIdentifier(name: "RegisterSelectionVC")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.country.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "CountryCell") as! CountryCell
        cell.country_flag.image = self.country[indexPath.row].img
        cell.name.text = self.country[indexPath.row].country_name
        cell.code.text = self.country[indexPath.row].country_code
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        self.blur_view.isHidden = true
        self.select_country_view.isHidden = true
        self.selected_country_code_text = "\(self.country[indexPath.row].country_code_text)"
        self.selected_country_code = self.country[indexPath.row].country_code
        self.selected_country.image  = self.country[indexPath.row].img
        self.selecte_country_text.text = "\(self.country[indexPath.row].country_code_text) \(self.country[indexPath.row].country_code)"
        
        self.TF_Search_Country.resignFirstResponder()
    }
    
    
    func getCountryCallingCode(countryRegionCode:String)->String{
        
        let prefixCodes = ["AF": "+93", "AE": "+971", "AL": "+355", "AN": "+599", "AS":"+1", "AD": "+376", "AO": "+244", "AI": "+1", "AG":"+1", "AR": "+54","AM": "+374", "AW": "+297", "AU":"+61", "AT": "+43","AZ": "+994", "BS": "+1", "BH":"+973", "BF": "+226","BI": "+257", "BD": "+880", "BB": "+1", "BY": "+375", "BE":"+32","BZ": "+501", "BJ": "+229", "BM": "+1", "BT":"+975", "BA": "+387", "BW": "+267", "BR": "+55", "BG": "+359", "BO": "+591", "BL": "+590", "BN": "+673", "CC": "+61", "CD":"+243","CI": "+225", "KH":"+855", "CM": "+237", "CA": "+1", "CV": "+238", "KY":"+345", "CF":"+236", "CH": "+41", "CL": "+56", "CN":"+86","CX": "+61", "CO": "+57", "KM": "+269", "CG":"+242", "CK": "+682", "CR": "+506", "CU":"+53", "CY":"+537","CZ": "+420", "DE": "+49", "DK": "+45", "DJ":"+253", "DM": "+1", "DO": "+1", "DZ": "+213", "EC": "+593", "EG":"+20", "ER": "+291", "EE":"+372","ES": "+34", "ET": "+251", "FM": "+691", "FK": "+500", "FO": "+298", "FJ": "+679", "FI":"+358", "FR": "+33", "GB":"+44", "GF": "+594", "GA":"+241", "GS": "+500", "GM":"+220", "GE":"+995","GH":"+233", "GI": "+350", "GQ": "+240", "GR": "+30", "GG": "+44", "GL": "+299", "GD":"+1", "GP": "+590", "GU": "+1", "GT": "+502", "GN":"+224","GW": "+245", "GY": "+595", "HT": "+509", "HR": "+385", "HN":"+504", "HU": "+36", "HK": "+852", "IR": "+98", "IM": "+44", "IL": "+972", "IO":"+246", "IS": "+354", "IN": "+91", "ID":"+62", "IQ":"+964", "IE": "+353","IT":"+39", "JM":"+1", "JP": "+81", "JO": "+962", "JE":"+44", "KP": "+850", "KR": "+82","KZ":"+77", "KE": "+254", "KI": "+686", "KW": "+965", "KG":"+996","KN":"+1", "LC": "+1", "LV": "+371", "LB": "+961", "LK":"+94", "LS": "+266", "LR":"+231", "LI": "+423", "LT": "+370", "LU": "+352", "LA": "+856", "LY":"+218", "MO": "+853", "MK": "+389", "MG":"+261", "MW": "+265", "MY": "+60","MV": "+960", "ML":"+223", "MT": "+356", "MH": "+692", "MQ": "+596", "MR":"+222", "MU": "+230", "MX": "+52","MC": "+377", "MN": "+976", "ME": "+382", "MP": "+1", "MS": "+1", "MA":"+212", "MM": "+95", "MF": "+590", "MD":"+373", "MZ": "+258", "NA":"+264", "NR":"+674", "NP":"+977", "NL": "+31","NC": "+687", "NZ":"+64", "NI": "+505", "NE": "+227", "NG": "+234", "NU":"+683", "NF": "+672", "NO": "+47","OM": "+968", "PK": "+92", "PM": "+508", "PW": "+680", "PF": "+689", "PA": "+507", "PG":"+675", "PY": "+595", "PE": "+51", "PH": "+63", "PL":"+48", "PN": "+872","PT": "+351", "PR": "+1","PS": "+970", "QA": "+974", "RO":"+40", "RE":"+262", "RS": "+381", "RU": "+7", "RW": "+250", "SM": "+378", "SA":"+966", "SN": "+221", "SC": "+248", "SL":"+232","SG": "+65", "SK": "+421", "SI": "+386", "SB":"+677", "SH": "+290", "SD": "+249", "SR": "+597","SZ": "+268", "SE":"+46", "SV": "+503", "ST": "+239","SO": "+252", "SJ": "+47", "SY":"+963", "TW": "+886", "TZ": "+255", "TL": "+670", "TD": "+235", "TJ": "+992", "TH": "+66", "TG":"+228", "TK": "+690", "TO": "+676", "TT": "+1", "TN":"+216","TR": "+90", "TM": "+993", "TC": "+1", "TV":"+688", "UG": "+256", "UA": "+380", "US": "+1", "UY": "+598","UZ": "+998", "VA":"+379", "VE":"+58", "VN": "+84", "VG": "+1", "VI": "+1","VC":"+1", "VU":"+678", "WS": "+685", "WF": "+681", "YE": "+967", "YT": "+262","ZA": "+27" , "ZM": "+260", "ZW":"+263"]
        let countryDialingCode = prefixCodes[countryRegionCode]
        return countryDialingCode!
        
    }
}
extension LoginVC : UITextFieldDelegate {
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        self.country.removeAll()
//        if(textField.text?.count ?? 0 == 0){
//
//            self.country = self.getCountryList()
//        }else{
//
//            var newText = ""
//            if string.count ?? 0 > 0 {
//
//                newText = textField.text! + string
//
//                for cn in self.getCountryList(){
//                    let str : String = (newText.lowercased())
//                    if cn.country_name.lowercased().range(of: str) != nil {
//                        self.country.append(cn)
//                    }else if cn.country_code.lowercased().range(of: str) != nil{
//                        self.country.append(cn)
//                    }else if cn.country_code_text.lowercased().range(of: str) != nil{
//                        self.country.append(cn)
//                    }
//                }
//
//            }else {
//
//
//                let name: String = textField.text!
//                let truncated = String(name[..<name.endIndex])
////                let truncated = name.substring(to: name.index(before: name.endIndex))
//
//                for cn in self.getCountryList(){
//                    let str : String = (truncated.lowercased())
//                    if cn.country_name.lowercased().range(of: str) != nil {
//                        self.country.append(cn)
//                    }else if cn.country_code.lowercased().range(of: str) != nil{
//                        self.country.append(cn)
//                    }else if cn.country_code_text.lowercased().range(of: str) != nil{
//                        self.country.append(cn)
//                    }
//                }
//
//            }
//
//        }
//        self.country_tbl_view.reloadData()
//        return true;
//    }
}
