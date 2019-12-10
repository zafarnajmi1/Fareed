//
//  UpdateScheduleViewController.swift
//  Cleaning & Servent
//
//  Created by waseem on 28/04/2018.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class UpdateScheduleViewController: BaseViewController,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout , UITableViewDelegate , UITableViewDataSource   {
    
    @IBOutlet var lbl_Heading : UILabel!
    @IBOutlet var lbl_Text : UILabel!
    @IBOutlet var lbl_HeadingServices : UILabel!
    @IBOutlet var lbl_HeadingTime : UILabel!
//    @IBOutlet var lbl_HeadingAddress : UILabel!
//    @IBOutlet var lbl_Instruction : UILabel!
//    @IBOutlet var lbl_Video : UILabel!
//    @IBOutlet var lbl_Image : UILabel!
    @IBOutlet var lbl_TotalBill : UILabel!
    @IBOutlet var lbl_BookNow : UIButton!
    var selectedServicesCount = 0
    
    @IBOutlet weak var imgViewBack: UIImageView!
    @IBOutlet var lblTotalBill : UILabel!
    @IBOutlet var lblEmptyTable : UILabel!
    
    
    var init_point : Int = 07
    var count : Int  = 0
    var time_slot_Start_position : Int = -1
    var time_slot_end_position : Int = -1
    

    @IBOutlet weak var tbl_time_slot: UITableView!
    
    var companyData = [String : Any]()
    var mainData = [String : Any]()
    
    var tbleArray = [String]()
    var tbleArrayMAin = [String]()
    var HoursArray = [String]()
    
    @IBOutlet weak var Constraint_tbl_height: NSLayoutConstraint!
    var isNew : Bool = true
    var selected_index : Int = 0
    var dates  = [[String : Any]]()
    
    @IBOutlet weak var Collection_View: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
        }
        self.Collection_View.register(UINib.init(nibName: "SelectDateCell", bundle: nil), forCellWithReuseIdentifier: "SelectDateCell")
        self.tbl_time_slot.register(UINib(nibName: "BookingTimeSlotCell", bundle: nil), forCellReuseIdentifier: "BookingTimeSlotCell")
        
        
        self.lbl_Heading.text = "Booking".localized
        self.lbl_Text.text = "Step 3: Booking".localized
//        self.lbl_Image.text = "ADD PHOTO".localized
//        self.lbl_Video.text = "ADD VIDEO".localized
        self.lbl_BookNow.setTitle("BOOK NOW".localized, for: .normal)
        self.lbl_TotalBill.text = "Total Bill :".localized
        self.lbl_HeadingTime.text = "What time would you like us to start?".localized
            //"Which time would you like us to start?".localized
