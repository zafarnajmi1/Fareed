//
//  CompanyBookingDetailViewController.swift
//  Cleaning & Servent
//
//  Created by waseem on 22/04/2018.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit
import AVKit

class CompanyBookingDetailViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var imgViewBack: UIImageView!
    
    @IBOutlet weak var btnnavigatetoclient: UIButton!
    @IBOutlet weak var lblbookingdetail: UILabel!
    @IBOutlet weak var lblservices: UILabel!
    @IBOutlet weak var lbladdress: UILabel!
    @IBOutlet weak var cst_specialInfo: NSLayoutConstraint!
    
    
    @IBOutlet weak var Services_collection_view: UICollectionView!
    @IBOutlet weak var Media_Collection_view: UICollectionView!
    
    @IBOutlet var imgViewMain : UIImageView!
    
    var assign_cleaners = [[String : Any]]()
    
    @IBOutlet weak var lbl_noCleanre: UILabel!
    @IBOutlet weak var tbl_cleaners: UITableView!
    @IBOutlet var lbl_Name : UILabel!
    @IBOutlet var lbl_Date : UILabel!
    @IBOutlet var lbl_StartTime : UILabel!
    @IBOutlet var lbl_Address : UILabel!
    @IBOutlet var lbl_SpecialInfo : UILabel!
    @IBOutlet var lbl_SpecialInfoHeading : UILabel!
    @IBOutlet var lbl_Assignedcleaner : UILabel!
    @IBOutlet weak var btnSendMessageToClient: UIButton!
    @IBOutlet var lbl_PhotoHeading : UILabel!
    
    @IBOutlet weak var lblEmailUser: UILabel!
    @IBOutlet weak var lblPhoneUser: UILabel!
    
    @IBOutlet var btnCheckEmployee : UIButton!
    @IBOutlet var btnMark : UIButton!
    @IBOutlet var btnAssign : UIButton!
    @IBOutlet var btnCancel : UIButton!
    @IBOutlet var btnNotes : UIButton!
    
    @IBOutlet weak var lblInvoice: UILabel!
    @IBOutlet weak var btn_invoice: UIButton!
    @IBOutlet weak var img_invoice: UIImageView!
    @IBOutlet var uv_inovice : UIView!
    @IBOutlet weak var tbl_cleaners_height: NSLayoutConstraint!
    @IBOutlet weak var tbl_cleaners_bottom: NSLayoutConstraint!
     @IBOutlet weak var lc_servicesBottom: NSLayoutConstraint!
    
    
    
    
    
    
    var mainData = [String : Any]()
    var bookingData = [String : Any]()
    var companyInfo = [String : Any]()
    var userAddress : [String : Any]? = [:]
    var bookingUser : [String : Any]? = [:]
    var translationInfo = [String : Any]()
    var servicesArray = [[String : Any]]()
    var imageArray = [[String : Any]]()
    var review_given_check = ""
    
    var isType = 0
    var statusType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
        }
        
        self.Media_Collection_view.tag = 2
        self.Services_collection_view.tag = 1
        self.tbl_cleaners.register(UINib(nibName: "ClientCell", bundle: nil), forCellReuseIdentifier: "ClientCell")
        self.Services_collection_view.register(UINib.init(nibName: "ServicesCell", bundle: nil), forCellWithReuseIdentifier: "ServicesCell")
        // Do any additional setup after loading the view.
        
        
        btnnavigatetoclient.setTitle("Navigate To Client".localized, for: .normal)
        btnSendMessageToClient.setTitle("Send Review Request".localized, for: .normal)
        btnCheckEmployee.setTitle("Check Employee Availability".localized, for: .normal)
        btnMark.setTitle("Mark Completed".localized, for: .normal)
        btnAssign.setTitle("Assign Cleaner".localized, for: .normal)
        btnCancel.setTitle("Cancel Booking".localized, for: .normal)
        btnNotes.setTitle("Booking Notes".localized, for: .normal)
        lblbookingdetail.text = "Booking Detail".localized
        lbladdress.text = "Address".localized
       lbl_SpecialInfoHeading.text = "Special Instruction".localized
        lblservices.text = "Services".localized
        lbl_Assignedcleaner.text = "Assigned Cleaners".localized
        lbl_noCleanre.text = "No Cleaner".localized
        lblInvoice.text = "Invoice".localized
        
        self.lbl_PhotoHeading.text = "Photo And Videos".localized
        self.Media_Collection_view.register(UINib.init(nibName: "MediaCell", bundle: nil), forCellWithReuseIdentifier: "MediaCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Back_Action(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.BookingDetail()
        
       
    }
    
    @IBAction func btnSendMessageToClientClick(_ sender: Any)
    {
        //String(self.mainData["id"] as! Int)
        
        var newPAram = [String : AnyObject]()
        newPAram["booking_id"] = String(self.mainData["id"] as! Int) as AnyObject
        self.showLoading()
        NetworkManager.getWithPArams("user/bookings/give-booking-review", isLoading: true, withParams: newPAram, onView: self) { (mainResponse) in
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
    
    
    func BookingDetail(){
        print(self.mainData)
        let stringMain = "user/booking/detail?id=" + String(self.mainData["id"] as! Int)
        print("Booking Detail URL: \(stringMain)")
        self.showLoading()
        NetworkManager.get(stringMain, isLoading: true, onView: self) { (mainResponse) in
            print(mainResponse)
            self.hideLoading()
            if (mainResponse?["status_code"] as! Int)  == 200 {
                
                print(mainResponse?["data"])
                
                self.bookingData = mainResponse?["data"] as! [String : Any]
                
                self.companyInfo =  self.bookingData["company"] as! [String : Any]
                self.userAddress =  self.bookingData["userAddress"] as? [String : Any]
                self.bookingUser =  self.bookingData["user"] as? [String : Any]
                self.translationInfo =  self.companyInfo["translation"] as! [String : Any]
                
                // cleaners
                if let employees = self.bookingData["employees"] as? [[String : Any]]{
                    self.assign_cleaners = employees
                    self.tbl_cleaners.reloadData()
                }
                
                if self.assign_cleaners.count > 0 {
                    self.tbl_cleaners.isHidden = false
                    self.lbl_noCleanre.isHidden = true
                    var hight = 0
                    for employee in self.assign_cleaners{
                        if let employees = employee["employees"] as? [[String : Any]]{
                            hight = hight +  (employees.count * 84)
                        }
                    }
                    
                    self.tbl_cleaners_height.constant =  CGFloat(hight + (self.assign_cleaners.count * 45))
                    self.view.layoutIfNeeded()
                }else{
                    self.tbl_cleaners.isHidden = true
                    self.lbl_noCleanre.isHidden = false
                }
                
                 self.review_given_check = String(describing: self.bookingData["review_given"]  as! Int)

                var user = self.bookingData["user"] as! [String : Any]
                
//                self.lbl_Name.text = self.translationInfo["title"] as! String
//                self.lblEmailUser.text = user["email"] as! String
//                self.lblPhoneUser.text = user["mobile"] as! String
//
                self.lbl_Date.text = String(describing: self.bookingData["booking_date"]  as! Int).GetTimeFormDate(value: "dd MMM yyy")
                self.statusType = String(describing: self.bookingData["status"]  as! String)
                let startTime = self.bookingData["start_time"] as! Double
                let endTime = self.bookingData["end_time"] as! Double
                self.lbl_StartTime.text = "Booking Time :".localized + String.timeFromDate(formate : "h:mm a", date : startTime) + "-" + String.timeFromDate(formate : "h:mm a", date : endTime)
                self.lbl_Name.text = self.bookingUser?["full_name"] as? String
                self.lblEmailUser.text = self.bookingUser?["email"] as? String
                self.lblPhoneUser.text = self.bookingUser?["mobile"] as? String
                //(String(describing: self.bookingData["start_time"]  as! Double).GetTimeFormDate(value: "h:mm a"))
                
//                self.lbl_StartTime.text = "Booking Timing: " + (String(describing: self.bookingData["start_time"]  as! Double).GetTimeFormDate(value: "h:mm a"))
                
                let url = URL(string: self.bookingUser?["image"] as? String ?? "")
                
                self.imgViewMain.sd_setImage(with: url, placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
                
                
                
//                self.lbl_Address.text = self.companyInfo["address"] as? String
                self.lbl_Address.text = self.userAddress?["address"] as? String
                self.imageArray = self.bookingData["bookingAttachments"] as! [[String : Any]]
                self.servicesArray = self.bookingData["services"] as! [[String : Any]]
                
                self.lbl_SpecialInfo.text = self.bookingData["instruction"] as! String
                
                if self.imageArray.count == 0 {
                    self.lbl_PhotoHeading.isHidden = true
                    self.Media_Collection_view.isHidden = true
                    self.lc_servicesBottom.constant = 20
                }
                else{
                    self.lbl_PhotoHeading.isHidden = false
                    self.Media_Collection_view.isHidden = false
                    self.lc_servicesBottom.constant = 130
                    self.Media_Collection_view.reloadData()
                }
                
                if self.lbl_SpecialInfo.text == "" {
                    self.lbl_SpecialInfoHeading.isHidden = true
                    self.cst_specialInfo.constant = -50
                }
                
               
            }else {
                self.hideLoading()
                self.ShowErrorAlert(message: (mainResponse?["message"] as! String))
            }
            
            self.Services_collection_view.reloadData()
            
            print(self.statusType)
            print(DataManager.sharedInstance.isCleaningCompany())
            if self.statusType == "pending" {
                self.btnMark.isEnabled = false
                self.btnMark.backgroundColor = UIColor.gray
                
                self.btnAssign.isEnabled = false
                self.btnAssign.backgroundColor = UIColor.gray
                
                self.btnSendMessageToClient.isEnabled = false
                self.btnSendMessageToClient.backgroundColor = UIColor.gray
                self.hideInoviceView()
    
            }else if self.statusType == "confirmed" {
                self.btnCheckEmployee.isEnabled = false
                self.btnCheckEmployee.backgroundColor = UIColor.gray
                
                self.btnMark.isEnabled = false
                self.btnMark.backgroundColor = UIColor.gray
                
                if DataManager.sharedInstance.isCleaningCompany() {
                    
                    self.btnAssign.isEnabled = false
                    self.btnAssign.backgroundColor = UIColor.gray
                }
                
                self.btnSendMessageToClient.isEnabled = false
                self.btnSendMessageToClient.backgroundColor = UIColor.gray
                self.hideInoviceView()
            }else if self.statusType == "payed" {
                self.btnCheckEmployee.isEnabled = false
                self.btnCheckEmployee.backgroundColor = UIColor.gray
                
                self.btnMark.isEnabled = false
                self.btnMark.backgroundColor = UIColor.gray
                
                self.btnCancel.isEnabled = false
                self.btnCancel.backgroundColor = UIColor.gray
                
                self.btnSendMessageToClient.isEnabled = false
                self.btnSendMessageToClient.backgroundColor = UIColor.gray
                self.hideInoviceView()
            }else if self.statusType == "employee_assigned" {
                self.btnCheckEmployee.isEnabled = false
                self.btnCheckEmployee.backgroundColor = UIColor.gray
                
                self.btnCancel.isEnabled = false
                self.btnCancel.backgroundColor = UIColor.gray
                
                self.btnAssign.isEnabled = false
                self.btnAssign.backgroundColor = UIColor.gray
                
                
                self.btnSendMessageToClient.isEnabled = false
                self.btnSendMessageToClient.backgroundColor = UIColor.gray
               self.hideInoviceView()
            }else if self.statusType == "confirmed" {
                self.btnCheckEmployee.isEnabled = false
                self.btnCheckEmployee.backgroundColor = UIColor.gray
                
                self.btnCancel.isEnabled = false
                self.btnCancel.backgroundColor = UIColor.gray
                
                self.btnAssign.isEnabled = false
                self.btnAssign.backgroundColor = UIColor.gray
                
                
                self.btnMark.isEnabled = false
                self.btnMark.backgroundColor = UIColor.gray
                
                self.btnSendMessageToClient.isEnabled = false
                self.btnSendMessageToClient.backgroundColor = UIColor.gray
                self.hideInoviceView()
            }else if self.statusType == "cancelled" {
                self.btnCheckEmployee.isEnabled = false
                self.btnCheckEmployee.backgroundColor = UIColor.gray
                
                self.btnCancel.isEnabled = false
                self.btnCancel.backgroundColor = UIColor.gray
                
                self.btnAssign.isEnabled = false
                self.btnAssign.backgroundColor = UIColor.gray
                
                
                self.btnMark.isEnabled = false
                self.btnMark.backgroundColor = UIColor.gray
                
                self.btnNotes.isEnabled = false
                self.btnNotes.backgroundColor = UIColor.gray
                
                self.btnSendMessageToClient.isEnabled = false
                self.btnSendMessageToClient.backgroundColor = UIColor.gray
                self.hideInoviceView()
            }else if self.statusType == "finished"  {
                self.btnCheckEmployee.isEnabled = false
                self.btnCheckEmployee.backgroundColor = UIColor.gray
                
                self.btnCancel.isEnabled = false
                self.btnCancel.backgroundColor = UIColor.gray
                
                self.btnAssign.isEnabled = false
                self.btnAssign.backgroundColor = UIColor.gray
                
                
                self.btnMark.isEnabled = false
                self.btnMark.backgroundColor = UIColor.gray
                
                if (self.review_given_check == "1")
                {
                    self.btnSendMessageToClient.isEnabled = false
                    self.btnSendMessageToClient.backgroundColor = UIColor.gray
                }
                else
                {
                    self.btnSendMessageToClient.isEnabled = true
                    //self.btnSendMessageToClient.backgroundColor = UIColor.gray
                }
                self.invoiceViewUpdate()
//                if let invoice_url = self.bookingData["invoice"] as? String {
//                    if invoice_url == "" {
//                        self.invoiceViewUpdate(isAdd: true)
//                    }
//                    else{
//                        self.invoiceViewUpdate(isAdd: false)
//                    }
//                }
//                else{
//                    self.invoiceViewUpdate(isAdd: true)
//                }
                
                
                
            }
            

        }
    }
    func invoiceViewUpdate(){
        uv_inovice.isHidden = false
        tbl_cleaners_bottom.constant = 238
        var isAddButton = false
        if let invoceURL = bookingData["invoice"] as? String{
            if invoceURL == "" {
                isAddButton = true
            }
            else{
                img_invoice.sd_setImage(with: URL(string: invoceURL), placeholderImage  : #imageLiteral(resourceName: "imagePlaceholder"))
            }
        }
        else{
            isAddButton = true
            
        }
        btn_invoice.setImage(isAddButton ? UIImage(named: "add_big"): nil, for: .normal)
        
        
    }
    func hideInoviceView(){
        uv_inovice.isHidden = true
        tbl_cleaners_bottom.constant = 110
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView.tag == 1){
            return self.servicesArray.count
        }else{
            return self.imageArray.count
        }
        
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if(collectionView.tag == 1){
            return CGSize.init(width: (Services_collection_view.bounds.size.width/3)  , height: ((Services_collection_view.bounds.size.width/3) - 10) )
        }
        else{
            print((Media_Collection_view.bounds.size.width/4) - 7)
            return CGSize.init(width: (Media_Collection_view.bounds.size.width/4) - 7 , height: (Media_Collection_view.bounds.size.width/4) - 12)
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        
            if collectionView.tag == 1
            {let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "ServicesCell", for: indexPath) as! ServicesCell
            
            cell.img.sd_setImage(with: URL.init(string: self.servicesArray[indexPath.row]["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "imagePlaceholder") ,completed: nil)
            if let title  = (self.servicesArray[indexPath.row]["translation"] as! [String :Any])["title"] as? String{
                cell.service_name.text = title
            }
            
            cell.check_box_img.isHidden = true
            
            print(self.servicesArray.count % 3)
            cell.bottomView.isHidden = false
/*            if indexPath.row >= (self.servicesArray.count - (self.servicesArray.count % 3) ) {
                cell.bottomView.isHidden = true
                
            }*/
            
            cell.rightView.isHidden = false
           /* if ((indexPath.row + 1)  % 3) == 0  {
                cell.rightView.isHidden = true
                
            }*/
            
            return cell}
        else{
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCell", for: indexPath) as! MediaCell
            
            cell.IMG_main.sd_setImage(with: URL.init(string: self.imageArray[indexPath.row]["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "imagePlaceholder") ,completed: nil)
            
            
            
            if((self.imageArray[indexPath.row]["mime_type"] as! String) == "image" ){
                cell.video_icon.isHidden = true
            }else{
                cell.video_icon.isHidden = false
            }
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView.tag == 2){
            
            if((self.imageArray[indexPath.row]["mime_type"] as! String) == "image" ){
                //                cell.video_icon.isHidden = true
                let cell = collectionView.cellForItem(at: indexPath) as! MediaCell
                self.OpenImage(image: cell.IMG_main.image!)
            }else{
                if let videoURL = self.imageArray[indexPath.row]["image"] as? String{
                    let player = AVPlayer(url: URL(string: videoURL)!)
                    let vc = AVPlayerViewController()
                    vc.player = player
                    
                    present(vc, animated: true) {
                        vc.player?.play()
                    }
                }
            }
            
            
        }
    }
    override func selectedImage(image: UIImage) {
        self.showLoading()
        var newPAram = [String : AnyObject]()
        newPAram["booking_id"] = String(self.mainData["id"] as! Int) as AnyObject
        
        
        NetworkManager.UploadFiles("user/bookings/add-invoice", image:image, imageName: "invoice" , withParams: newPAram, onView: self, completion: { [weak self] (MainResponse) in
            self?.hideLoading()
            print(MainResponse)
            if(MainResponse?["status_code"] as! Int  == 200){
                
                self?.ShowSuccessAlertWithNoAction(message: MainResponse?["message"] as! String)
                self?.BookingDetail()
//                let userMain = User.init(json: MainResponse?["data"] as? [String : AnyObject])
//                userMain.session_token =  (DataManager.sharedInstance.getPermanentlySavedUser()?.session_token)!
//                userMain.isLogin = true
//                DataManager.sharedInstance.user = userMain
//                DataManager.sharedInstance.saveUserPermanentally()
//                //                self.PushViewWithIdentifier(name: "LoginPasswordVC")
//                let login_password = self.storyboard?.instantiateViewController(withIdentifier: "LoginPasswordVC") as! LoginPasswordVC
//                login_password.isBookingPush = self.isBookingPush
//                login_password.phone_number = self.phone_number
//                login_password.user_email = self.emailTxtField.text!
//                self.navigationController?.pushViewController(login_password, animated: true)
            }
            else{
                self?.ShowErrorAlert(message: MainResponse?["message"] as! String )
            }
        })
    }
//    override func selectedImage(image: UIImage) {
//
//    }
    @IBAction func onClick_invoice(_ sender : UIButton){
        
//        btn_invoice.setImage(UIImage(named: "add_big"), for: .normal)
        
        let invoice = bookingData["invoice"] as! String
        if invoice == "" {
            showMediaChoosingOptions()
        }
        else{
            OpenImage(image: img_invoice.image!)
        }
        
        
    }
    
    @IBAction func navigateToClient(sender : UIButton){
        let clientVC = self.GetView(nameViewController: "ClientDetailVC", nameStoryBoard: "Booking") as! ClientDetailVC
        
//        let aaaa = []
        clientVC.clientdata = self.bookingUser
        self.navigationController?.pushViewController(clientVC, animated: true)
        
    }
    @IBAction func CallService(sender : UIButton){
        
        
    }
    
    @IBAction func CancelBooking(sender : UIButton){
        
        let alert = UIAlertController(title: "Alert".localized, message: "Do you want to cancel".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "No".localized, style: .cancel, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction.init(title: "Yes".localized, style: .destructive, handler: { (action) in
            
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
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func CheckEmployeeAction(sender : UIButton){
        let storyboard = UIStoryboard(name: "Booking", bundle: nil)
        let viewObj = (storyboard.instantiateViewController(withIdentifier: "CheckAvailabilityVC")) as! CheckAvailabilityVC
        viewObj.bookingID = self.mainData["id"] as? Int
        navigationController?.pushViewController(viewObj, animated: true)
        
//        var newPAram = [String : AnyObject]()
//        newPAram["booking_id"] = String(self.mainData["id"] as! Int) as AnyObject
//        NetworkManager.getWithPArams("user/booking/available-employees", isLoading: true, withParams: newPAram, onView: self) { (mainResponse) in
//            print(mainResponse)
//            self.ShowSuccessAlertWithNoAction(message: (mainResponse?["message"] as? String)!)
//
//        }
    }
    
    @IBAction func BookingNotes(sender : UIButton){
        let storyboard = UIStoryboard(name: "Booking", bundle: nil)
        let viewObj = (storyboard.instantiateViewController(withIdentifier: "BookingNotecVC")) as! BookingNotecVC
        viewObj.bookign_id =  String(self.mainData["id"] as! Int)
        self.navigationController?.pushViewController(viewObj, animated: true)
    }
    
   
    
    
    
    @IBAction func AssignCleaner(sender : UIButton){
        let newAssign = self.GetView(nameViewController: "AssignCleanerViewController", nameStoryBoard: "BookingExtra") as! AssignCleanerViewController
        newAssign.maindata = self.servicesArray
        newAssign.bookingID = String(self.mainData["id"] as! Int)
        self.navigationController?.pushViewController(newAssign, animated: true)
    }
    
    @IBAction func MarkCompleted(sender : UIButton){
        let alert = UIAlertController(title: "Message".localized, message: "Booking finished".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Cancel".localized, style: .cancel, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction.init(title: "OK".localized, style: .destructive, handler: { (action) in
            var newparam = [String : AnyObject]()
            newparam["booking_id"] = String(self.mainData["id"] as! Int) as AnyObject
            
            let url = "user/bookings/finish-booking?booking_id=" +  String(self.mainData["id"] as! Int)
            self.showLoading()
            NetworkManager.get(url, isLoading: true, onView: self) { (mainDAta) in
                print(mainDAta)
                self.hideLoading()
                self.BookingDetail()
            }
        }))
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
}

extension CompanyBookingDetailViewController : UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.assign_cleaners.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var employee = self.assign_cleaners[section]
        if let employees = employee["employees"] as? [[String : Any]]{
            return employees.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var employee = self.assign_cleaners[section]
        if let translation = employee["translation"] as? [String : Any]{
            return translation["title"] as? String ?? "NO"
        }
        return "Cleaning"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "ClientCell") as! ClientCell
        var employee = self.assign_cleaners[indexPath.section]
        let employees = employee["employees"] as? [[String : Any]]
        var assign_cleaner = employees![indexPath.row]
        cell.lblName.text = assign_cleaner["full_name"] as? String ?? "NULL"
        cell.lblPhone.text = "\(assign_cleaner["phone"] as? String ?? "+9322234242")"
        cell.imgViewMain.sd_setImage(with: URL.init(string: assign_cleaner["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
        cell.selectionStyle = .none
        return cell
    }
    
    
}

