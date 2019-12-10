//
//  FilterVC.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 4/2/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit
import GooglePlaces

protocol FilterDelegate {
    
    func SearchText(searchText:String , latChoose : String , longChoose : String)

    
}
class FilterVC: BaseViewController ,  UIPickerViewDelegate,UIPickerViewDataSource{
   
    @IBOutlet weak var lblHEading: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
//    var curency = ["Top Rated".localized , "Latest".localized, "Low Price".localized]
    var sortBy = [("Sort By".localized,""),("Top Rated".localized,"top_rated") , ("Latest".localized,"latest")]// "Low Price".localized]
    @IBOutlet weak var LBL_Rate: UITextField!
    @IBOutlet var txtFieldMain : UITextField!
    var delegate:FilterDelegate? = nil
    var selectedLocation : (latitude : String, longitued : String)?
//    var latChoose = "0"
//    var longChoose = "0"
    var selectedSortOption : (String, String)?
    @IBOutlet weak var Picker_view: UIView!
    @IBOutlet weak var imgViewBack: UIImageView!
    var companyArray = [[String : Any]]()
    
    var serviceType = ""
    var servicesSelected = [[String : Any]]()
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var star_5_border_view: GrayBorder!
    @IBOutlet weak var star_4_border_view: GrayBorder!
    @IBOutlet weak var star_3_border_view: GrayBorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
            LBL_Rate.textAlignment = .right
            txtFieldMain.textAlignment = .right
        }
        else {
            LBL_Rate.textAlignment = .left
            txtFieldMain.textAlignment = .left
        }
        
        self.cancelBtn.setTitle("Cancel".localized, for: .normal)
        self.doneBtn.setTitle("Done".localized, for: .normal)
        self.lblHEading.text = "Filters".localized
        self.lblRating.text = "Top Rated".localized
        self.lblLocation.text = "Location".localized
        self.LBL_Rate.placeholder = "Rating".localized
        self.txtFieldMain.placeholder = "Location".localized
        
         picker.delegate = self
        picker.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func OnClickDonePicker(_ sender: Any) {
         self.Picker_view.isHidden = true
    }
    
    @IBAction func OnClickCaneclPicker(_ sender: Any) {
         self.Picker_view.isHidden = true
    }
    @IBAction func OnClickSave(_ sender: Any) {
        
        self.APICallforCompany()
//        if self.delegate != nil{
//            self.delegate?.SearchText(searchText: self.txtFieldMain.text!,latChoose: self.latChoose,longChoose: self.longChoose)
//        }
        
//        self.Back()
    }
    
    func APICallforCompany(){
        
        var newParam = [String : AnyObject]()
        newParam["company_type"] = self.serviceType as AnyObject
        
        
        
        var urlMain = ""
        
        for indexObj in self.servicesSelected{
            
            if urlMain.count == 0 {
                urlMain = String(indexObj["id"] as! Int)
            }else {
                urlMain = urlMain + "," + String(indexObj["id"] as! Int)
            }
        }
        
        
        urlMain = urlMain + "]&company_type=" + self.serviceType
        
        if let location = selectedLocation{
            urlMain = urlMain + "&lat=" + location.latitude + "&lng=" + location.longitued
        }
        
        
//        if self.latChoose.count > 0 {
//            urlMain = urlMain + "&lat=" + self.latChoose
//        }
//        if self.longChoose.count > 0 {
//            urlMain = urlMain + "&lng=" + self.longChoose
//        }
        if let sortOption = selectedSortOption {
            urlMain = urlMain + "&sort_by=" + sortOption.1
        }
        
        print(urlMain)
        self.companyArray.removeAll()
        self.showLoading()
        NetworkManager.get("companies?services=[" + urlMain , isLoading: true, onView: self) { (Mainresponse) in
            print(Mainresponse)
            self.hideLoading()
            if (Mainresponse?["status_code"] as! Int)  == 200 {
                self.companyArray = Mainresponse?["data"] as! [[String : Any]]
                
                let viewPush = self.storyboard?.instantiateViewController(withIdentifier: "CompanyLocationVC") as! CompanyLocationVC
                viewPush.companyArray = self.companyArray
                self.navigationController?.pushViewController(viewPush, animated: true)
                
                
            }else {
                self.hideLoading()
                self.ShowErrorAlert(message: (Mainresponse?["message"] as! String))
            }
            
        }
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortBy.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
            let tuple = sortBy[row]
            
            return tuple.0
        
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if row == 0 {
            

            selectedSortOption = nil
            self.LBL_Rate.text = ""
        }
        else{
            
            let tuple = sortBy[row]
            selectedSortOption = tuple
            self.LBL_Rate.text = tuple.0
        }
        
        
    }
    
    @IBAction func OnClickRatePicker(_ sender: Any) {
        self.Picker_view.isHidden = false
    }
    @IBAction func OnClickBack(_ sender: Any) {
       self.Back()
    }
    @IBAction func OnClickStar3(_ sender: Any) {
        self.star_3_border_view.layer.borderColor = UIColor.init(red: 96/255, green: 175/255, blue: 85/255, alpha: 1.0).cgColor
        self.star_4_border_view.layer.borderColor = UIColor.init(red: (203/255), green: (204/255), blue: (205/255), alpha: 1.0).cgColor
        self.star_5_border_view.layer.borderColor = UIColor.init(red: (203/255), green: (204/255), blue: (205/255), alpha: 1.0).cgColor
        
         self.star_3_border_view.layer.borderWidth = 2
         self.star_4_border_view.layer.borderWidth = 1
         self.star_5_border_view.layer.borderWidth = 1
    }
    @IBAction func OnClickStar4(_ sender: Any) {
        self.star_4_border_view.layer.borderColor = UIColor.init(red: 96/255, green: 175/255, blue: 85/255, alpha: 1.0).cgColor
        self.star_3_border_view.layer.borderColor = UIColor.init(red: (203/255), green: (204/255), blue: (205/255), alpha: 1.0).cgColor
        self.star_5_border_view.layer.borderColor = UIColor.init(red: (203/255), green: (204/255), blue: (205/255), alpha: 1.0).cgColor
        
        self.star_4_border_view.layer.borderWidth = 2
        self.star_3_border_view.layer.borderWidth = 1
        self.star_5_border_view.layer.borderWidth = 1
    }
    
    @IBAction func OnClickStar5(_ sender: Any) {
        self.star_5_border_view.layer.borderColor = UIColor.init(red: 96/255, green: 175/255, blue: 85/255, alpha: 1.0).cgColor
        self.star_3_border_view.layer.borderColor = UIColor.init(red: (203/255), green: (204/255), blue: (205/255), alpha: 1.0).cgColor
        self.star_4_border_view.layer.borderColor = UIColor.init(red: (203/255), green: (204/255), blue: (205/255), alpha: 1.0).cgColor
        
        self.star_5_border_view.layer.borderWidth = 2
        self.star_3_border_view.layer.borderWidth = 1
        self.star_4_border_view.layer.borderWidth = 1
    }
    @IBAction func OnClick_locationCross(_ sender: Any) {
        selectedLocation = nil
        txtFieldMain.text = ""
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let placePickerController = GMSAutocompleteViewController()
        placePickerController.delegate = self
        self.present(placePickerController, animated: true) {
            
        }

        
        return false
    }
}


extension FilterVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: nil)
        
        
        self.txtFieldMain.text = place.formattedAddress
        selectedLocation = ("\(place.coordinate.latitude)","\(place.coordinate.longitude)")
        
        
//        self.latChoose = String(place.coordinate.latitude)
//        self.longChoose = String(place.coordinate.longitude)
        
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
    
}

