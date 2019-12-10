//
//  CompanyInfoViewController.swift
//  Servent
//
//  Created by waseem on 21/02/2018.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit
import AAPickerView
import GooglePlaces
import GoogleMaps
import CoreLocation


protocol SelectedServices:class {
    func SelectedServices(services: [[String : Any]])
}
class CompanyInfoViewController: BaseViewController , SelectedServices , UITextViewDelegate , UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate{

    
    @IBOutlet weak var lbl_Heading: UILabel!
    @IBOutlet weak var lbl_Language: UILabel!
    @IBOutlet weak var lbl_English: UILabel!
    @IBOutlet weak var lbl_Arabic: UILabel!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Phone: UILabel!
    @IBOutlet weak var lbl_StartTime: UILabel!
    @IBOutlet weak var lbl_EndTime: UILabel!
    @IBOutlet weak var lbl_RatePerHour: UILabel!
    @IBOutlet weak var lbl_About: UILabel!
    @IBOutlet weak var lbl_Address: UILabel!
    @IBOutlet weak var lbl_Type: UILabel!
    @IBOutlet weak var lbl_Select: UILabel!
    @IBOutlet weak var btn_Select: UIButton!
    @IBOutlet weak var btn_Submit: UILabel!
    @IBOutlet weak var btn_Cr: UILabel!
    @IBOutlet weak var lbl_companyURL: UILabel!
    @IBOutlet weak var txt_companyURL: UITextField!

    @IBOutlet var imgView_English : UIImageView!
    @IBOutlet var imgView_Arabic : UIImageView!
    
    @IBOutlet weak var uv_MapView: GMSMapView!
    var locationManager = CLLocationManager()
    
    var companyInfo  = [String : AnyObject]()
    
    @IBOutlet var txtField_Name : UITextField!
    @IBOutlet var txtField_Phone : UITextField!
    @IBOutlet var txtField_Starttime : AAPickerView!
    @IBOutlet var txtField_EndTime : AAPickerView!
    @IBOutlet var txtField_Type : AAPickerView!
    @IBOutlet var txtField_Rate : UITextField!
    @IBOutlet var txtView_Info : UITextView!
    @IBOutlet var txtField_Address : UITextField!
    
    @IBOutlet weak var txtCRNumber: UITextField!
    
    var selectedServices  = [[String : AnyObject]]()
    @IBOutlet weak var collection_view_hight: NSLayoutConstraint!
    @IBOutlet weak var collection_view: UICollectionView!
    
    
    var isEnglish = true
    
    var companyID = ""
//    var companytype = ""
    
    var companylat = ""
    var companylong = ""
    var company_Latitude = 0.0
    var company_Longitude = 0.0
    var companyName = ""
    var isRefresh = true
    
    @IBOutlet weak var imgViewBack: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
        }
        self.lbl_Heading.text = "Company Information".localized
        self.lbl_Language.text = "Language".localized
        self.lbl_English.text = "English"
        self.lbl_Arabic.text = "Arabic".localized
        self.lbl_Name.text = "Company Name".localized
        self.lbl_Phone.text = "Company Phone".localized
        self.lbl_StartTime.text = "Start Time".localized
        self.lbl_EndTime.text = "End Time".localized
        self.lbl_RatePerHour.text = "Rate per Hour".localized
        self.lbl_About.text = "About Company".localized
        self.lbl_Address.text = "Company Address".localized
        self.lbl_Type.text = "Company Type".localized
        self.lbl_Select.text = "SELECT SERVICE".localized
        self.btn_Submit.text = "Submit".localized
        self.btn_Cr.text = "CR Number".localized
        
        self.txtField_Name.placeholder = "Name".localized
        self.txtField_Phone.placeholder = "Phone".localized
        self.txtField_Rate.placeholder = "Price".localized
        self.txtCRNumber.placeholder = "CR Number".localized
        lbl_companyURL.text = "Company URL".localized
        txt_companyURL.placeholder = "URL".localized
        self.txtView_Info.text = "About".localized
