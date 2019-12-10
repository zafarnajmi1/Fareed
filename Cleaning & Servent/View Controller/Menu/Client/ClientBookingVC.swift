//
//  ClientBookingVC.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 4/4/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class ClientBookingVC: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var Services_collection_view: UICollectionView!
    @IBOutlet weak var imgViewBAck: UIImageView!
    @IBOutlet var lbl_PageTitle : UILabel!
    @IBOutlet var lbl_Top : UILabel!
    @IBOutlet var lbl_Date : UILabel!
    @IBOutlet var lbl_StartTime : UILabel!
    @IBOutlet var lbl_Rate : UILabel!
    @IBOutlet var lbl_Address : UILabel!
    @IBOutlet var lbl_SpecialInfo : UILabel!
    @IBOutlet var lbl_Assignedcleaner : UILabel!
    
    @IBOutlet var btnPayment : UIButton!
    @IBOutlet var btnNotes : UIButton!
    @IBOutlet var btnUpdate : UIButton!
    @IBOutlet var btnCancel : UIButton!
    @IBOutlet var btnReview : UIButton!
    
    
     @IBOutlet var lbladdress : UILabel!
     @IBOutlet var lblspecialInstruction : UILabel!
     @IBOutlet var lblservices : UILabel!
     @IBOutlet var lblassigned : UILabel!
     @IBOutlet var lblNocleander : UILabel!
     @IBOutlet var lblInvoice : UILabel!
     @IBOutlet var btnmarkedcomplete : UIButton!
     @IBOutlet var btnclancebooking : UIButton!
     @IBOutlet var btnassignedcleander : UIButton!
     @IBOutlet var btnBookingnotes : UIButton!
     @IBOutlet var btnNavigatToClient : UIButton!
    
    //Navigate to Client
    @IBOutlet weak var btn_check_employee_availability: UIButton!
    
    var mainData = [String : Any]()
    var bookingData = [String : Any]()
    var userAddress : [String : Any]? = [:]
    var companyInfo = [String : Any]()
    var translationInfo = [String : Any]()
    var servicesArray = [[String : Any]]()
    var imageArray = [[String : Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Services_collection_view.tag = 1
       
        if self.isArabic() {
            self.imgViewBAck.image = #imageLiteral(resourceName: "backArabic")
        }
        self.Services_collection_view.register(UINib.init(nibName: "ServicesCell", bundle: nil), forCellWithReuseIdentifier: "ServicesCell")
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width:self.Services_collection_view.frame.width, height: self.Services_collection_view.frame.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        self.Services_collection_view!.collectionViewLayout = layout
        
        // Do any additional setup after loading the view.
        
        lbl_PageTitle.text = "Booking Details".localized
        lbl_StartTime.text = "Booking Time :".localized
        btn_check_employee_availability.setTitle("Check Employee Availability".localized, for: .normal)
       lbladdress.text = "Address".localized
        lblspecialInstruction.text = "Special Instruction".localized
        lblservices.text = "Services".localized
        lblassigned.text = "Assigned Cleaners".localized
         lblNocleander.text = "No Cleaner".localized
       lblInvoice.text = "Invoice".localized
        btnmarkedcomplete.setTitle("Mark Completed".localized, for: .normal)
         btnclancebooking.setTitle("Cancel Booking".localized, for: .normal)
       btnassignedcleander.setTitle("Assign Cleaner".localized, for: .normal)
         btnBookingnotes.setTitle("Booking Notes".localized, for: .normal)
         btnNavigatToClient.setTitle("Navigate to Client".localized, for: .normal)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Back_Action(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.lbl_Date.text = self.GetDatWithformate(milisecond: self.mainData["booking_date"] as! Int , formattString: "d MMMM yyyy")
        self.lbl_Top.text = "Booking: ".localized + String(self.mainData["id"] as! Int)
//        self.lbl_StartTime.text = "Booking Time :".localized + (self.GetDatWithformate(milisecond: self.mainData["booking_date"] as! Int , formattString: "h:mm a"))
        
        
        self.lbl_StartTime.text = "Booking Time :".localized + (String(describing: self.mainData["start_time"]  as! Int).GetTimeFormDate(value: "h:mm a")) + " - " +
            (String(describing: self.mainData["end_time"]  as! Int).GetTimeFormDate(value: "h:mm a"))
//        self.lbl_StartTime.text = "Booking Time :".localized + (self.GetDatWithformate(milisecond: self.mainData["booking_date"] as! Int , formattString: "h:mm a"))
        
        let pricePer = self.mainData["total_bill"] as! [String : AnyObject]
        let mainPrice = pricePer["usd"] as! [String : AnyObject]
        
        if UserDefaults.standard.value(forKey: "Currency") as? String == "2" {
                self.lbl_Rate .text = "AED" + String(mainPrice["amount"] as! Int)
        }else {
            self.lbl_Rate .text = "OMR" + String(mainPrice["amount"] as! Int)
        }
        
        self.BookingDetail()
    }
    
    func BookingDetail(){
        print(self.mainData)
        let stringMain = "user/booking/detail?id=" + String(self.mainData["id"] as! Int)
        print(stringMain)
        self.showLoading()
        NetworkManager.get(stringMain, isLoading: true, onView: self) { (mainResponse) in
            print(mainResponse)
            self.hideLoading()
            if (mainResponse?["status_code"] as! Int)  == 200 {
                self.bookingData = mainResponse?["data"] as! [String : Any]
                
                self.companyInfo =  self.bookingData["company"] as! [String : Any]
                self.translationInfo =  self.companyInfo["translation"] as! [String : Any]
                self.userAddress = self.bookingData["userAddress"] as? [String : Any]
                
                
                self.lbl_Address.text = self.userAddress?["address"] as? String ?? "NA".localized //self.companyInfo["address"] as? String
                self.lbl_SpecialInfo.text = self.bookingData["instruction"] as? String ?? "NA".localized
                self.imageArray = self.bookingData["bookingAttachments"] as! [[String : Any]]
                self.servicesArray = self.bookingData["services"] as! [[String : Any]]
                
                if self.bookingData["status"] as! String == "cancelled" {
                    self.btn_check_employee_availability.isEnabled = false
                    self.btnCancel.isEnabled = false
                    self.btnNotes.isEnabled = false
                }else{
                    self.btn_check_employee_availability.isEnabled = true
                    self.btnCancel.isEnabled = true
                    self.btnNotes.isEnabled = true
                }
            }else {
                self.hideLoading()
                self.ShowErrorAlert(message: (mainResponse?["message"] as! String))
            }
            self.Services_collection_view.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return servicesArray.count;
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize.init(width: (Services_collection_view.bounds.size.width/3), height: (Services_collection_view.bounds.size.width/3))
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "ServicesCell", for: indexPath) as! ServicesCell
             cell.check_box_img.isHidden = true
        
        let translation = self.servicesArray[indexPath.row]["translation"] as! [String : Any]
        
        cell.service_name.text = translation["title"] as? String
        cell.img.sd_setImage(with: URL.init(string: self.servicesArray[indexPath.row]["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
        
        
        print(self.servicesArray.count % 3)
        cell.bottomView.isHidden = false
        if indexPath.row >= (self.servicesArray.count - (self.servicesArray.count % 3) ) {
            cell.bottomView.isHidden = true
            
        }
        
        cell.rightView.isHidden = false
        if ((indexPath.row + 1)  % 3) == 0  {
            cell.rightView.isHidden = true
            
        }
        
        
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView.tag == 2){
//            let cell = collectionView.cellForItem(at: indexPath) as! MediaCell
//            self.OpenImage(image: cell.IMG_main.image!)
        }
    }
    
    @IBAction func OnClickCheckAvailability(_ sender: Any) {
        var newPAram = [String : AnyObject]()
        newPAram["booking_id"] = String(self.mainData["id"] as! Int) as AnyObject
        self.showLoading()
        NetworkManager.getWithPArams("user/booking/available-employees", isLoading: true, withParams: newPAram, onView: self) { (mainResponse) in
            print(mainResponse)
            self.hideLoading()
            self.ShowSuccessAlertWithNoAction(message: (mainResponse?["message"] as? String)!)
            
        }
    }
    
    @IBAction func CallService(sender : UIButton){
        
        self.DialNumber(PhoneNumber: self.companyInfo["phone"] as! String)
    }
    
    @IBAction func CancelBooking(sender : UIButton){
        var newPAram = [String : AnyObject]()
        newPAram["booking_id"] = String(self.mainData["id"] as! Int) as AnyObject
        self.showLoading()
        NetworkManager.getWithPArams("user/bookings/cancel-booking", isLoading: true, withParams: newPAram, onView: self) { (mainResponse) in
            print(mainResponse)
            self.hideLoading()
            if (mainResponse?["status_code"] as! Int)  == 200 {
                
                self.ShowSuccessAlert(message: mainResponse?["message"] as! String)
            }else {
                self.hideLoading()
                self.ShowErrorAlert(message: (mainResponse?["message"] as! String))
            }
        }
    }
    
    @IBAction func OnClickBookingNotes(sender : UIButton){
        let storyboard = UIStoryboard(name: "Booking", bundle: nil)
        let viewObj = (storyboard.instantiateViewController(withIdentifier: "BookingNotecVC")) as! BookingNotecVC
        viewObj.bookign_id =  String(self.mainData["id"] as! Int)
        self.navigationController?.pushViewController(viewObj, animated: true)
    }
    
    @IBAction func OnClickMarkCompleted(sender : UIButton){
        
    }
    
    @IBAction func OnClcickAsignCleaner(sender : UIButton){
        
    }
    
    @IBAction func OnClickNavigateToClient(sender : UIButton){
        let address = self.companyInfo["address"] as? String
        let url_string = "http://maps.apple.com/maps?address=\(address?.replacingOccurrences(of: " ", with: "") ?? "USA")"
        if let url = URL(string: url_string) {
            UIApplication.shared.open(url, options: [:])
        }
    }   
}

