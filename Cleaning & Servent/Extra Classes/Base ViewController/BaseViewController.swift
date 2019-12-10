//
//  BaseViewController.swift
//  Wave
//
//  Created by MAC MINI on .
//  Copyright © 2018. All rights reserved.
//

import UIKit
import INSPhotoGallery
import ADEmailAndPassword
import SDWebImage
import AVFoundation
import MBProgressHUD

class BaseViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
	
	let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var screenWidth : CGFloat {
        get{
            return UIScreen.main.bounds.width
        }
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    func OpenBooking(selectedCompony : CompanyModel ,SelectedServices : [Services] ) {
        let storyboard = UIStoryboard(name: "Booking", bundle: nil)
        let viewPush = storyboard.instantiateViewController(withIdentifier: "BookingVC") as! BookingVC
        viewPush.SelectedServices = SelectedServices
        viewPush.SelectedCompany = selectedCompony
        self.navigationController?.pushViewController(viewPush, animated: true)
    }
    
    func isCompony() -> Bool {
        if DataManager.sharedInstance.getPermanentlySavedUser()?.user_type == "company"{
            return true
        }else{
            return false
        }
    }
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            
            completion()
        }
    }
	
	//MARK: Navigation Actions
	//MARK:
	func AddBackButton() {
		let navigation = self.navigationController as! BaseNavigationController
		navigation.addBackButtonOn(self, selector: #selector(BaseViewController.Back))
	}
	
	
	func AddCrossButton(){
		let navigation = self.navigationController as! BaseNavigationController
		let image = UIImage.init(named: "Cross")
		navigation.addRLeftButton(self, selector: #selector(BaseViewController.Dismiss), image:image!.imageResize(sizeChange: CGSize.init(width: 53, height: 25)))

	}
	
    @objc func Back(){
//        for controller in self.navigationController!.viewControllers as Array {
//            if controller.isKind(of: HomeVC.self) {
//                self.navigationController!.popToViewController(controller, animated: false)
//                break
//            }
//        }
        _ = self.navigationController?.popViewController(animated: true)
	}
	
    @objc func Dismiss(){
		self.dismiss(animated: true) {
			
		}
	}
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
	
    func addRightButtonWithtext(selector: Selector , lblText : String , widthValue : Double = 100){
		
		let navigation = self.navigationController as! BaseNavigationController
        navigation.addRightButtonWithTitle(self, selector: selector, lblText: lblText , widthValue : widthValue)
	}
    
    
    func addRightButtonWithImage(selector: Selector , imageMain : UIImage){
        
        let navigation = self.navigationController as! BaseNavigationController
        navigation.addRightButton(self, selector: selector, image: imageMain)
    }
    
    
    func RemoveRigtButton(){
        
        let navigation = self.navigationController as! BaseNavigationController
        navigation.RemoveRightButton(self)
    }
    
    
    
	func UpdateTitle(title : String) {
		
		self.UpdateNavigationColor()
	}
	
	func UpdateNavigationColor() {
		let navigation = self.navigationController as! BaseNavigationController
		navigation.AddBackGroundImage()
	}
	
	func AddMenuButton() {
		let navigation = self.navigationController as! BaseNavigationController
//        navigation.addMenuButtonOn(self, selector: #selector(self.openMenu))
	}
    
    func CheckLogin() -> Bool{
        if DataManager.sharedInstance.getPermanentlySavedUser() == nil || DataManager.sharedInstance.getPermanentlySavedUser()?.session_token == nil ||
            DataManager.sharedInstance.getPermanentlySavedUser()?.session_token == ""  {
            self.PushViewWithIdentifier(name: "LoginVC")
            return false
        }
        return true
    }
   	
	//MARK: Alert Messge
	//MARK:
	func ShowErrorAlert(message : String , AlertTitle : String = "Alert".localized) {
		let alert = UIAlertController(title: AlertTitle , message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: kOKBtnTitle, style: .default) { action in
			alert.dismiss(animated: true, completion: nil)
		})
		self.present(alert, animated: true, completion: nil)
	}
	
    func ShowSuccessAlertWithHome(message : String ) {
        let alert = UIAlertController(title: "Success".localized , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: kOKBtnTitle, style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: HomeVC.self) {
                    self.navigationController!.popToViewController(controller, animated: false)
                    break
                }
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
    
   
    func ShowSuccessAlertWithNoAction(message : String ) {
        let alert = UIAlertController(title: "Success".localized , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: kOKBtnTitle, style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        })
        self.present(alert, animated: true, completion: nil)
    }
   
    
    
	func ShowSuccessAlert(message : String ) {
		let alert = UIAlertController(title: "Success".localized , message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: kOKBtnTitle, style: .default) { [weak self] action in
//            alert.dismiss(animated: true, completion: nil)
			self?.navigationController?.popViewController(animated: true)
		})
		self.present(alert, animated: true, completion: nil)
	}
	
	
	func ShowSuccessAlertWithrootView(message : String ) {
		let alert = UIAlertController(title: "" , message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: kOKBtnTitle, style: .default) { action in
			alert.dismiss(animated: true, completion: nil)
			_ = self.navigationController?.popToRootViewController(animated: true)
		})
		self.present(alert, animated: true, completion: nil)
	}
	
	func ShowSuccessAlertWithViewRemove(message : String ) {
		let alert = UIAlertController(title: "" , message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: kOKBtnTitle, style: .default) { action in
			alert.dismiss(animated: true, completion: nil)
			self.view.removeFromSuperview()
		})
		self.present(alert, animated: true, completion: nil)
	}
	
	func GetViewcontrollerWithName(nameViewController : String) -> UIViewController {
		let viewObj = (self.storyboard?.instantiateViewController(withIdentifier: nameViewController))! as UIViewController
		return viewObj
	}
	
    func validate_phone(value: String) -> Bool {
        let PHONE_REGEX = "\\+(9[976]\\d|8[987530]\\d|6[987]\\d|5[90]\\d|42\\d|3[875]\\d|2[98654321]\\d|9[8543210]|8[6421]|6[6543210]|5[87654321]|4[987654310]|3[9643210]|2[70]|7|1)\\d{1,14}$"
        
        let Phone_Regex =  "^\\+(?:[0-9]●?){6,14}[0-9]$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", Phone_Regex)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
	
	func GetNavigationcontrollerWithName(nameViewController : String) -> BaseNavigationController {
		let viewObj = (self.storyboard?.instantiateViewController(withIdentifier: nameViewController))! as! BaseNavigationController
		return viewObj
	}
	
	func PushViewWithIdentifier(name : String , isanimated : Bool = true) {
		//print(name)
        
        
//        for controller in self.navigationController!.viewControllers as Array {
//            if controller.isKind(of: HomeVC.self) {
//                self.navigationController!.popToViewController(controller, animated: false)
                let viewPush = self.storyboard?.instantiateViewController(withIdentifier: name)
                self.navigationController?.pushViewController(viewPush!, animated: isanimated)
//        self.navigationController?.setViewControllers([viewPush], animated: true)
//                break
//
//            }
//        }

        
		
	}
    
    
    func PushViewWithIdentifierHome(name : String , isanimated : Bool = true) {
        //print(name)
        
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: HomeVC.self) {
                self.navigationController!.popToViewController(controller, animated: false)
                let viewPush = self.storyboard?.instantiateViewController(withIdentifier: name)
                controller.navigationController?.pushViewController(viewPush!, animated: isanimated)
                break
                
            }
        }
        
        
        
    }
    
    func PushCompanyDetail(name : String , isanimated : Bool = true , dataMain : [String : Any]) {

        let viewPush = self.storyboard?.instantiateViewController(withIdentifier: name) as! ComponyDetailVC
        viewPush.dataCompany = dataMain
        self.navigationController?.pushViewController(viewPush, animated: isanimated)
    }
	
    func PushViewWithIdentifierAndStoryboard(view_name : String  , storyboard_name: String , isanimated : Bool = true) {
        let storyboard = UIStoryboard(name: storyboard_name, bundle: nil)
        let viewPush = storyboard.instantiateViewController(withIdentifier: view_name)
        self.navigationController?.pushViewController(viewPush, animated: isanimated)
    }
    
    
    
	func ShowViewWithIdentifier(name : String ) {
		let viewPush = self.storyboard?.instantiateViewController(withIdentifier: name) 
		self.present(viewPush!, animated: true) {
		}
	}
    
    func getTime(milisecond : Int) -> String {
        let mil_int = milisecond * 1000
        let dt = Date(milliseconds: mil_int)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let str_date =  dateFormatter.string(from: dt)
        return str_date
    }
    
    
    func getDateObject(milisecond : Int) -> Date {
        let mil_int = milisecond * 1000
        let dt = Date(milliseconds: mil_int)
        
        return dt
    }
    
    func getDate(milisecond : Int) -> String {
        let mil_int = milisecond * 1000
        let dt = Date(milliseconds: mil_int)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy - hh:mm a"
        let str_date =  dateFormatter.string(from: dt)
        return str_date
    }
    
    func getDateForReview(milisecond : Int) -> String {
        
        let mil_int = milisecond * 1000
        let dt = Date(milliseconds: mil_int)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy - hh:mm a"
        let str_date =  dateFormatter.string(from: dt)
        return str_date
    }
    
    
    func GetDatWithformate(milisecond : Int , formattString : String) -> String {
        
        let mil_int = milisecond * 1000
        let dt = Date(milliseconds: mil_int)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formattString
        let str_date =  dateFormatter.string(from: dt)
        return str_date
    }
    
    
    func GetDAteForBooking(dateMain : Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let str_date =  dateFormatter.string(from: dateMain)
        return str_date
    }
    
    func GetStringFromDate(dateMain : Date , formate : String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        let str_date =  dateFormatter.string(from: dateMain)
        return str_date
    }
    
    
    func getCompanyTime(mainString : String) -> TimeInterval {
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let str_date =  dateFormatter.date(from:mainString)
        return (str_date?.timeIntervalSince1970)!
    }
    
    
    func getTimeInt(mainString : String , Withformate : String , isArabic: Bool = false) -> TimeInterval {
        
        print(Locale.current.languageCode)
    
        
        var identifier = isArabic == false ? "en_US_POSIX" : "ar_DZ"
        
        if isArabic == true && Locale.current.languageCode == "en" {
            identifier = "en_US_POSIX"
        }
        
        if isArabic == false && Locale.current.languageCode == "ar" {
            identifier = "ar_DZ"
        }
        
        
        print("getTimeInt")
        print(mainString)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Withformate
        dateFormatter.locale = Locale(identifier: identifier) //Locale(identifier: "en_US_POSIX")//NSLocale(localeIdentifier: "") as Locale
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let str_date =  dateFormatter.date(from:mainString)
        
        print(str_date)
        return (str_date?.timeIntervalSince1970 ?? 0)
    }
    
    
    func ShowTutorialPages(){
        let helppages = self.storyboard?.instantiateViewController(withIdentifier: "HelpPagesVC")
        self.present(helppages!, animated: false) {
            
        }
    }

	
	// MARK:
	// MARK: Email Validation
	func EmailValidation(textField  : UITextField) -> Bool  {

        
      return  self.EmailValidationOnstring(strEmail: textField.text!)
	}
    
    
    func EmailValidationOnstring(strEmail  : String) -> Bool  {
        
        if strEmail.count == 0 {
            self.ShowErrorAlert(message: Alert.kEmptyCredentails)
            return false
        }else {
            if ADEmailAndPassword.validateEmail(emailId: strEmail) {
                return true
            }else {
                self.ShowErrorAlert(message: Alert.kWrongEmail)
                return false
            }
        }
    }
	
    func getDates() -> [[String : Any]] {
        var dates : [[String : Any]] = [[String : Any]]()
       for x in 0...500 {
            let dt = Calendar.current.date(byAdding: .day, value: x, to: Date())
             let dateFormatterGet = DateFormatter()
             dateFormatterGet.dateFormat = "MMM"
             var single_Date : [String : Any] = [String : Any]()
             single_Date["mnth"] = dateFormatterGet.string(from: dt!)
             dateFormatterGet.dateFormat = "EEE"
             single_Date["day_name"] = dateFormatterGet.string(from: dt!)
             dateFormatterGet.dateFormat = "dd"
             single_Date["day_no"] = dateFormatterGet.string(from: dt!)
             dateFormatterGet.dateFormat = "YYYY-MM-dd hh:mm a"
              single_Date["date"] = dateFormatterGet.string(from: dt!)
            single_Date["dateObj"] =  dt!
              single_Date["isSelected"] = false
             dates.append(single_Date)
        }
        return dates
    }
	// MARK:
	// MARK:Add Menu
	func ShowMenuBaseView(){
		
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushMainView"), object: nil)

	}
	
	
	//MARK:- Custom methods
	func showLoading() {
		self.view.showLoading()
	}
	
	func hideLoading() {
		self.view.hideLoading()
	}
	
	//MARK: Show Media Options
	//MARK:
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        
        
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! String
        if mediaType == "public.image" {
            if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                selectedImage(image: pickedImage)
            }
        }
        else if mediaType == "public.movie"{
            if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL{
                selectedVideo(url: videoUrl)
            }
//            self.imgViewVideo.image = self.getThumbnailFrom(path:self.videoUrl!)
//            self.isvideochoose = true
//            self.btnPlayVideo.isHidden = false
//            self.btnVideo.isHidden = false
        }
        
