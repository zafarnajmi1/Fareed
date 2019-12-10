//
//  BookingMainVC.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 3/29/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit
import AVFoundation


class BookingMainVC: BaseViewController,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout , UITableViewDelegate , UITableViewDataSource , SelectedAddress  , UITextViewDelegate {
    
    @IBOutlet weak var radioRatePerHour: UIImageView!
    @IBOutlet weak var radioRatePerMeter: UIImageView!
    @IBOutlet weak var txtEnterMeter: TFLightGrayBorder!
    var isSelectChargeType = false
    
    @IBOutlet var lbl_Heading : UILabel!
    @IBOutlet var lbl_Text : UILabel!
    @IBOutlet var lbl_HeadingServices : UILabel!
    @IBOutlet var lbl_HeadingTime : UILabel!
    @IBOutlet var lbl_HeadingAddress : UILabel!
    @IBOutlet var lbl_Instruction : UILabel!
    @IBOutlet var lbl_Video : UILabel!
    @IBOutlet var lbl_Image : UILabel!
    @IBOutlet var lbl_TotalBill : UILabel!
    @IBOutlet var lbl_BookNow : UIButton!
    
    @IBOutlet var imgViewMain : UIImageView!
    @IBOutlet var imgViewVideo : UIImageView!
    
    @IBOutlet var btnImage : UIButton!
    @IBOutlet var btnVideo : UIButton!
    @IBOutlet var btnPlayVideo : UIButton!
    var instructionPlaceHolder : String {
        get {
            return "Detail...".localized
        }
    }
    
    var videoUrl = URL.init(string: "")
    
    var isImagechoose = false
    var isvideochoose = false
    
    var isImageSelect = false
    
    @IBOutlet var txtFieldAddress : UITextField!
    @IBOutlet var txtViewNotes : UITextView!
    
    @IBOutlet var lblTotalBill : UILabel!
    @IBOutlet var lblEmptyTable : UILabel!
    
    
    var init_point : Int = -1
    var count : Int  = 0
    var time_slot_Start_position : Int = -1
    var time_slot_end_position : Int = -1
    
    var chooseAddress = [String : AnyObject]()
    
    @IBOutlet weak var tbl_time_slot: UITableView!
    
    @IBOutlet weak var imgViewBack: UIImageView!
    var servicesSelected = [[String : Any]]()
    var companyData = [String : Any]()
    
    var tbleArray = [String]()
    var tbleArrayMAin = [String]()
    var HoursArray = [String]()
    
