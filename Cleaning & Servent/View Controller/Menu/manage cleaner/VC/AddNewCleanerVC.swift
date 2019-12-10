//
//  AddNewCleanerVC.swift
//  Cleaning & Servent
//
//  Created by Hassan Mumtaz on 5/4/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class AddNewCleanerVC:  BaseViewController ,SelectedServices, UITextFieldDelegate {
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var Img_Female: UIImageView!
    @IBOutlet weak var Img_Male: UIImageView!
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var imgViewBAck: UIImageView!
    @IBOutlet weak var txtFieldName: UITextField!
    @IBOutlet weak var txtFieldPhone: UITextField!
    @IBOutlet weak var txtFieldCNIC: UITextField!
    @IBOutlet weak var txtFieldAddress: UITextField!
    @IBOutlet weak var txtFieldAbout: UITextField!
    @IBOutlet weak var txtFieldSelectService: UITextField!
    @IBOutlet weak var lbl_HEading: UILabel!
    @IBOutlet weak var lbl_male: UILabel!

    @IBOutlet weak var lbl_female: UILabel!
    @IBOutlet weak var lbl_gender: UILabel!


    @IBOutlet weak var btnSubmit: UIButton!
    
    var selectedServices  = [[String : AnyObject]]()
    
    var isFemale = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isArabic() {
            self.imgViewBAck.image = #imageLiteral(resourceName: "backArabic")
        }
        
        self.lbl_HEading.text = "Add New Cleaner".localized
        self.btnSubmit.setTitle("Submit".localized, for: .normal)
        lbl_male.text = "Male".localized
        lbl_female.text = "Female".localized
        lbl_gender.text = "Select Gender".localized
        txtFieldName.placeholder = "Name".localized
        txtFieldPhone.placeholder = "Phone".localized
        txtFieldCNIC.placeholder = "ID number".localized
        txtFieldAddress.placeholder = "Address".localized
        txtFieldAbout.placeholder = "About".localized
        txtFieldSelectService.placeholder = "Select Services".localized

        imagePicker.delegate = self
    }
    
    @IBAction func Back_Action(){
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnClickMale(_ sender: Any) {
        self.Img_Male.image = #imageLiteral(resourceName: "radio_button_check")
         self.Img_Female.image = #imageLiteral(resourceName: "radio_button_uncheck")
        self.isFemale = false
    }
    
    @IBAction func OnClickFemale(_ sender: Any) {
         self.Img_Female.image = #imageLiteral(resourceName: "radio_button_check")
         self.Img_Male.image = #imageLiteral(resourceName: "radio_button_uncheck")
        self.isFemale = true
    }
    
    @IBAction func OnClickEditImage(_ sender: Any) {
        showMediaChoosingOptions()
//        imagePicker.allowsEditing = false
//        imagePicker.sourceType = .photoLibrary
//        self.present(imagePicker, animated: true, completion: nil)
    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            self.image.image = pickedImage
//        }
//        dismiss(animated: true, completion: nil)
//    }
    override func selectedImage(image: UIImage) {
        self.image.image = image
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtFieldSelectService {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewPush = storyboard.instantiateViewController(withIdentifier: "ServicesSelectionVC") as! ServicesSelectionVC
            viewPush.isSelect = true
            viewPush.delegate = self as SelectedServices
            viewPush.onlyCompayServices = true
//            viewPush.isType = self.txtField_Type.text!.lowercased()
            self.navigationController?.pushViewController(viewPush, animated: true)
            return false
            
        }
        
        return true
    }
    
    @IBAction func SubmitAction(sender : UIButton){
        
        if self.selectedServices.count == 0 {
            self.ShowErrorAlert(message: "Please select services".localized)
            return
        }
        
        if self.txtFieldName.text!.count == 0 {
            self.ShowErrorAlert(message: "Name missing".localized)
            return
        }
        
        if self.txtFieldCNIC.text!.count == 0 {
            self.ShowErrorAlert(message: "ID number missing".localized)
            return
        }
        
        if self.txtFieldAbout.text!.count == 0 {
            self.ShowErrorAlert(message: "About missing".localized)
            return
        }
        
        if self.txtFieldPhone.text!.count == 0 {
            self.ShowErrorAlert(message: "Phone number missing".localized)
            return
        }
        
        if self.txtFieldAddress.text!.count == 0 {
            self.ShowErrorAlert(message: "Address missing".localized)
            return
        }
        
        
        var newparam = [String : AnyObject]()
        newparam["full_name"] = self.txtFieldName.text! as AnyObject
        newparam["address"] = self.txtFieldAddress.text! as AnyObject
        newparam["phone"] = self.txtFieldPhone.text! as AnyObject
        newparam["about"] = self.txtFieldAbout.text! as AnyObject
        newparam["cnic"] = self.txtFieldCNIC.text! as AnyObject
        
        var indexMain = 0
        for indexObj in self.selectedServices {
            let translation = indexObj["translation"] as! [String : Any]
            newparam["service_id[" + String(indexMain) + "]"] = (String(translation["service_id"] as! Int)) as AnyObject
                indexMain = indexMain + 1
        }
        
        newparam["company_id"] = DataManager.sharedInstance.getPermanentlySavedUser()?.CompanyID as AnyObject
        
        if self.isFemale {
            newparam["gender"] = "female" as AnyObject
        }else {
            newparam["gender"] = "male" as AnyObject
        }
        print(newparam)

        NetworkManager.UploadFiles("company/employees/store", image: self.image.image!, imageName:"image", withParams: newparam, onView: self, completion: { (MainResponse) in
            print(MainResponse)
            if (MainResponse?["status_code"] as! Int) == 200{
                self.ShowSuccessAlert(message: MainResponse?["message"] as! String)
            }else {
                self.ShowErrorAlert(message: MainResponse?["message"] as! String)
            }
        })
    }
    
    func SelectedServices(services: [[String : Any]]) {
        self.selectedServices = services as [[String : AnyObject]]
//        self.collection_view.reloadData()
        
        print(self.selectedServices)
        
        self.txtFieldSelectService.text = ""
        for indexObj in self.selectedServices {
            let translation = indexObj["translation"] as! [String : Any]
            
            
            if self.txtFieldSelectService.text!.count > 0 {
                self.txtFieldSelectService.text = self.txtFieldSelectService.text! + " , "
            }
            self.txtFieldSelectService.text = self.txtFieldSelectService.text! + (translation["title"] as! String)
        }
        
        
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        print(textField)
//        print(textField.tag)
//
//
//    }
}