//        txtField_Type.valueDidSelected = { row in
//            print("Selected Row :\(row)")
//        }
//
       
        self.collection_view.register(UINib.init(nibName: "ServicesCell", bundle: nil), forCellWithReuseIdentifier: "ServicesCell")

        self.txtField_Address.delegate = self
        self.txtView_Info.delegate = self
        //For MAP...
        //self.showDataOnMap()
        //self.showCurrentLocation()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled(){
            switch (CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            default: break
            }
        }else {
            print("Location services are not enabled")
        }
    }
    

    @IBAction func BAck_Action(sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    
//        for controller in self.navigationController!.viewControllers as Array {
//            if controller.isKind(of: HomeVC.self) {
//                self.navigationController!.popToViewController(controller, animated: false)
//                break
//            }
//        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if isRefresh
        {
            self.txtField_Starttime.pickerType = .date
            self.txtField_Starttime.datePicker?.datePickerMode = .time
            
            self.txtField_Type.pickerType = .string(data: ["Cleaning".localized , "Maintenance".localized])
          //  self.txtField_Type.stringPicker = ["Cleaning" , "Maintenance"]
            
            self.txtField_EndTime.pickerType = .date
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "hh:mm a"
            
            self.txtField_EndTime.dateFormatter = dateFormatterGet
            self.txtField_Starttime.dateFormatter = dateFormatterGet
            self.txtField_EndTime.datePicker?.datePickerMode = .time
            
//            if self.companyID.characters.count > 0 {
                self.GetCompanInfo()
//            }
        }
       
       isRefresh = true
    }
    
    
    func GetCompanInfo(){
        self.showLoading()
        NetworkManager.get("company", isLoading: true, onView: self) { (mainResponse) in
            print(mainResponse)
            self.hideLoading()
            if(mainResponse?["message"] as! String == "User Company".localized){
                let companyMain = mainResponse?["data"] as? [String : AnyObject]
                
                print("\n")
                print("\n")
                print(companyMain)
                print("\n")
                print("\n")
                
                //self.companyInfo = (mainResponse["data"] as? [String : AnyObject])!
                
                
                if (companyMain!["services"] != nil) {
                    self.selectedServices = companyMain!["services"] as! [[String : AnyObject]]
                }
                
                if (companyMain!["time_starts"]  != nil){
                    self.txtField_Starttime.text = self.getTime(milisecond:companyMain!["time_starts"] as! Int)
                    self.txtField_EndTime.text = self.getTime(milisecond:companyMain!["time_ends"] as! Int)
                    self.txtView_Info.text = companyMain!["translation"]!["about"] as! String
                    if (self.txtView_Info.text.count > 0){
                        self.txtView_Info.textColor = UIColor.black
                    }else{
                        self.txtView_Info.text = "About".localized
                        self.txtView_Info.textColor = UIColor.lightGray
                    }
                    self.companyID = String(companyMain!["translation"]!["company_id"] as! Int)
                    
                    if let full_name = companyMain!["translation"]!["full_name"] as? String {
                        self.txtField_Name.text = full_name
                        self.companyName = full_name
                        
                    }else if let full_name = companyMain!["translation"]!["title"] as? String {
                        self.txtField_Name.text = full_name
                        self.companyName = full_name
                    }
                    
                    
                    let priceMain = (companyMain!["rate_per_hour"]!["usd"]! as! [String : Any])
                    
                    // sk start
                   // let priceMeter = (companyMain!["rate_per_meter"]!["usd"]! as! [String : Any])
                   // self.txtRatePerMeter.text = "\(priceMeter["amount"] as! Double)"
                    
                    self.txtCRNumber.text = companyMain!["cr_number"] as! String
                    self.txt_companyURL.text = companyMain?["company_url"] as? String
                    
                    //end
                    
                    if let priceInt = priceMain["price"] as? Int
                    {
                        self.txtField_Rate.text = "\(priceInt).0"
                    }
                    else if let priceDouble = priceMain["amount"] as? Double
                    {
                        self.txtField_Rate.text = "\(priceDouble)"
                    }
                    
                    self.txtField_Phone.text = companyMain!["phone"] as? String
                    if (companyMain!["company_type"] as? String)! == "cleaning" {
                        self.txtField_Type.text = "cleaning".localized
                        
                    }
                    else{
                        self.txtField_Type.text = "maintenance".localized
                    }
                    
//                    self.txtField_Type.text = (companyMain!["company_type"] as? String)!
                    self.txtField_Address.text = companyMain!["address"] as? String
                    self.companylat = "\((companyMain!["latitude"] as? NSNumber)!)"
                    self.companylong = "\((companyMain!["longitude"] as? NSNumber)!)"
                    self.company_Latitude = Double(truncating: (companyMain!["latitude"] as? NSNumber)!)
                    self.company_Longitude = Double(truncating: (companyMain!["longitude"] as? NSNumber)!)

                    
                    
                   // func showCurrentLocation() {
                        self.uv_MapView.settings.myLocationButton = true
                        let locationObj = self.locationManager.location
                        let coord = locationObj?.coordinate
                        let lattitude = coord?.latitude
                        let longitude = coord?.longitude
                        
                        print(" lat in  updating \(String(describing: lattitude)) ")
                        print(" long in  updating \(String(describing: longitude))")
                        
                        //let center = CLLocationCoordinate2D(latitude: locationObj?.coordinate.latitude ?? 0.0, longitude: locationObj?.coordinate.longitude ?? 0.0)
                        let center = CLLocationCoordinate2D(latitude: self.company_Latitude, longitude: self.company_Longitude)
                        let marker = GMSMarker()
                        marker.position = center
                        print("company Longitude = \(self.company_Longitude)")
                        print("company Latitude = \(self.company_Latitude)")
                        print("Company Name  = \(self.companyName)")
                        marker.title = self.companyName
                        marker.map = self.uv_MapView
                        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: self.company_Latitude, longitude: self.company_Longitude, zoom: Float(10.0))
                        self.uv_MapView.animate(to: camera)
                    self.uv_MapView.settings.scrollGestures = false
                    
                   // }
                    
                }
                
                
                
            }else{
                self.hideLoading()
                self.ShowErrorAlert(message:  mainResponse?["message"] as! String)
            }
            let count = Float(self.selectedServices.count)
            let width = (self.screenWidth-30) / 3
            self.collection_view_hight.constant = (CGFloat(ceilf(count/3.0)) * width) + 20
//            self.collection_view_hight.constant = CGFloat(ceilf(count/3.0)) * 150// CGFloat(self.selectedServices.count/3.0)
            self.collection_view.reloadData()
        }
    }
    
    @IBAction func English_Action(sender : UIButton){
        self.imgView_Arabic.image = #imageLiteral(resourceName: "radio_button_uncheck")
        self.imgView_English.image = #imageLiteral(resourceName: "radio_button_check")
        isEnglish = true
    }
    
    @IBAction func Arabic_Action(sender : UIButton){
        self.imgView_English.image  = #imageLiteral(resourceName: "radio_button_uncheck")
        self.imgView_Arabic.image = #imageLiteral(resourceName: "radio_button_check")
        isEnglish = false
    }
    
    @IBAction func SubmitAction(sender : UIButton){
        if(self.txtField_Name.text == ""){
            self.ShowErrorAlert(message: "Invalid Name".localized)
        }else if(self.txtField_Phone.text == ""){
            self.ShowErrorAlert(message: "Invalid Phone Number".localized)
        }else if(self.txtField_Starttime.text == ""){
            self.ShowErrorAlert(message: "Choose start time".localized)
        }else if(self.txtField_EndTime.text == ""){
            self.ShowErrorAlert(message: "Choose end time".localized)
        }else if(self.txtField_Rate.text == ""){
            self.ShowErrorAlert(message: "Rate Per Hour Required".localized)
        }
        else if(self.txtCRNumber.text == ""){
            self.ShowErrorAlert(message: "CR Number Required".localized)
        }
//        else if(self.txt_companyURL.text == ""){
//            self.ShowErrorAlert(message: "Company URL Required".localized)
//        }
//        else if(self.txtRatePerMeter.text == ""){
//            self.ShowErrorAlert(message: "Rate Per meter Required")
//        }
        else if(self.txtView_Info.text == "" || self.txtView_Info.text == "About".localized){
            self.ShowErrorAlert(message: "Enter about company info".localized)
        }else if(self.txtField_Address.text == ""){
            self.ShowErrorAlert(message: "Choose address".localized)
        }else if(self.txtField_Type.text == ""){
            self.ShowErrorAlert(message: "Choose company type.".localized)
        }else if(self.selectedServices.count == 0){
            self.ShowErrorAlert(message: "Service required".localized)
        }else{
            
            
            var param = [String : AnyObject]()
            
            param["about"] = txtView_Info.text as AnyObject?
            param["address"] = self.txtField_Address.text as AnyObject?
            
            var companyType = ""
            if self.txtField_Type.text == "Cleaning".localized {
                companyType = "cleaning"
            }
            else{
                companyType = "maintenance"
            }
            
            param["company_type"] = companyType as AnyObject//self.txtField_Type.text!.lowercased() as AnyObject
            param["title"] = self.txtField_Name.text! as AnyObject
            if self.isEnglish {
                param["language_id"] = "2" as AnyObject
            }else {
                param["language_id"] = "1" as AnyObject
            }
            param["cr_number"] = self.txtCRNumber.text as AnyObject
            param["company_url"] = self.txt_companyURL.text as AnyObject
            //param["rate_per_meter"] = self.txtRatePerMeter.text as AnyObject
            
            
            param["latitude"] = self.companylat as AnyObject
            param["longitude"] = self.companylong as AnyObject
            param["phone"] = self.txtField_Phone.text as AnyObject
            param["rate_per_hour"] = self.txtField_Rate.text as AnyObject
            param["time_starts"] = String(Int(self.getCompanyTime(mainString:self.txtField_Starttime.text!))) as AnyObject
            param["time_ends"] = String(Int(self.getCompanyTime(mainString:self.txtField_EndTime.text!))) as AnyObject

            
            var UrlMain = "company/update"
            if self.companyID.count > 0 {
                param["company_id"] = self.companyID as AnyObject
                UrlMain = "company/update"
            }else {
                UrlMain = "company/store"
            }
            var index = 0
            for indexObj in self.selectedServices {
                print(indexObj)
                let newString = String(format:"service_id[%d]",index)
                param[newString] = indexObj["id"] as AnyObject
                index = index + 1
            }
            print(param)
            
            self.showLoading()
            NetworkManager.post(UrlMain, isLoading: true, withParams: param, onView: self, hnadler: { (mainResponse) in
                print(mainResponse)
                self.hideLoading()
                if(mainResponse?["status_code"] as! Int  == 200){
                   // "Compny Info updated successfully!!"
                    self.ShowSuccessAlert(message: mainResponse?["message"] as! String)
                }else{
                    self.hideLoading()
                    self.ShowErrorAlert(message: mainResponse?["message"] as! String)
                }
            })
        }
    }
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//
//        if textField == txtField_Address {
//            isRefresh = false
//            let placePickerController = GMSAutocompleteViewController()
//            placePickerController.delegate = self as GMSAutocompleteViewControllerDelegate
//            self.present(placePickerController, animated: true) {
//
//            }
//            return false
////        }else if textField == txtfieldServices {
////            isRefresh = false
////
////            return false
//        }
//        return true
//    }
    
    
    @IBAction func ShowServices(sender : UIButton){
        
        if self.txtField_Type.text?.count == 0 {
            self.ShowErrorAlert(message: "Please choose Service Type first.")
        }else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewPush = storyboard.instantiateViewController(withIdentifier: "ServicesSelectionVC") as! ServicesSelectionVC
            viewPush.isSelect = true
            viewPush.delegate = self
            
        
            if self.txtField_Type.text == "Cleaning".localized
                {
                 viewPush.isType = "cleaning"//self.txtField_Type.text!.lowercased()
            }
            else{
                viewPush.isType = "maintenance"//self.txtField_Type.text!.lowercased()
            }
            
//            viewPush.isType = self.txtField_Type.text!.lowercased()
            self.isRefresh = false
            self.navigationController?.pushViewController(viewPush, animated: true)
        }
        
    }
    
    
    func SelectedServices(services: [[String : Any]]) {
        self.selectedServices = services as [[String : AnyObject]]
        let count = Float(self.selectedServices.count)
        let width = (screenWidth-30) / 3
        self.collection_view_hight.constant = (CGFloat(ceilf(count/3.0)) * width) + 20
        self.collection_view.reloadData()
//        self.txtfieldServices.text = ""
//        for indexObj in self.selectedServices {
//            if self.txtfieldServices.text!.characters.count > 0 {
//                self.txtfieldServices.text = self.txtfieldServices.text! + "," + indexObj.title
//            }else {
//                self.txtfieldServices.text = self.txtfieldServices.text! + indexObj.title
//            }
//
//        }
    }
}