    @IBOutlet weak var Constraint_tbl_height: NSLayoutConstraint!
    var isNew : Bool = true
    var selected_index : Int = 0
    var dates  = [[String : Any]]()
    @IBOutlet weak var Collection_View: UICollectionView!
    
    
    var currency : String {
        get {
            return DataManager.sharedInstance.getSelectedCurrency()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(servicesSelected.count)
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
            self.txtFieldAddress.textAlignment = .right
            self.txtViewNotes.textAlignment = .right
        }
        else {
            self.txtFieldAddress.textAlignment = .left
            self.txtViewNotes.textAlignment = .left
        }
        
        //        if (UserDefaults.value(forKey: "L") as! String) == "0" {
        //
        //
        //            self.txtFieldAddress.textAlignment = .left
        //            txtViewNotes.textAlignment = .left
        //
        //        }else{
        //
        //            self.txtFieldAddress.textAlignment = .right
        //            txtViewNotes.textAlignment = .right
        //        }
        
        
        txtFieldAddress.delegate = self
        
        txtFieldAddress.layer.borderWidth = 1;
        //        self.layer.cornerRadius = 1
        txtFieldAddress.layer.borderColor = UIColor.lightGray.cgColor
        //        self.clipsToBounds = true
        let paddingView = UIView(frame: CGRect.init(x: 0, y: 0, width: 10, height: 30))
        txtFieldAddress.leftView = paddingView
        txtFieldAddress.leftViewMode = .always
        //        txtFieldAddress.layer.masksToBounds = false
        
        
        
        self.txtFieldAddress.placeholder = "Select Address".localized
        self.lbl_Heading.text = "Booking".localized
        self.lbl_Text.text = "Step 3: Booking".localized
        self.lbl_Image.text = "ADD PHOTO".localized
        self.lbl_Video.text = "ADD VIDEO".localized
        self.lbl_BookNow.setTitle("BOOK NOW".localized, for: .normal)
        self.lbl_TotalBill.text = "Total Bill :".localized
        self.lbl_HeadingTime.text = "What time would you like us to start?".localized
        self.lbl_Instruction.text = "Any Special Instructions?".localized
        self.lbl_HeadingAddress.text = "Address".localized
        self.lbl_HeadingServices.text = "When would you like your Service?".localized
        
        self.txtViewNotes.text = instructionPlaceHolder
        self.txtViewNotes.textColor = UIColor.gray
        self.Collection_View.register(UINib.init(nibName: "SelectDateCell", bundle: nil), forCellWithReuseIdentifier: "SelectDateCell")
        self.tbl_time_slot.register(UINib(nibName: "BookingTimeSlotCell", bundle: nil), forCellReuseIdentifier: "BookingTimeSlotCell")
        
        dates = self.getDates()
        print(dates)
        self.Collection_View.reloadData()
        //        var selectedDate = self.dates[selected_index]["date"] as! String
        //        selectedDate = selectedDate.components(separatedBy: " ").first!
        //
        //        let currentTime = Date().timeIntervalSince1970
        //        let startTime = selectedDate + " " + (tbleArrayMAin.first?.components(separatedBy: " - ").first)!
        //        let startTimeseconds = getTimeInt(mainString: startTime, Withformate: "YYYY-MM-dd hh:mm a")
        
        
        if self.currentTimeIsBetweenSlots(){
            customDatesAndTimes()
            
        }
        else{
            usePlaneDateAndTimes()
        }
        
        
        //        self.tbleArray = [String]()
        //
        //        var indexmain = 0
        //
        //        for indexObj in self.HoursArray {
        //            if Int(indexObj)! > Int(hoursNow)! {
        //                if indexmain < tbleArrayMAin.count {
        //                    self.tbleArray.append(self.tbleArrayMAin[indexmain])
        //                }
        //            }
        //            indexmain = indexmain + 1
        //        }
        ////        self.count = 0
        //        self.count = self.tbleArray.count
        //        self.tbl_time_slot.reloadData()
        //        self.view.layoutIfNeeded()
        //        self.tbl_time_slot.layoutIfNeeded()
        
        
        if currency == "2" {
            self.lblTotalBill.text = "AED 0"
        }else {
            self.lblTotalBill.text = "OMR 0"
        }
        
        self.txtEnterMeter.addTarget(self, action: #selector(BookingMainVC.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        self.isSelectChargeType = false
        self.txtEnterMeter.isEnabled = false
        self.txtEnterMeter.placeholder = "Enter Meter".localized
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if isArabic() {
            
           Collection_View.semanticContentAttribute = .forceRightToLeft
        } else {
            
            Collection_View.semanticContentAttribute = .forceLeftToRight
        }
    }
    func currentTimeIsBetweenSlots() -> Bool{
        var selectedDate = self.dates[selected_index]["date"] as! String
        selectedDate = selectedDate.components(separatedBy: " ").first!
        
        let currentTime = Date().timeIntervalSince1970
        let startTime = selectedDate + " " + (tbleArrayMAin.first?.components(separatedBy: " - ").first)!
        let startTimeseconds = getTimeInt(mainString: startTime, Withformate: "YYYY-MM-dd hh:mm a")
        
        
        return  startTimeseconds < currentTime
    }
    @objc private func textFieldDidChange(_ textField: UITextField)
    {
        // print(textField.text!)
        
        let rateMeter = self.companyData["rate_per_meter"] as! [String : Any]
        let rateMeterPrice = rateMeter["usd"] as! [String : Any]
        let rateMeterPriceAED = rateMeter["aed"] as! [String : Any]
        
        //  print(rateMeter)
        
        if(textField.text == "" || textField.text == nil)
        {
            
        }
        else
        {
            if currency == "2"
            {
                self.lblTotalBill.text = "AED" + String(Double(textField.text!)! * (rateMeterPriceAED["amount"] as! Double) )
            }
            else
            {
                if(textField.text == "")
                {
                    textField.text = "0"
                }
                print(textField.text)
                print(rateMeterPrice["amount"])
                self.lblTotalBill.text = "OMR" + String(Double(self.txtEnterMeter.text!)! * (rateMeterPrice["amount"] as! Double)  )
            }
        }
        
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        print(self.servicesSelected)
        print(self.HoursArray)
        print(self.tbleArrayMAin)
        
    }
    
    @IBAction func btnRatePerHourClick(_ sender: Any)
    {
        self.radioRatePerHour.image = #imageLiteral(resourceName: "radio_button_check")
        self.radioRatePerMeter.image = #imageLiteral(resourceName: "radio_button_uncheck")
        self.isSelectChargeType = false
        self.txtEnterMeter.isEnabled = false
        self.txtEnterMeter.placeholder = "Enter Meter"
    }
    
    @IBAction func btnRatePerMeterClick(_ sender: Any)
    {
        self.radioRatePerHour.image = #imageLiteral(resourceName: "radio_button_uncheck")
        self.radioRatePerMeter.image = #imageLiteral(resourceName: "radio_button_check")
        self.isSelectChargeType = true
        self.txtEnterMeter.isEnabled = true
        self.txtEnterMeter.placeholder = "Enter Meter"
    }
    
    
    
    @IBAction func OnClickBack(_ sender: Any) {
        self.Back()
        self.Dismiss()
    }
    
    @IBAction func SubmitBooking(_ sender: Any) {
        
        if self.txtFieldAddress.text?.count == 0 {
            self.ShowErrorAlert(message: "Select Address".localized)
            return
        }
        
        if self.time_slot_Start_position < 0 || self.time_slot_end_position < 0 {
            self.ShowErrorAlert(message: "Select time slots".localized)
            return
        }
        
        if self.txtViewNotes.text == "" || self.txtViewNotes.text == instructionPlaceHolder{
            self.ShowErrorAlert(message: "Please write instructions".localized)
            return
        }
        
        
        var newPAram = [String : Any]()
        newPAram["address_id"] = String(self.chooseAddress["id"] as! Int)
        newPAram["instruction"] = self.txtViewNotes.text
        newPAram["company_id"] = String(self.companyData["id"] as! Int)
        
        var selectedDate = self.dates[selected_index]["date"] as! String
        selectedDate = selectedDate.components(separatedBy: " ").first!
        
        //        newPAram["booking_date"] = String(Int(self.getTimeInt(mainString:selectedDate , Withformate: "YYYY-MM-dd"))) as AnyObject
        //        print(self.dates[selected_index])
        
        //        let dateObj : String = self.dates[selected_index]["date"] as! String
        //        let dateString = dateObj.components(separatedBy: " ")[0]
        
        if(self.isSelectChargeType == false)
        {
            newPAram["payment_check"] = "rate_per_hour"
        }
        else
        {
            newPAram["payment_check"] = "rate_per_meter"
            newPAram["no_of_meters"] = self.txtEnterMeter.text
        }
        
        //        var arrStart = (self.dates[selected_index]["date"] as! String).components(separatedBy: " ")
        
        
        
        
        
        
        var stringTime = ""//self.tbleArray[self.time_slot_Start_position]
        var arrStartTime : [String] = []//stringTime.components(separatedBy: " - ")
        
        if self.tbleArray.count > 0 {
            stringTime = self.tbleArray[self.time_slot_Start_position]
            arrStartTime = stringTime.components(separatedBy: " - ")
        }
        else{
            self.ShowErrorAlert(message: "Company's working hours have been passed".localized)
            return
        }
        
        
        var EndTime = ""//self.tbleArray[self.time_slot_end_position]
        var arrEndTime : [String] = []//EndTime.components(separatedBy: " - ")
        
        
        if self.tbleArray.count > time_slot_end_position  {
            
            EndTime = self.tbleArray[self.time_slot_end_position]
            arrEndTime = EndTime.components(separatedBy: " - ")
            
        }
        else{
            EndTime = self.tbleArray[self.tbleArray.count - 1]
            arrEndTime = EndTime.components(separatedBy: " - ")
        }
        
        
        
        newPAram["start_time"] = String(Int(self.getTimeInt(mainString:(selectedDate + " " + arrStartTime[0] ) , Withformate: "YYYY-MM-dd hh:mm a", isArabic: self.isArabic() ))) as AnyObject
        
        newPAram["booking_date"] = newPAram["start_time"]
        
        newPAram["end_time"] = String(Int(self.getTimeInt(mainString:(selectedDate + " " + arrEndTime[1] ) , Withformate: "YYYY-MM-dd hh:mm a", isArabic: self.isArabic() ))) as AnyObject
        
        
        var indexService = 0
        for indexObj in self.servicesSelected {
            newPAram[String.init(format:"services[%d]",indexService)] = String(indexObj["id"] as! Int) as AnyObject
            indexService = indexService + 1
        }
        //        return
        print(newPAram)
        
        if self.isImagechoose && self.isvideochoose {
            
            ProgressHUD.present(animated: true)
            NetworkManager.UploadVideo("user/bookings/store", imageMain: self.imgViewMain.image, urlVideo: self.videoUrl!,imageName: "image[0]", withParams: newPAram as Dictionary<String, AnyObject>, onView: self, completion: { (mainResponse) in
                print(mainResponse)
                ProgressHUD.dismiss(animated: true)
                if (mainResponse?["status_code"] as! Int)  == 200 {
                    self.ShowSuccessAlertWithHome(message: (mainResponse?["message"] as! String))
                }else {
                    self.ShowErrorAlert(message: (mainResponse?["message"] as! String))
                }
                
            }, progress: { (counter) in
                let text = "\(counter)% completed"
                ProgressHUD.progress(text: text)
            })
        }else if self.isImagechoose{
            
            ProgressHUD.present(animated: true)
            NetworkManager.UploadFiles("user/bookings/store", image: self.imgViewMain.image!,imageName : "image[0]", withParams: newPAram as Dictionary<String, AnyObject>, onView: self, completion: { (mainResponse) in
                print(mainResponse)
                ProgressHUD.dismiss(animated: true)
                if (mainResponse?["status_code"] as! Int)  == 200 {
                    self.ShowSuccessAlertWithHome(message: (mainResponse?["message"] as! String))
                    
                }else {
                    self.ShowErrorAlert(message: (mainResponse?["message"] as! String))
                }
            
            }, progress: { (counter) in
             let text = "\(counter)% completed"
                ProgressHUD.progress(text: text)
            })
            
            
        }else if self.isvideochoose{
            
           ProgressHUD.present(animated: true)
            NetworkManager.UploadVideo("user/bookings/store", urlVideo: self.videoUrl!, withParams: newPAram as Dictionary<String, AnyObject>, onView: self, completion: { (mainResponse) in
                print(mainResponse)
                ProgressHUD.dismiss(animated: true)
                if (mainResponse?["status_code"] as! Int)  == 200 {
                    self.ShowSuccessAlertWithHome(message: (mainResponse?["message"] as! String))
                }else {
                    self.ShowErrorAlert(message: (mainResponse?["message"] as! String))
                }
            }, progress: { (counter) in
                let text = "\(counter)% completed"
                ProgressHUD.progress(text: text)
            })
        }else {
            
           ProgressHUD.present(animated: true)
            
            NetworkManager.post("user/bookings/store", isLoading: true, withParams: newPAram as [String : AnyObject], onView: self) { (mainResponse) in
                print(mainResponse)
                ProgressHUD.dismiss(animated: true)
                if (mainResponse?["status_code"] as! Int)  == 200 {
                    
                    self.ShowSuccessAlertWithHome(message: (mainResponse?["message"] as! String))
                    
                }else {
                    
                    self.ShowErrorAlert(message: (mainResponse?["message"] as! String))
                }
            }
        }
        
    }
    

    
    //MARK : Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.lblEmptyTable.text = "Company working hours passed. Please select another date".localized
        if count == 0 {
            self.Constraint_tbl_height.constant = CGFloat(1 * 50)
            self.lblEmptyTable.isHidden = false
        }else {
            self.Constraint_tbl_height.constant = CGFloat(count * 50)
            self.lblEmptyTable.isHidden = true
        }
        
        return  count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "BookingTimeSlotCell") as! BookingTimeSlotCell
        cell.selectionStyle = .none
        
        
        