//        print("Media Type Type :\(type(of: mediaType))")
//        print("Media Type Type :\(mediaType)")
//        if self.isImageSelect {
//            self.imgViewMain.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
//            self.isImagechoose = true
//            self.btnImage.isHidden = false
//        }else {
//            self.videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL
//            self.imgViewVideo.image = self.getThumbnailFrom(path:self.videoUrl!)
//            self.isvideochoose = true
//            self.btnPlayVideo.isHidden = false
//            self.btnVideo.isHidden = false
//        }
        
//        if self.isImageSelect {
//            self.imgViewMain.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
//            self.isImagechoose = true
//            self.btnImage.isHidden = false
//        }else {
//            self.videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL
//            self.imgViewVideo.image = self.getThumbnailFrom(path:self.videoUrl!)
//            self.isvideochoose = true
//            self.btnPlayVideo.isHidden = false
//            self.btnVideo.isHidden = false
//        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func selectedImage(image : UIImage){
        
    }
    func selectedVideo(url : URL){
        
    }
	func showMediaChoosingOptions() {
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.allowsEditing = true
		let photoOptionMenu = UIAlertController(title: "Choose Source".localized, message: kEmptyString, preferredStyle: .actionSheet)
        let libraryAction = UIAlertAction(title: "View Phone Gallery".localized, style: .default, handler: {
			(alert: UIAlertAction!) -> Void in
			imagePicker.sourceType = .photoLibrary
			//            imagePicker.mediaTypes =  kUTTypeImage as! [String]
			
			self.present(imagePicker, animated: true, completion: nil)
		})
        let cameraAction = UIAlertAction(title: "Take Photo".localized, style: .default, handler: {
			(alert: UIAlertAction!) -> Void in
			if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
				imagePicker.sourceType = .camera
				self.present(imagePicker, animated: true, completion: nil)
			}
			else {
				self.ShowErrorAlert(message:"Your camera is not accessible. Please check your device settings and then try again.".localized)
			}
		})
        
       		let cancelAction = UIAlertAction(title: kCancelBtnTitle, style: .cancel, handler: {
			(alert: UIAlertAction!) -> Void in
		})
		
		photoOptionMenu.addAction(cameraAction)
        photoOptionMenu.addAction(libraryAction)
        
		photoOptionMenu.addAction(cancelAction)
		self.present(photoOptionMenu, animated: true, completion: nil)
	}
    
    func showVideoChoosingOptions() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.movie"]
        imagePicker.videoMaximumDuration = 15
        let photoOptionMenu = UIAlertController(title: "Choose Source".localized, message: kEmptyString, preferredStyle: .actionSheet)
        let libraryAction = UIAlertAction(title: "View Phone Gallery".localized, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            imagePicker.sourceType = .photoLibrary
            //            imagePicker.mediaTypes =  kUTTypeImage as! [String]
            
            self.present(imagePicker, animated: true, completion: nil)
        })
        let cameraAction = UIAlertAction(title: "Make Video".localized, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            else {
                self.ShowErrorAlert(message:"Your camera is not accessible. Please check your device settings and then try again.".localized)
            }
        })
        
        let cancelAction = UIAlertAction(title: kCancelBtnTitle, style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        photoOptionMenu.addAction(cameraAction)
        photoOptionMenu.addAction(libraryAction)
        
        photoOptionMenu.addAction(cancelAction)
        self.present(photoOptionMenu, animated: true, completion: nil)
    }
	
	func GetEmptyView(viewP : UIView)-> UILabel{
		let messageLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: viewP.bounds.size.width, height: viewP.bounds.size.height))
		messageLabel.text = "No Record Found".localized
		messageLabel.textColor = UIColor.black
		messageLabel.numberOfLines = 0;
		messageLabel.textAlignment = .center;
		messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
		messageLabel.sizeToFit()
		
		return messageLabel
	}
	
	func BorderView(viewMain : UIView , borderColor : UIColor){
		viewMain.layer.borderWidth = 1;
		viewMain.layer.cornerRadius = 10
		viewMain.layer.borderColor = borderColor.cgColor
		viewMain.clipsToBounds = true
		viewMain.layer.masksToBounds = true

	}

}