//        self.lbl_Instruction.text = "Any Special Instructions?".localized
//        self.lbl_HeadingAddress.text = "Address".localized
        self.lbl_HeadingServices.text = "When would you like your Service?".localized
        
        dates = self.getDates()
        print(dates)
        self.Collection_View.reloadData()
        
        
        let hoursNow = self.GetStringFromDate(dateMain: Date(), formate: "HH")
        
        self.tbleArray = [String]()
        
        var indexmain = 0
        
        for indexObj in self.HoursArray {
            if Int(indexObj)! > Int(hoursNow)! {
                if indexmain < tbleArrayMAin.count {
                    self.tbleArray.append(self.tbleArrayMAin[indexmain])
                }
            }
            indexmain = indexmain + 1
        }
        //        self.count = 0
        self.count = self.tbleArray.count
        self.tbl_time_slot.reloadData()
        self.view.layoutIfNeeded()
        self.tbl_time_slot.layoutIfNeeded()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    
    @IBAction func OnClickBack(_ sender: Any) {
        self.Back()
        self.Dismiss()
    }
    
    @IBAction func SubmitBooking(_ sender: Any) {
        
        
        var newPAram = [String : Any]()
        newPAram["id"] = String(self.mainData["id"] as! Int)
        
        
        var selectedDate = self.dates[selected_index]["date"] as! String
        selectedDate = selectedDate.components(separatedBy: " ").first!
        
        newPAram["booking_date"] = String(Int(self.getTimeInt(mainString:selectedDate , Withformate: "YYYY-MM-dd"))) as AnyObject
        print(self.dates[selected_index])
        
        
//        var arrStart = (self.dates[selected_index]["date"] as! String).components(separatedBy: " ")
//
//        print(arrStart)
        
        if(self.time_slot_Start_position == -1){
            let alert = UIAlertController(title: "Alert".localized, message: "Select time slots".localized, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else{
        let stringTime = self.tbleArray[self.time_slot_Start_position]
        var arrStartTime = stringTime.components(separatedBy: " - ")
        
        
        let EndTime = self.tbleArray[self.time_slot_end_position]
        var arrEndTime = EndTime.components(separatedBy: " - ")
        
        newPAram["start_time"] = String(Int(self.getTimeInt(mainString:(selectedDate + " " + arrStartTime[0]) , Withformate: "YYYY-MM-dd hh:mm a"))) as AnyObject
        
        newPAram["end_time"] = String(Int(self.getTimeInt(mainString:(selectedDate + " " + arrEndTime[1]) , Withformate: "YYYY-MM-dd hh:mm a"))) as AnyObject
        
            print(newPAram)
        self.showLoading()
            NetworkManager.post("user/bookings/update", isLoading: true, withParams: newPAram as [String : AnyObject], onView: self) { (mainResponse) in
                print(mainResponse)
                self.hideLoading()
                if (mainResponse?["status_code"] as! Int)  == 200 {
                    self.ShowSuccessAlert(message: (mainResponse?["message"] as! String))
                    
                }else {
                    self.hideLoading()
                    self.ShowErrorAlert(message: (mainResponse?["message"] as! String))
                }
            }
        }
        
    }
    
    //MARK : Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        if indexPath.row >= self.time_slot_Start_position && indexPath.row <= self.time_slot_end_position {
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
//        if indexPath.row == self.time_slot_Start_position && indexPath.row == self.time_slot_end_position && indexPath.row == init_point {
//            self.time_slot_Start_position = -1
//            self.time_slot_end_position = -1
//            init_point = 0
//        }else if  init_point == 0 {
//            self.time_slot_Start_position = indexPath.row
//            self.time_slot_end_position = indexPath.row
//            init_point = indexPath.row
//        }else  if indexPath.row < init_point {
//            self.time_slot_Start_position = indexPath.row
//            self.time_slot_end_position = self.init_point
//        }else if indexPath.row > init_point{
//            self.time_slot_Start_position = self.init_point
//            self.time_slot_end_position = indexPath.row
//        } else if indexPath.row == self.time_slot_Start_position {
//            self.time_slot_Start_position = indexPath.row
//            self.time_slot_end_position = indexPath.row
//        }else if indexPath.row == self.time_slot_end_position {
//            self.time_slot_end_position = indexPath.row
//            self.time_slot_Start_position = indexPath.row
//        }
//        print(self.time_slot_Start_position)
//        print(self.time_slot_end_position)
//        self.tbl_time_slot.reloadData()
//
//        var countMain = self.time_slot_end_position - self.time_slot_Start_position
//
//        if countMain < 0 {
//            countMain = self.time_slot_end_position * -1
//        }
//
//        countMain = countMain + 1
//        let newRate = self.companyData["rate_per_hour"] as? [String : AnyObject]
//
//        let rateDict = newRate!["usd"] as! [String : AnyObject]
//
//        self.lblTotalBill.text = String(Double(countMain) * (rateDict["amount"] as! Double) )

        print(self.time_slot_Start_position)
        print("self.time_slot_Start_position")
        
        print(self.time_slot_end_position)
        print("time_slot_end_position")
        
        
        if UserDefaults.standard.value(forKey: "Currency") as? String == "2" {
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
            
            
            if UserDefaults.standard.value(forKey: "Currency") as? String == "2" {
                self.lblTotalBill.text = "AED" + String(Double(countMain) * (rateDict["amount"] as! Double) * Double(self.selectedServicesCount) )
            }else {
                self.lblTotalBill.text = "OMR" + String(Double(countMain) * (rateDict["amount"] as! Double) * Double(self.selectedServicesCount))
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
        cell.lbl_mnth.text = data["mnth"] as? String
        cell.lbl_day_name.text = data["day_name"] as? String
        cell.lbl_day_number.text = data["day_no"] as? String
        if  indexPath.row == selected_index  {
            cell.Select()
        }else{
            cell.UnSelect()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selected_index == indexPath.row {
            return
        }
        time_slot_Start_position = -1
        time_slot_end_position = -1
        
        self.isNew = false
        self.selected_index = indexPath.row
        self.Collection_View.reloadData()
        
        
        if indexPath.row == 0 {
            let hoursNow = self.GetStringFromDate(dateMain: Date(), formate: "HH")
            
            self.tbleArray = [String]()
            
            var indexmain = 0
            
            for indexObj in self.HoursArray {
                if Int(indexObj)! > Int(hoursNow)! {
                    if indexmain < tbleArrayMAin.count {
                        self.tbleArray.append(self.tbleArrayMAin[indexmain])
                    }
                }
                indexmain = indexmain + 1
            }
            
            self.count = self.tbleArray.count
            self.tbl_time_slot.reloadData()
            self.view.layoutIfNeeded()
            self.tbl_time_slot.layoutIfNeeded()
            
        }else {
            //            let hoursNow = self.GetStringFromDate(dateMain: Date(), formate: "HH")
            
            self.tbleArray = [String]()
            
            var indexmain = 0
            
            print(self.HoursArray)
            print(tbleArrayMAin)
            for indexObj in self.HoursArray {
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
}

