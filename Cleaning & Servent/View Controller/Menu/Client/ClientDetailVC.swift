//
//  ClientDetailVC.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 4/4/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class ClientDetailVC: BaseViewController , UITableViewDataSource , UITableViewDelegate {

    @IBOutlet weak var date_picker_view: UIView!
    @IBOutlet weak var TBL_Client_details: UITableView!
    
    var clientdata : [String : Any]? = [:]
    
    @IBOutlet weak var imgViewBAck: UIImageView!
    @IBOutlet weak var Name: UILabel!
    var arrayBooking = [[String : Any]]()
    
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblPhone : UILabel!
    @IBOutlet var lblVisitCount : UILabel!
    @IBOutlet var imgViewMain : UIImageView!
    
    @IBOutlet var lbl_bookingHistory : UILabel!
    @IBOutlet var lbl_date : UILabel!
    @IBOutlet var btn_clear : UIButton!
    @IBOutlet var lc_tableViewViewTop : NSLayoutConstraint!
    @IBOutlet var dpkr_picker : UIDatePicker!
    
    
    var currency : String {
        get {
            return DataManager.sharedInstance.getSelectedCurrency()
        }
    }
    
    var dateSeconds : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        if self.isArabic() {
            self.imgViewBAck.image = #imageLiteral(resourceName: "backArabic")
        }
        self.TBL_Client_details.register(UINib(nibName: "BookingDetailCell", bundle: nil), forCellReuseIdentifier: "BookingDetailCell")
        let name = self.clientdata?["full_name"] as? String
        self.Name.text = name
        lbl_bookingHistory.text = "Booking History".localized
        btn_clear.setTitle("Clear".localized, for: .normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if self.arrayBooking.count == 0 {
            self.APICAll()
        }
    }
    
    func APICAll(){
        self.arrayBooking.removeAll()
        let clientID = clientdata?["id"] as? Int
        var url = "user/client/detail?client_id=\(clientID ?? 0)"
        if let date = dateSeconds {
            url = url + "&start_date=\(date)"
        }
        self.showLoading()
        NetworkManager.get(url, isLoading: true, onView: self) { (mainresponse) in
            self.hideLoading()
            print("Client Detail Response :\(String(describing: mainresponse))")
            if (mainresponse?["status_code"] as! Int) == 200 {
                print(mainresponse)
                self.arrayBooking = ((mainresponse?["data"] as! [String : AnyObject])["bookings"] as? [[String : AnyObject]])!
                
                
                self.lblName.text = self.clientdata?["full_name"] as? String
                self.lblPhone.text = "Client Number:".localized + (self.clientdata?["mobile"] as? String ?? "")
                
                let imageURL = URL(string: self.clientdata?["image"] as? String ?? "")
                
                self.imgViewMain.sd_setImage(with: imageURL, placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)

                
                self.lblVisitCount.text = String(self.arrayBooking.count) + "Visits".localized
                
            }else{
                self.hideLoading()
                self.ShowErrorAlert(message:  mainresponse?["message"] as! String)
            }
            
            self.TBL_Client_details.reloadData()
        }
        
       
    }
    
    
    @IBAction func OnClickOpenDate(_ sender: Any) {
        self.date_picker_view.isHidden = false
    }
    @IBAction func Back(_ sender: Any) {
        self.Back()
    }

    @IBAction func OnClickCancelDate(_ sender: Any) {
         self.date_picker_view.isHidden = true
    }
    @IBAction func OnClickSelectDate(_ sender: Any) {
          self.date_picker_view.isHidden = true
        
        let date = dpkr_picker.date
        let dateformator = DateFormatter()
        dateformator.dateFormat = "E, d MMM yyyy"
        let dateString = dateformator.string(from: date)
        lbl_date.text = dateString
        dateSeconds = Int(date.timeIntervalSince1970)
        lc_tableViewViewTop.constant = 30
        self.arrayBooking = []
        TBL_Client_details.reloadData()
        APICAll()
    }
    @IBAction func onclick_clear(_ sender: Any) {
        lc_tableViewViewTop.constant = 0
        dateSeconds = nil
        self.arrayBooking = []
        TBL_Client_details.reloadData()
        APICAll()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.arrayBooking.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "BookingDetailCell") as! BookingDetailCell
        
//        print(self.arrayBooking[indexPath.row])
        
        let object = arrayBooking[indexPath.row]
        
        cell.lblDate.text = (String(describing: object["booking_date"]  as! Int).GetTimeFormDate(value: "d MMM yyyy"))//self.GetDatWithformate(milisecond: self.arrayBooking[indexPath.row]["booking_date"] as! Int , formattString: "d MMM yyyy")
        cell.lblIDTop.text = String(self.arrayBooking[indexPath.row]["id"] as! Int)

        cell.lblStarttime.text = (String(describing: object["start_time"]  as! Int).GetTimeFormDate(value: "h:mm a")) + " - " +
            (String(describing: object["end_time"]  as! Int).GetTimeFormDate(value: "h:mm a"))
        
        
//        cell.lblStarttime.text = self.GetDatWithformate(milisecond: object["booking_date"] as! Int , formattString: "h:mm a")
        
        let pricePer = self.arrayBooking[indexPath.row]["total_bill"] as! [String : AnyObject]
        let priceHourOMR = pricePer["usd"] as! [String : Any]
        let priceHourAED = pricePer["aed"] as! [String : Any]
        
        let mainPrice = pricePer["usd"] as! [String : AnyObject]
        

        if currency == "2" {
            cell.lblPrice.text = "AED" + String(priceHourAED["amount"] as! Double)
        }else {
            cell.lblPrice.text = "OMR" + String(priceHourOMR["amount"] as! Double)
        }
//        cell.lbl_startTime.text = "Start Time".localized +
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.PushViewWithIdentifier(name: "ClientBookingVC")
        let bookingVc = self.GetView(nameViewController: "ClientBookingVC", nameStoryBoard: "Booking") as! ClientBookingVC
        bookingVc.mainData = self.arrayBooking[indexPath.row]
        self.navigationController?.pushViewController(bookingVc, animated: true)
    }
}