        print(self.time_slot_Start_position)
        print("self.time_slot_Start_position")
        print(self.time_slot_end_position)
        print("time_slot_end_position")
        if indexPath.row >= self.time_slot_Start_position && indexPath.row <= self.time_slot_end_position && self.time_slot_end_position > -1 && self.time_slot_Start_position > -1{
            cell.main_view.backgroundColor = UIColor.init(red: 96/255, green: 175/255, blue: 85/255, alpha: 1.0)
            cell.LBL_Avail.textColor = UIColor.white
            cell.Lbl_Time.textColor = UIColor.white
        }else{
            cell.main_view.backgroundColor = UIColor.clear
            cell.LBL_Avail.textColor = UIColor.darkGray
            cell.Lbl_Time.textColor = UIColor.darkGray
        }
        cell.Lbl_Time.text = self.tbleArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(self.time_slot_Start_position)
        print("self.time_slot_Start_position")
        
        print(self.time_slot_end_position)
        print("time_slot_end_position")
        
        
        if currency == "2" {
            self.lblTotalBill.text = "AED 0"
        }else {
            self.lblTotalBill.text = "OMR 0"
        }
        
        
        print(init_point)
        print("init_point")
        
        if self.time_slot_Start_position == -1 {
            //            if indexPath.row == self.time_slot_Start_position && indexPath.row == self.time_slot_end_position && indexPath.row == init_point {
            //                self.time_slot_Start_position = -1
            ////                self.time_slot_end_position = -1
            //                init_point = 0
            //            }else if  init_point == 0 {
            //                self.time_slot_Start_position = indexPath.row
            ////                self.time_slot_end_position = indexPath.row
            //                init_point = indexPath.row
            //            }else  if indexPath.row < init_point {
            //
            //
            ////                self.time_slot_end_position = self.init_point
            //                self.time_slot_Start_position = indexPath.row
            //
            //            }else if indexPath.row > init_point{
            //                self.time_slot_Start_position = indexPath.row
            ////                self.time_slot_end_position = indexPath.row
            //            } else if indexPath.row == self.time_slot_Start_position {
            //                self.time_slot_Start_position = indexPath.row
            ////                self.time_slot_end_position = indexPath.row
            //            }else if indexPath.row == self.time_slot_end_position {
            //
            //                //            if self.time_slot_Start_position > -1 {
            ////                self.time_slot_end_position = indexPath.row
            //                //            }
            
            
            self.time_slot_Start_position = indexPath.row
            self.time_slot_end_position = indexPath.row
            init_point = self.time_slot_Start_position
            //            }
        }else if self.time_slot_end_position == -1 {
            
            //            if indexPath.row == self.time_slot_Start_position && indexPath.row == self.time_slot_end_position && indexPath.row == init_point {
            //                self.time_slot_Start_position = -1
            //                self.time_slot_end_position = -1
            //                init_point = 0
            //            }else if  init_point == 0 {
            ////                self.time_slot_Start_position = indexPath.row
            //                self.time_slot_end_position = indexPath.row
            //                init_point = indexPath.row
            //            }else  if indexPath.row < init_point {
            //
            //
            //                self.time_slot_end_position = indexPath.row
            ////                self.time_slot_Start_position = indexPath.row
            //
            //            }else if indexPath.row > init_point{
            ////                self.time_slot_Start_position = self.init_point
            //                self.time_slot_end_position = indexPath.row
            //            } else if indexPath.row == self.time_slot_Start_position {
            ////                self.time_slot_Start_position = indexPath.row
            //                self.time_slot_end_position = indexPath.row
            //            }else if indexPath.row == self.time_slot_end_position {
            
            if self.time_slot_Start_position !=  indexPath.row {
                self.time_slot_end_position = indexPath.row
                init_point = self.time_slot_Start_position
            }
            
            
            //                self.time_slot_Start_position = indexPath.row
            //            }
        }else {
            print(init_point)
            if indexPath.row == self.time_slot_Start_position && indexPath.row == self.time_slot_end_position && indexPath.row == init_point {
                self.time_slot_Start_position = -1
                self.time_slot_end_position = -1
                init_point = -1
                //            }else if  init_point == 0 {
                //                self.time_slot_Start_position = indexPath.row
                //                self.time_slot_end_position = indexPath.row
                //                init_point = indexPath.row
            }else  if indexPath.row < init_point {
                
                
                self.time_slot_end_position = self.init_point
                self.time_slot_Start_position = indexPath.row
                
            }else if indexPath.row > init_point{
                self.time_slot_Start_position = self.init_point
                self.time_slot_end_position = indexPath.row
            } else if indexPath.row == self.time_slot_Start_position {
                self.time_slot_Start_position = indexPath.row
                self.time_slot_end_position = indexPath.row
            }else if indexPath.row == self.time_slot_end_position {
                
                self.time_slot_end_position = indexPath.row
                
                self.time_slot_Start_position = indexPath.row
            }
        }
        
        
        
        
        print(self.time_slot_Start_position)
        print(self.time_slot_end_position)
        self.tbl_time_slot.reloadData()
        