// MARK:
// MARK: Project Bottom Cell
extension BaseViewController {
	
	
    func GetTodaydate() -> String{
        let datetoday = Date()
        return datetoday.GetString(dateFormate: "YYYY-MM-dd")
    }

    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    
    func reloadMainTable(tableView: UITableView) {
        
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
        
    }

    
    func ShakeView(viewMain : UIView){
        let anim = CAKeyframeAnimation( keyPath:"transform" )
        anim.values = [
            NSValue( caTransform3D:CATransform3DMakeTranslation(-5, 0, 0 ) ),
            NSValue( caTransform3D:CATransform3DMakeTranslation( 5, 0, 0 ) )
        ]
        anim.autoreverses = true
        anim.repeatCount = 2
        anim.duration = 7/100
        
        viewMain.layer.add( anim, forKey:nil )
    }
    

    func DialNumber(PhoneNumber : String){
        if let url = URL(string: "tel://\(PhoneNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    func OpenLink(webUrl:String){
        let url = URL(string: webUrl)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func GotoHome(){
        
        self.navigationController?.popViewController(animated: false)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HomeView"), object: nil)

    }
    
    func GetView(nameViewController : String , nameStoryBoard : String) -> UIViewController {
        let storyboard = UIStoryboard(name: nameStoryBoard, bundle: nil)
        let viewObj = (storyboard.instantiateViewController(withIdentifier: nameViewController)) as UIViewController
        
        return viewObj
        
    }
    
    func PushView(nameViewController : String , nameStoryBoard : String , isAnimated : Bool = true)  {
        let storyboard = UIStoryboard(name: nameStoryBoard, bundle: nil)
        let viewObj = (storyboard.instantiateViewController(withIdentifier: nameViewController)) as UIViewController
        
        self.navigationController?.pushViewController(viewObj, animated: isAnimated)
        
    }
    
    
    func getCountryList() -> [Country] {
        var county = [Country]()
        var country_dict: [[String: String]]
        
        
        if isArabic() {
            if let path = Bundle.main.path(forResource: "CallingCodesar", ofType: "plist") {
                country_dict = NSArray(contentsOfFile: path) as! [[String: String]]
                for cntry in country_dict {
                    let bundle = "assets.bundle/"
                    if let img : UIImage = UIImage(named: bundle + (cntry["code"]?.lowercased())! + ".png", in: Bundle.main, compatibleWith: nil) {
                        let Name : String = cntry["name"]! + "  (" +  cntry["code"]!  + ")"
                        let code : String = cntry["dial_code"]!
                        let code_text = (cntry["code"]?.lowercased())!
                        county.append(Country.init(image: img, name: Name, code: code , code_text: code_text.uppercased()))
                    }
                }
            }
        }else{
            if let path = Bundle.main.path(forResource: "CallingCodes", ofType: "plist") {
                country_dict = NSArray(contentsOfFile: path) as! [[String: String]]
                for cntry in country_dict {
                    let bundle = "assets.bundle/"
                    if let img : UIImage = UIImage(named: bundle + (cntry["code"]?.lowercased())! + ".png", in: Bundle.main, compatibleWith: nil) {
                        let Name : String = cntry["name"]! + "  (" +  cntry["code"]!  + ")"
                        let code : String = cntry["dial_code"]!
                        let code_text = (cntry["code"]?.lowercased())!
                        county.append(Country.init(image: img, name: Name, code: code , code_text: code_text.uppercased()))
                    }
                }
            }
        }

        return county
    }
    
    func OpenImage(image : UIImage) {
        var photos = [INSPhotoViewable]()
          photos.append(INSPhoto(image: image, thumbnailImage: image))
//                for attachtment in attachments{
//                    let type = attachtment["type"] as? String
//                    if type == "image" {
//                        if let stringMain = attachtment["attachment_path"] as? String {
//                            let urlImage = kImagePath + stringMain
//                            photos.append(INSPhoto(imageURL: URL.init(string: urlImage), thumbnailImage: #imageLiteral(resourceName: "loading")))
//                        }
//                    }
//                }
      let galleryPreview = INSPhotosViewController(photos: photos, initialPhoto: photos[0], referenceView: self.view)
         galleryPreview.referenceViewForPhotoWhenDismissingHandler = {  photo in
                    return nil
         }
      self.present(galleryPreview, animated: true, completion: nil)

    }
    
    func estimatedHeightOfLabel(text: String ) -> CGFloat {
        
        let size = CGSize(width: self.view.frame.width - 16, height: 1000)
        
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        
        let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes, context: nil).height
        
        return rectangleHeight
    }

    func isArabic() -> Bool{
        let userDefaults = UserDefaults.standard
        if (userDefaults.value(forKey: "L") != nil) {
            if (userDefaults.value(forKey: "L") as! String) == "1" {
                return true
            }
        }
        
        return false
    }
    
}

extension UIView{
    func fadeIn(duration : Double = 0.5) {
        self.alpha = 0.0
        UIView.animate(withDuration: duration, animations: {
           self.alpha = 1.0
        })
    }
    
