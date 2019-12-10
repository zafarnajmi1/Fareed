//
//  SelectCurencyVC.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 3/18/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class SelectCurencyVC:BaseViewController, UIPickerViewDelegate,UIPickerViewDataSource {
    @IBOutlet weak var view_selection: UIView!
    
    @IBOutlet weak var imgViewBack: UIImageView!
    @IBOutlet weak var lbl_Heading: UILabel!
    @IBOutlet weak var lbl_Select: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var btn_Continue: UIButton!
    
    @IBOutlet weak var Img_Cruncy: UIImageView!
    @IBOutlet weak var LBL_cruncy: UILabel!
    @IBOutlet weak var picker_View: UIPickerView!
    var curency = ["OMR" , "AED"]
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
        }
        
        self.lbl_Heading.text = "Select Currency".localized
        self.lbl_Title.text = "Fareed Services".localized //"Cleaning & Maintenance Services".localized
        self.lbl_Select.text = "Select Currency".localized
        self.btn_Continue.setTitle("CONTINUE".localized, for: .normal)
        picker_View.delegate = self
        picker_View.dataSource = self
        
        let defaults = UserDefaults.standard
        if let currency = defaults.value(forKey: "Currency") as? String{
            if currency == "1"{
                LBL_cruncy.text = "OMR"
                self.Img_Cruncy.image = #imageLiteral(resourceName: "Oman_flag")
            }
            else if currency == "2"{
                LBL_cruncy.text = "AED"
                self.Img_Cruncy.image = #imageLiteral(resourceName: "ae_flag")
            }
        }
        else{
            LBL_cruncy.text = "AED"
            self.Img_Cruncy.image = #imageLiteral(resourceName: "ae_flag")
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
////        if LBL_cruncy.text == "OMR" {
////            self.Img_Cruncy.image = #imageLiteral(resourceName: "Oman_flag")
////        }else {
////            self.Img_Cruncy.image = #imageLiteral(resourceName: "ae_flag")
////        }
//    }
    
    @IBAction func OnClickSelectCruncy(_ sender: Any) {
        self.view_selection.isHidden = false
    }
    @IBAction func OnClickDonePicker(_ sender: Any) {
        self.view_selection.isHidden = true
    }
    @IBAction func OnClickCancelPicker(_ sender: Any) {
         self.view_selection.isHidden = true
    }
    @IBAction func OnClickBack(_ sender: Any) {
        self.Back()
    }
    @IBAction func OnClickContinue(_ sender: Any) {
        
        if LBL_cruncy.text == "OMR" {
            UserDefaults.standard.set("1", forKey: "Currency")
        }else {
            UserDefaults.standard.set("2", forKey: "Currency")
        }
        
        
        UserDefaults.standard.synchronize()
        self.Back()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return curency.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return curency[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.LBL_cruncy.text = curency[row]
        switch curency[row] {
        case "OMR":
           self.Img_Cruncy.image = #imageLiteral(resourceName: "Oman_flag")
            break
        case "AED":
             self.Img_Cruncy.image = #imageLiteral(resourceName: "ae_flag")
            break
        default:
            break
        }
    }
}