extension CompanyInfoViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: nil)
        
        
        
        self.txtField_Address.text = place.formattedAddress
        self.companylat = String(place.coordinate.latitude)
        self.companylong = String(place.coordinate.longitude)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "About".localized
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedServices.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenWidth-30) / 3
        return CGSize(width: width, height: width)
//        return CGSize.init(width: (collection_view.bounds.size.width/3)  , height: (collection_view.bounds.size.width/3) )
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "ServicesCell", for: indexPath) as! ServicesCell
        
        let translation = self.selectedServices[indexPath.row]["translation"] as! [String : Any]
        
        cell.service_name.text = translation["title"] as? String
        cell.img.sd_setImage(with: URL.init(string: self.selectedServices[indexPath.row]["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
        
        cell.check_box_img.isHidden = true
        
        print(self.selectedServices.count % 3)
        cell.bottomView.isHidden = false
        if indexPath.row >= (self.selectedServices.count - (self.selectedServices.count % 3) ) {
            cell.bottomView.isHidden = true
            
        }
        
        cell.rightView.isHidden = false
        if ((indexPath.row + 1)  % 3) == 0  {
            cell.rightView.isHidden = true
            
        }
        
        return cell
    }
}

extension CompanyInfoViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtField_Address {
            isRefresh = false
            let placePickerController = GMSAutocompleteViewController()
            placePickerController.delegate = self as GMSAutocompleteViewControllerDelegate
            self.present(placePickerController, animated: true) {
                
            }
            return false
            //        }else if textField == txtfieldServices {
            //            isRefresh = false
            //
            //            return false
        }
        return true
    }
}