    func fadeOut(duration : Double = 0.5) {
        self.alpha = 1.0
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
}

extension UITableView{
    func NoDataAvailable(text : String) {
        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: (self.bounds.size.width/2)-50 , y: 30, width: 100 , height: 100))
        noDataLabel.text          = text
        noDataLabel.textColor     = UIColor.darkGray
        noDataLabel.textAlignment = .center
        self.backgroundView  = noDataLabel
        self.separatorStyle  = .none
    }
    
    func RemoNoDataLbl() {
        self.backgroundView  =  nil
        self.separatorStyle  = .none
    }
    
    
    
}

extension UIView{
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
}


extension String {
    func getDateWithFormate(formate : String)-> String {
        let date = Date(timeIntervalSince1970: Double(self)!)
        return date.GetString(dateFormate: formate)
    }
    func ConvertTODate()-> String {
        let date = Date(timeIntervalSince1970: Double(self)!)
        return date.GetString(dateFormate: "dd MMM YYYY")
    }
    
    func ConvertTOTime()-> String {
        let date = Date(timeIntervalSince1970: Double(self)!)
        return date.GetString(dateFormate: "h:mm a")
    }

    
    
    func ConvertTONotificaitonDate()-> String {
        let date = Date(timeIntervalSince1970: Double(self)!)
        return date.GetString(dateFormate: "dd MMM YYYY h:mm a")
    }
    
    
   
}
//extension String {
//    func ConvertTODate()-> String {
//        let date = Date(timeIntervalSince1970: Double(self)!)
//        return date.GetString(dateFormate: "dd MMM YYYY")
//    }
//    
//    func ConvertTOTime()-> String {
//        let date = Date(timeIntervalSince1970: Double(self)!)
//        return date.GetString(dateFormate: "h:mm a")
//    }
//    
//    
//    func ConvertTONotificaitonDate()-> String {
//        let date = Date(timeIntervalSince1970: Double(self)!)
//        return date.GetString(dateFormate: "dd MMM YYYY h:mm a")
//    }
//}


class ShadowView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
//        self.CornerRadious()
        self.dropShadow()
    }
    
//    override func CornerRadious()  {
//        self.layer.borderWidth = 1;
//        self.layer.cornerRadius = 5
//        self.layer.borderColor = UIColor.clear.cgColor
//        self.clipsToBounds = true
//        self.layer.masksToBounds = false
//    }
    
    
        required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
   
    
}

