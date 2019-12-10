//
//  SelectLanguageVC.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 3/18/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class SelectLanguageVC: BaseViewController, UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var imgViewBack: UIImageView!
    
    @IBOutlet weak var lbl_Heading: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Select: UILabel!
    @IBOutlet weak var lbl_saveLanguage: UILabel!
    @IBOutlet weak var btn_Continue: UIButton!
    
    @IBOutlet weak var view_selection: UIView!
    @IBOutlet weak var Img_language: UIImageView!
    @IBOutlet weak var LBL_language: UILabel!
    @IBOutlet weak var picker_View: UIPickerView!
    
    var curency = ["English" ,"عربی"]
    @IBOutlet weak var IMG_save_language: UIImageView!
    var index = 0
    
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
        }
        self.IMG_save_language.image = UIImage.init(named: "uncheckselectedcheckbox")
        self.doneBtn.setTitle("Done".localized, for: .normal)
        self.cancelBtn.setTitle("Cancel".localized, for: .normal)
        self.lbl_Heading.text = "Select Language".localized
        self.lbl_Title.text = "Fareed Services".localized //"Cleaning & Maintenance Services".localized
        self.lbl_Select.text = "Select Language".localized
        self.lbl_saveLanguage.text = "Save This Language".localized
        self.btn_Continue.setTitle("CONTINUE".localized, for: .normal)
        picker_View.delegate = self
        picker_View.dataSource = self
        
        var lang = ""
        self.Img_language.isHidden = true
        
        let userDefaults = UserDefaults.standard
        if (userDefaults.value(forKey: "L") != nil)
        {
            if (userDefaults.value(forKey: "L") as! String) == "1"
            {
                lang = "1"
            }
        }
        else
        {
            lang = "0"
        }
        
        if (lang == "1")
        {
            self.Img_language.image = #imageLiteral(resourceName: "ae_flag")
            LBL_language.text = curency[1]
        }
        else
        {
            self.Img_language.image = #imageLiteral(resourceName: "br_flag")
            LBL_language.text = curency[0]
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnClickBack(_ sender: Any) {
        self.Back()
    }

    @IBAction func OnClickChangeLanguage(_ sender: Any) {
        self.view_selection.isHidden = false
    }
    @IBAction func OnClickContinue(_ sender: Any)
    {
        //IQKeyboardManager.shared.enable = false
        if self.LBL_language.text == "English"
        {
            let userDefaults = UserDefaults.standard
            Language.language = Language.english
             IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done"
            userDefaults.set("0", forKey: "L")
            userDefaults.synchronize()
            
            //IQKeyboardManager.shared.enable = true
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            
        }else {
            let userDefaults = UserDefaults.standard
            Language.language = Language.arabic
            userDefaults.set("1", forKey: "L")
            userDefaults.synchronize()
             IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done".localized
            //IQKeyboardManager.shared.enable = true
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        
        self.Back()
    }
    @IBAction func OnClickSaveLanguage(_ sender: Any) {
        if(self.IMG_save_language.image == UIImage.init(named: "uncheckselectedcheckbox")){
            self.IMG_save_language.image = UIImage.init(named: "selectedcheckbox")//#imageLiteral(resourceName: "check_box_checked")
        }else{
             self.IMG_save_language.image = UIImage.init(named: "uncheckselectedcheckbox")// #imageLiteral(resourceName: "check_box")
        }
    }
    
    @IBAction func OnClickDonePicker(_ sender: Any)
    {
        if self.index == 0
        {
            LBL_language.text = curency[0]
        }
        else
        {
            LBL_language.text = curency[1]
        }
        
        self.view_selection.isHidden = true
    }
    
    @IBAction func OnClickCancelPicker(_ sender: Any) {
        self.view_selection.isHidden = true
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
        self.LBL_language.text = curency[row]
        index = row
        
        switch curency[row]
        {
        case "English":
            self.Img_language.image = #imageLiteral(resourceName: "br_flag")
            break
        case "عربی":
            self.Img_language.image = #imageLiteral(resourceName: "ae_flag")
            break
        default:
            break
        }
    }
}