        if self.time_slot_end_position > -1 {
            var countMain = self.time_slot_end_position - self.time_slot_Start_position
            
            if countMain < 0 {
                countMain = self.time_slot_end_position * -1
            }
            
            countMain = countMain + 1
            let newRate = self.companyData["rate_per_hour"] as? [String : AnyObject]
            
            let rateDict = newRate!["usd"] as! [String : AnyObject]
             let rateDictAED = newRate!["aed"] as! [String : AnyObject]
            let rateMeter = self.companyData["rate_per_meter"] as! [String : Any]
            let rateMeterPrice = rateMeter["usd"] as! [String : Any]
            
            if currency == "2"
            {
                if (self.isSelectChargeType == false)
                {
                    
                    self.lblTotalBill.text = "AED" + String(Double(countMain) * (rateDictAED["amount"] as! Double) * Double(servicesSelected.count))
                }
                else
                {
                    // self.lblTotalBill.text = "AED" + String(Double(self.txtEnterMeter.text!)! * (rateMeterPrice["amount"] as! Double) )
                }
                
            }
            else
            {
                if (self.isSelectChargeType == false)
                {
                    self.lblTotalBill.text = "OMR" + String(Double(countMain) * (rateDict["amount"] as! Double) * Double(servicesSelected.count))
                }
                else
                {
                    //self.lblTotalBill.text = "OMR" + String(Double(self.txtEnterMeter.text!)! * (rateMeterPrice["amount"] as! Double) )
                }
                
            }
            
            
        }
        
        
        
    }
    
    //MARK : Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (self.Collection_View.bounds.size.width/7) , height: (self.Collection_View.bounds.size.height))
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectDateCell", for: indexPath) as! SelectDateCell
        var data  = self.dates[indexPath.row]
         var monthname = data["mnth"] as? String
        cell.lbl_mnth.text = monthname?.localized // data["mnth"] as? String
        let dayname = data["day_name"] as? String
        cell.lbl_day_name.text = dayname?.localized //data["day_name"] as? String
        cell.lbl_day_number.text = data["day_no"] as? String
        if  indexPath.row == selected_index  {
            cell.Select()
        }else{
            cell.UnSelect()
        }
        return cell
    }
    func customDatesAndTimes(){
        var selectedDate = self.dates[selected_index]["date"] as! String
        selectedDate = selectedDate.components(separatedBy: " ").first!
        
        
        let startTime = Date().timeIntervalSince1970 + 3600
        let diffrence : Double = 3600
        //            let timeArray = tbleArrayMAin.last?.components(separatedBy: " ")
        
        
        
        let endTime = selectedDate + " " + (tbleArrayMAin.last?.components(separatedBy: " - ").last)!
        let endTimeSeconds = getTimeInt(mainString: endTime, Withformate: "YYYY-MM-dd hh:mm a")
        self.tbleArray = [String]()
        
        for time in stride(from: startTime, to: (endTimeSeconds - diffrence), by: diffrence) {
            let startHour = self.GetStringFromDate(dateMain: Date(timeIntervalSince1970: time), formate: "hh:mm a")
            let endHour = self.GetStringFromDate(dateMain: Date(timeIntervalSince1970: time+diffrence), formate: "hh:mm a")
            tbleArray.append(startHour + " - " + endHour)
        }
        self.count = self.tbleArray.count
        self.tbl_time_slot.reloadData()
        self.view.layoutIfNeeded()
        self.tbl_time_slot.layoutIfNeeded()
    }
    func usePlaneDateAndTimes(){
        self.tbleArray = [String]()
        
        var indexmain = 0
        
        for _ in self.HoursArray {
            //                if Int(indexObj)! > Int(hoursNow)! {
            if indexmain < tbleArrayMAin.count {
                self.tbleArray.append(self.tbleArrayMAin[indexmain])
            }
            //                }
            indexmain = indexmain + 1
        }
        
        self.count = self.tbleArray.count
        self.tbl_time_slot.reloadData()
        self.view.layoutIfNeeded()
        self.tbl_time_slot.layoutIfNeeded()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        time_slot_Start_position = -1
//        time_slot_end_position = -1
        
        if selected_index == indexPath.row {
            return
        }
        time_slot_Start_position = -1
        time_slot_end_position = -1
        self.isNew = false
        self.selected_index = indexPath.row
        self.Collection_View.reloadData()
        
        
        if indexPath.row == 0 {
            if currentTimeIsBetweenSlots(){
                customDatesAndTimes()
            }
            else{
                usePlaneDateAndTimes()
            }
            
            return
            
            
            //            var selectedDate = self.dates[selected_index]["date"] as! String
            //            selectedDate = selectedDate.components(separatedBy: " ").first!
            //
            //
            //            let startTime = Date().timeIntervalSince1970 + 3600
            //            let diffrence : Double = 3600
            ////            let timeArray = tbleArrayMAin.last?.components(separatedBy: " ")
            //
            //
            //
            //            let endTime = selectedDate + " " + (tbleArrayMAin.last?.components(separatedBy: " - ").last)!
            //            let endTimeSeconds = getTimeInt(mainString: endTime, Withformate: "YYYY-MM-dd hh:mm a")
            //            self.tbleArray = [String]()
            //
            //            for time in stride(from: startTime, to: (endTimeSeconds - diffrence), by: diffrence) {
            //                let startHour = self.GetStringFromDate(dateMain: Date(timeIntervalSince1970: time), formate: "hh:mm a")
            //                let endHour = self.GetStringFromDate(dateMain: Date(timeIntervalSince1970: time+diffrence), formate: "hh:mm a")
            //                tbleArray.append(startHour + " - " + endHour)
            //            }
            //
            //
            //
            //
            ////            let hoursNow = self.GetStringFromDate(dateMain: Date(), formate: "HH")
            ////            let startHour = self.GetStringFromDate(dateMain: Date(timeIntervalSince1970: startTime), formate: "hh:mm a")
            ////
            ////
            ////
            ////            var indexmain = 0
            ////
            ////            for indexObj in self.HoursArray {
            ////                if Int(indexObj)! > Int(hoursNow)! {
            ////                    if indexmain < tbleArrayMAin.count {
            ////                        self.tbleArray.append(self.tbleArrayMAin[indexmain])
            ////                    }
            ////                }
            ////                indexmain = indexmain + 1
            ////            }
            //
            //            self.count = self.tbleArray.count
            //            self.tbl_time_slot.reloadData()
            //            self.view.layoutIfNeeded()
            //            self.tbl_time_slot.layoutIfNeeded()
            
        }else {
            //            let hoursNow = self.GetStringFromDate(dateMain: Date(), formate: "HH")
            usePlaneDateAndTimes()
            
            //            self.tbleArray = [String]()
            //
            //            var indexmain = 0
            //
            //            for indexObj in self.HoursArray {
            ////                if Int(indexObj)! > Int(hoursNow)! {
            //                    if indexmain < tbleArrayMAin.count {
            //                        self.tbleArray.append(self.tbleArrayMAin[indexmain])
            //                    }
            ////                }
            //                indexmain = indexmain + 1
            //            }
            //
            //            self.count = self.tbleArray.count
            //            self.tbl_time_slot.reloadData()
            //            self.view.layoutIfNeeded()
            //            self.tbl_time_slot.layoutIfNeeded()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? SelectDateCell {
                cell.contentView.transform = .init(scaleX: 0.95, y: 0.95)
                cell.contentView.backgroundColor = UIColor(red: 0.37, green: 0.68, blue: 0.33, alpha: 0.23)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? SelectDateCell {
                cell.contentView.transform = .identity
                cell.contentView.backgroundColor = .clear
            }
        }
    }
    
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//
//        print("TextField Tag :\(textField.tag)")
//        if textField.tag == 555 {
//            let mainVc = self.GetView(nameViewController: "AddressBookVC", nameStoryBoard: "Main") as! AddressBookVC
//            mainVc.isChoose = true
//            mainVc.delegate = self
//            self.navigationController?.pushViewController(mainVc, animated: true)
//
//            return false
//        }
//        else{
//            return false
//        }
//
//        //        return true
//
//    }
//
    func SelectedAddress(address: [String : AnyObject])
    {
        self.chooseAddress = address
        self.txtFieldAddress.text = address["address"] as! String
        
    }
    
    
    @IBAction func AddImage(sender : UIButton){
        self.showMediaChoosingOptions()
        self.isImageSelect = true
    }
    
    @IBAction func AddVideo(sender : UIButton){
        self.isImageSelect = false
        self.showVideoChoosingOptions()
    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        //    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//
//        self.dismiss(animated: true, completion: { () -> Void in
//
//        })
//
//        if self.isImageSelect {
//            self.imgViewMain.image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
//            self.isImagechoose = true
//            self.btnImage.isHidden = false
//        }else {
//            self.videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL
//            self.imgViewVideo.image = self.getThumbnailFrom(path:self.videoUrl!)
//            self.isvideochoose = true
//            self.btnPlayVideo.isHidden = false
//            self.btnVideo.isHidden = false
//        }
//
//    }
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        self.dismiss(animated: true, completion: { () -> Void in
//
//        })
//    }
    override func selectedVideo(url: URL) {
        self.videoUrl = url//info[UIImagePickerController.InfoKey.mediaURL] as? URL
        self.imgViewVideo.image = self.getThumbnailFrom(path:self.videoUrl!)
        self.isvideochoose = true
        self.btnPlayVideo.isHidden = false
        self.btnVideo.isHidden = false
    }
    override func selectedImage(image: UIImage) {
        self.imgViewMain.image = image//info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        self.isImagechoose = true
        self.btnImage.isHidden = false
    }
    
    func getThumbnailFrom(path: URL) -> UIImage? {
        
        do {
            
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            
            return thumbnail
            
        } catch let error {
            
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
            
        }
        
    }
    
    @IBAction func RemoveImage(sender : UIButton){
        self.imgViewMain.image = nil
        self.btnImage.isHidden = true
        
    }
    
    @IBAction func RemoveVideo(sender : UIButton){
        self.imgViewVideo.image = nil
        self.btnVideo.isHidden = true
        self.btnPlayVideo.isHidden = true
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == instructionPlaceHolder {
            textView.text = ""
            self.txtViewNotes.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = instructionPlaceHolder
            self.txtViewNotes.textColor = UIColor.gray
        }
    }
    
}

extension BookingMainVC : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        print("TextField Tag :\(textField.tag)")
        if textField.tag == 555 {
            let mainVc = self.GetView(nameViewController: "AddressBookVC", nameStoryBoard: "Main") as! AddressBookVC
            mainVc.isChoose = true
            mainVc.delegate = self
            self.navigationController?.pushViewController(mainVc, animated: true)
            
            return false
        }
        else{
            return false
        }
        
        //        return true
        
    }
}
