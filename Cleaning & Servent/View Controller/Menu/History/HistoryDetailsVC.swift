//
//  HistoryDetailsVC.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 3/17/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit
import AVKit

class HistoryDetailsVC: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var imgViewBack: UIImageView!
    
    @IBOutlet weak var lbl_Heading: UILabel!
    @IBOutlet weak var lbl_AddressHeading: UILabel!
    @IBOutlet weak var lbl_Services: UILabel!
    @IBOutlet weak var lbl_CallService: UILabel!
    
    
    @IBOutlet weak var PaymentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lbl_noCleanre: UILabel!
    @IBOutlet weak var tbl_cleaners: UITableView!
    @IBOutlet weak var cst_specialInfo: NSLayoutConstraint!
    @IBOutlet weak var cst_assignCleaner: NSLayoutConstraint!

    @IBOutlet weak var Media_Collection_view: UICollectionView!
    @IBOutlet weak var Services_collection_view: UICollectionView!
    
    @IBOutlet weak var imgViewMain : UIImageView!
    var assign_cleaners = [[String : Any]]()
    @IBOutlet weak var lbl_Name : UILabel!
    @IBOutlet weak var lbl_Date : UILabel!
    @IBOutlet weak var lbl_StartTime : UILabel!
    @IBOutlet weak var lbl_Address : UILabel!
    @IBOutlet weak var lbl_SpecialInfo : UILabel!
    @IBOutlet weak var lbl_SpecialInfoHeading : UILabel!
    @IBOutlet weak var lbl_Assignedcleaner : UILabel!
    @IBOutlet weak var lbl_PhotoHeading : UILabel!
    
    @IBOutlet weak var btnPayment : UIButton!
    @IBOutlet weak var btnNotes : UIButton!
    @IBOutlet weak var btnUpdate : UIButton!
    @IBOutlet weak var btnCancel : UIButton!
    @IBOutlet weak var btnReview : UIButton!
    
    
    
    
    @IBOutlet weak var lblInvoice: UILabel!
    @IBOutlet weak var btn_invoice: UIButton!
    @IBOutlet weak var img_invoice: UIImageView!
    @IBOutlet weak var uv_inovice : UIView!
    @IBOutlet weak var tbl_cleaners_height: NSLayoutConstraint!
    @IBOutlet weak var tbl_cleaners_bottom: NSLayoutConstraint!
    
    
    var mainData = [String : Any]()
    var bookingData = [String : Any]()
    var companyInfo = [String : Any]()
    var dataCompany = [String : Any]()
    var translationInfo = [String : Any]()
    var servicesArray = [[String : Any]]()
    var imageArray = [[String : Any]]()
    var userAddress : [String : Any]? = [:]
    
    var isType = 0
    var ratingCompany = 0.0
    var statusType = ""
    
    private var payPalConfig = PayPalConfiguration()
    private var environment:String = PayPalEnvironmentSandbox {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
        }
        
        self.Media_Collection_view.tag = 2
        self.Services_collection_view.tag = 1
        
        
        lblInvoice.text = "Invoice".localized
        
        self.lbl_CallService.text = "Call Service Provider".localized
        self.lbl_Heading.text = "Booking Detail".localized
        self.lbl_AddressHeading.text = "Address".localized
        self.lbl_SpecialInfoHeading.text = "Special Instruction".localized
        self.lbl_Services.text = "Services".localized
        self.lbl_PhotoHeading.text = "Photo And Videos".localized
        self.lbl_noCleanre.text = "No Cleaner".localized
        self.btnCancel.setTitle("Cancel Booking".localized, for: .normal)
        self.btnNotes.setTitle("Booking Notes".localized, for: .normal)
        self.btnReview.setTitle("Write Review".localized, for: .normal)
        self.btnUpdate.setTitle("Update Schedule".localized, for: .normal)
        self.btnPayment.setTitle("Submit Your Payment".localized, for: .normal)
        lbl_Assignedcleaner.text = "Assigned Cleaners".localized
         self.Media_Collection_view.register(UINib.init(nibName: "MediaCell", bundle: nil), forCellWithReuseIdentifier: "MediaCell")
        self.tbl_cleaners.register(UINib(nibName: "ClientCell", bundle: nil), forCellReuseIdentifier: "ClientCell")
        self.tbl_cleaners.register(UINib(nibName: "ClientReviewCell", bundle: nil), forCellReuseIdentifier: "ClientReviewCell")
        
         self.Services_collection_view.register(UINib.init(nibName: "ServicesCell", bundle: nil), forCellWithReuseIdentifier: "ServicesCell")
        
        configPayPal()
        PayPalMobile.preconnect(withEnvironment: environment)
//        self.BookingDetail()
        // Do any additional setup after loading the view.
    }
    
    func configPayPal(){
        payPalConfig.acceptCreditCards = false
        payPalConfig.merchantName = "Fareed"
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .payPal
        print("PayPal iOS SDK Version: \(PayPalMobile.libraryVersion())")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.BookingDetail()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Back_Action(){
        self.navigationController?.popViewController(animated: true)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.BookingDetail()
//
//        print(isType)
//
//    }
    
    func BookingDetail(){
        print(self.mainData)
        let stringMain = "user/booking/detail?id=" + String(self.mainData["id"] as! Int)
        print("History Detail URL :\(stringMain)")
        self.showLoading()
        NetworkManager.get(stringMain, isLoading: true, onView: self) { (mainResponse) in
            print(mainResponse)
            self.hideLoading()
            if (mainResponse?["status_code"] as! Int)  == 200 {
                
                
                
                self.bookingData = mainResponse?["data"] as! [String : Any]
                print(self.bookingData)
                self.statusType = self.bookingData["status"] as! String
                 // cleaners
                if let employees = self.bookingData["employees"] as? [[String : Any]]{
                    self.assign_cleaners = employees
                }
                
                if self.assign_cleaners.count > 0 {
                    self.tbl_cleaners.isHidden = false
                    self.lbl_noCleanre.isHidden = true
                    var hight = 0
                    for employee in self.assign_cleaners{
                        if let employees = employee["employees"] as? [[String : Any]]{
                            print(employees)
                    
                            for employeeInner in employees{
                                print(employeeInner)
                                
                                let pivot = employeeInner["pivot"] as! [String : Any]
                                if let rating = pivot["rating"] as? Double {
                                    if rating < 1.0 {
                                        hight = hight +   105
                                    }else {
                                        hight = hight +   84
                                    }
                                    
                                }else {
                                    
                                    if let rating = pivot["rating"] as? Int {
                                       if rating < 1 {
                                            hight = hight + 105
                                       }else {
                                            hight = hight + 84
                                        }
                                        
                                    }else {
                                        hight = hight + 84
                                    }
                                    
                                }
                            }
                        }
                    }
                   
                    
                    print(hight)
                    self.tbl_cleaners_height.constant =  CGFloat(hight + (self.assign_cleaners.count * 45))
                    self.view.layoutIfNeeded()
                }else{
                    self.tbl_cleaners.isHidden = true
                    self.lbl_noCleanre.isHidden = false
                }
                
                 self.companyInfo =  self.bookingData["company"] as! [String : Any]
                self.translationInfo =  self.companyInfo["translation"] as! [String : Any]

                
                self.lbl_Name.text = self.translationInfo["title"] as! String
                self.lbl_Date.text = String(describing: self.bookingData["booking_date"]  as! Int).GetTimeFormDate(value: "dd MMM yyy")
                
                self.statusType = String(describing: self.bookingData["status"]  as! String)
                print(self.statusType)
                self.lbl_StartTime.text = "Booking Timing:".localized + (String(describing: self.bookingData["start_time"]  as! Int).GetTimeFormDate(value: "h:mm a")) + " - " +
                (String(describing: self.bookingData["end_time"]  as! Int).GetTimeFormDate(value: "h:mm a"))
                self.imgViewMain.sd_setImage(with: URL.init(string: self.companyInfo["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
//                self.lbl_Address.text = self.companyInfo["address"] as? String
                self.userAddress = self.bookingData["userAddress"] as? [String : Any]
                self.lbl_Address.text = self.userAddress?["address"] as? String
                self.imageArray = self.bookingData["bookingAttachments"] as! [[String : Any]]
                self.servicesArray = self.bookingData["services"] as! [[String : Any]]

                self.ratingCompany = self.bookingData["rating"] as! Double
                
                if self.servicesArray.count > 0 {
                    let firstObject = self.servicesArray[0] as! [String : Any]
                    
                    print(firstObject)
                    self.PaymentHeight.constant = 37
                    if (firstObject["service_type"] as! String) == "maintenance" {
                        self.PaymentHeight.constant = 0
                    }
                    self.view.layoutIfNeeded()
                }
                
                
                self.lbl_SpecialInfo.text = self.bookingData["instruction"] as! String
                
                if self.imageArray.count == 0 {
                    self.lbl_PhotoHeading.isHidden = true
                    self.Media_Collection_view.isHidden = true
                    self.cst_assignCleaner.constant = -120
                }
                else{
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
            self.tbl_cleaners.reloadData()
            
//            if self.isType == 0 {
            
            
            if self.statusType == "payed" {
                self.btnPayment.isEnabled = false
                self.btnReview.isEnabled = false
                self.btnUpdate.isEnabled = false
                self.btnCancel.isEnabled = false
                
                self.btnReview.backgroundColor = UIColor.gray
                self.btnCancel.backgroundColor = UIColor.gray
                self.btnUpdate.backgroundColor = UIColor.gray
                self.btnPayment.backgroundColor = UIColor.gray
                self.hideInoviceView()
            }else
                if self.statusType == "cancelled" {
                    self.btnPayment.isEnabled = false
                    self.btnReview.isEnabled = false
                    self.btnUpdate.isEnabled = false
                    self.btnCancel.isEnabled = false
                    
                    self.btnReview.backgroundColor = UIColor.gray
                    self.btnCancel.backgroundColor = UIColor.gray
                    self.btnUpdate.backgroundColor = UIColor.gray
                    self.btnPayment.backgroundColor = UIColor.gray
                    self.hideInoviceView()
                }else if self.statusType == "finished"  {
                    
                    if self.ratingCompany > 0.0 {
                        self.btnReview.isEnabled = false
                        self.btnReview.backgroundColor = UIColor.gray
                    }
                    self.btnPayment.isEnabled = false
                    
                    self.btnUpdate.isEnabled = false
                    self.btnCancel.isEnabled = false
                    self.btnCancel.backgroundColor = UIColor.gray
                    self.btnUpdate.backgroundColor = UIColor.gray
                    self.btnPayment.backgroundColor = UIColor.gray
                    self.invoiceViewUpdate()
                    
                }else if self.statusType == "pending"  {
                    self.btnReview.isEnabled = false
                    self.btnPayment.isEnabled = false
                    self.btnReview.backgroundColor = UIColor.gray
                    self.btnPayment.backgroundColor = UIColor.gray
                    self.hideInoviceView()
                }else if self.statusType == "confirmed"  {
                    
//                    self.btnPayment.isEnabled = false
                    self.btnUpdate.isEnabled = false
                    self.btnReview.isEnabled = false
                    self.btnReview.backgroundColor = UIColor.gray
//                    self.btnPayment.backgroundColor = UIColor.gray
                    self.btnUpdate.backgroundColor = UIColor.gray
                    self.hideInoviceView()
                }
                else if self.statusType == "employee_assigned"  {
                    
                    self.btnPayment.isEnabled = false
                    self.btnReview.isEnabled = false
                    self.btnUpdate.isEnabled = false
                    self.btnCancel.isEnabled = false
                    
                    self.btnReview.backgroundColor = UIColor.gray
                    self.btnCancel.backgroundColor = UIColor.gray
                    self.btnUpdate.backgroundColor = UIColor.gray
                    self.btnPayment.backgroundColor = UIColor.gray
                    self.hideInoviceView()
            }
//            }
           
            
            
        }
    }
    func invoiceViewUpdate(){
        uv_inovice.isHidden = false
        tbl_cleaners_bottom.constant = 150

        if let invoceURL = bookingData["invoice"] as? String{
                img_invoice.sd_setImage(with: URL(string: invoceURL), placeholderImage  : #imageLiteral(resourceName: "imagePlaceholder"))
        }
        
        
    }
    func hideInoviceView(){
        uv_inovice.isHidden = true
        tbl_cleaners_bottom.constant = 20
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
            return CGSize.init(width: (Services_collection_view.bounds.size.width/3)  , height: (Services_collection_view.bounds.size.width/3) )
        }else{
            print((Media_Collection_view.bounds.size.width/4) - 7)
           return CGSize.init(width: (Media_Collection_view.bounds.size.width/4) - 7 , height: (Media_Collection_view.bounds.size.width/4) - 12)
        }
       
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView.tag == 1){
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "ServicesCell", for: indexPath) as! ServicesCell
            
            cell.img.sd_setImage(with: URL.init(string: self.servicesArray[indexPath.row]["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "imagePlaceholder") ,completed: nil)
            if let title  = (self.servicesArray[indexPath.row]["translation"] as! [String :Any])["title"] as? String{
                 cell.service_name.text = title
            }
           
            cell.check_box_img.isHidden = true
            
            print(self.servicesArray.count % 3)
            cell.bottomView.isHidden = false
//            if indexPath.row >= (self.servicesArray.count - (self.servicesArray.count % 3) ) {
//                cell.bottomView.isHidden = true
//
//            }
            
            cell.rightView.isHidden = false
//            if ((indexPath.row + 1)  % 3) == 0  {
//                cell.rightView.isHidden = true
//                
//            }
            
            return cell
        }else{
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCell", for: indexPath) as! MediaCell
            
            

            
            var placeholder = #imageLiteral(resourceName: "imagePlaceholder")
            if((self.imageArray[indexPath.row]["mime_type"] as! String) == "image" ){
                cell.video_icon.isHidden = true
            }else{
                cell.video_icon.isHidden = false
            }
            cell.IMG_main.sd_setImage(with: URL.init(string: self.imageArray[indexPath.row]["image"] as! String), placeholderImage  : placeholder ,completed: nil)
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
                
//                cell.video_icon.isHidden = false
            }
            
           
        }
    }
    
    
    @IBAction func CallService(sender : UIButton){
        
       self.DialNumber(PhoneNumber: self.companyInfo["phone"] as! String)
    }
    
    @IBAction func CancelBooking(sender : UIButton){
        
        
        
        let alert = UIAlertController(title: "Alert".localized , message: "Do you want to cancel".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes".localized, style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
            
            var newPAram = [String : AnyObject]()
            print(String(self.mainData["id"] as! Int))
            newPAram["booking_id"] = String(self.mainData["id"] as! Int) as AnyObject
            self.showLoading()
            NetworkManager.getWithPArams("user/bookings/cancel-booking", isLoading: true, withParams: newPAram, onView: self) { (mainResponse) in
                print(mainResponse)
                self.hideLoading()
                if (mainResponse?["status_code"] as! Int)  == 200 {
                    (UIApplication.shared.delegate as! AppDelegate).isRefreshAfterCancel = true
                    self.ShowSuccessAlert(message: mainResponse?["message"] as! String)
                }else {
                    self.hideLoading()
                    self.ShowErrorAlert(message: (mainResponse?["message"] as! String))
                }
            }
            
            
        })
        
        alert.addAction(UIAlertAction(title: "No".localized, style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        })
        
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func WriteReview(sender : UIButton){
        
            let storyboard = UIStoryboard(name: "BookingExtra", bundle: nil)
            let viewObj = (storyboard.instantiateViewController(withIdentifier: "WriteReviewViewController")) as! WriteReviewViewController
            viewObj.mainData = self.mainData
        viewObj.isEmployeRating = false
            self.navigationController?.pushViewController(viewObj, animated: true)
        
    }
    
    @IBAction func BookingNotes(sender : UIButton){
        let storyboard = UIStoryboard(name: "Booking", bundle: nil)
        let viewObj = (storyboard.instantiateViewController(withIdentifier: "BookingNotecVC")) as! BookingNotecVC
        viewObj.bookign_id =  String(self.mainData["id"] as! Int)
        self.navigationController?.pushViewController(viewObj, animated: true)
    }
    
    @IBAction func UpdateSchedule(sender : UIButton){
        
        
        var newPAram = [String : AnyObject]()
        
        if(self.mainData["company_id"] != nil){
        newPAram["company_id"] = String(self.mainData["company_id"] as! Int) as AnyObject
        self.showLoading()
        
        NetworkManager.getWithPArams("company/detail", isLoading: true, withParams:newPAram , onView: self) { (Maindata) in
            print(Maindata)
            self.hideLoading()
            if (Maindata?["status_code"] as! Int)  == 200 {
                    
                    
                self.dataCompany = Maindata?["data"] as! [String : AnyObject]
                    
                    let mainVC = self.GetView(nameViewController: "UpdateScheduleViewController", nameStoryBoard: "Booking") as! UpdateScheduleViewController
                    
                    mainVC.companyData = self.dataCompany
                    mainVC.mainData = self.mainData
                    
                    var mainHour = [String]()
                    var mainHourArray = [String]()
                    
                    let calendar = Calendar.current
                    
                    for index in 0..<self.GetHours() {
                        
                        let Newdate = calendar.date(byAdding: .hour, value: index, to: self.getDateObject(milisecond:self.dataCompany["time_starts"] as! Int))
                        
                        mainHour.append(self.GetDAteForBooking(dateMain: Newdate!))
                        mainHourArray.append(self.GetStringFromDate(dateMain: Newdate!, formate: "HH"))
                    }
                    
                    var showHour = [String]()
                    for index in 0..<mainHour.count {
                        
                        if index < mainHour.count - 1 {
                            showHour.append(mainHour[index] + " - " + mainHour[index + 1])
                        }
                    }
                    
                    print("showHour")
                    print(showHour)
                    print("mainHourArray")
                    print(mainHourArray)
                    
                    mainVC.count = showHour.count
                    mainVC.tbleArray = showHour
                    mainVC.tbleArrayMAin = showHour
                    mainVC.HoursArray = mainHourArray
                    mainVC.selectedServicesCount = self.servicesArray.count
                    //
                    self.navigationController?.pushViewController(mainVC, animated: true)
                    
                }else {
                self.hideLoading()
                self.ShowErrorAlert(message: (Maindata?["message"] as! String))
                }
            }
        }
        }
    @IBAction func onClick_invoice(_ sender : UIButton){
        
        //        btn_invoice.setImage(UIImage(named: "add_big"), for: .normal)
        
        if (bookingData["invoice"] as? String) != nil
       {
            OpenImage(image: img_invoice.image!)
        }
        
        
    }
    @IBAction func SubmitYourPayment(sender : UIButton){
        
        moveToPaypal()
        
    }
    func moveToPaypal(){
        
        var paypalItems = [PayPalItem]()
//        let quantity = cartList.compactMap({$0.quantity}).reduce(0, +)
        let totalProducts = 1// AppSettings.shared.cartItems//cartList.compactMap{$0.product}.count
        let name = "Cleaning Service".localized
        
        let amount_due = bookingData["amount_due"] as! Double
        
        let amount = NSDecimalNumber(value: amount_due)// NSDecimalNumber(floatLiteral: amount_due)//billAmount.usd?.formattedAmount

        
        let obj = PayPalItem(name: name,
                             withQuantity: 1,
                             withPrice: amount,
                             withCurrency: "USD",
                             withSku: "Hip-0037")
        paypalItems.append(obj)
        
        
        
        let subtotal = PayPalItem.totalPrice(forItems: paypalItems) //This is the total price of all the items
        let payment = PayPalPayment(amount: subtotal, currencyCode: "USD", shortDescription: "Total Amount", intent: .sale)
        payment.items = paypalItems
        // payment.paymentDetails = paymentDetails
        if payment.processable {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            present(paymentViewController!, animated: true, completion: nil)
        }
        else {
            let msg = "Payment not processalbe: (payment)"
            self.ShowErrorAlert(message: msg)
//            self.alertMessage(message: msg, btnTitle: "cancel".capitalized.localized) {
            }
            
        }
    func paymentSuccess(paymentID : String){
        let booking_id = "\(bookingData["id"] as! Int)"
        let params = ["booking_id": booking_id, "payment_id": paymentID] as [String : AnyObject]
        self.showLoading()
        NetworkManager.post("user/bookings/payment", isLoading: true, withParams: params, onView: self) { [weak self] (mainResponse) in
            self!.hideLoading()
            if (mainResponse?["status_code"] as! Int)  == 200 {
                self?.ShowSuccessAlertWithNoAction(message: mainResponse?["message"] as! String)
//                self?.ShowSuccessAlert(message: mainResponse?["message"] as! String)
                self?.BookingDetail()
                
            }else {
                self!.hideLoading()
                self?.ShowErrorAlert(message: (mainResponse?["message"] as! String))
            }
        }
    }
    
    
}
extension HistoryDetailsVC: PayPalPaymentDelegate, PayPalProfileSharingDelegate{
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController){
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment)
    {
        print("PayPal Payment Success !")
        
        paymentViewController.dismiss(animated: true, completion: { [weak self] () -> Void in
            // send completed confirmaion to your server
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
            
            let dict = completedPayment.confirmation
            print("dict data is ====%@", dict)
            
            let paymentResultDic = completedPayment.confirmation as NSDictionary
            let dicResponse: AnyObject? = paymentResultDic.object(forKey: "response") as AnyObject?
            
            let paycreatetime:String = dicResponse!["create_time"] as! String
            let payauid:String = dicResponse!["id"] as! String
            let paystate:String = dicResponse!["state"] as! String
            let payintent:String = dicResponse!["intent"] as! String
            
            print("id is  --->%@",payauid)
            print("created  time ---%@",paycreatetime)
            print("paystate is ----->%@",paystate)
            print("payintent is ----->%@",payintent)
            
//            self.paymentId = payauid
            self?.paymentSuccess(paymentID: payauid)
            //            self.callBack?()
        })
    }
    
    func userDidCancel(_ profileSharingViewController: PayPalProfileSharingViewController){
        print("PayPal Profile Sharing Authorization Canceled")
        
    }
    
    func payPalProfileSharingViewController(_ profileSharingViewController: PayPalProfileSharingViewController, userDidLogInWithAuthorization profileSharingAuthorization: [AnyHashable : Any]){
        print("PayPal Profile Sharing Authorization Canceled")
    }
    
}

extension HistoryDetailsVC : UITableViewDelegate , UITableViewDataSource{
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
        
        var employee = self.assign_cleaners[indexPath.section]
        let employees = employee["employees"] as? [[String : Any]]
        var assign_cleaner = employees![indexPath.row]
        
        print(assign_cleaner["pivot"])
        print(self.statusType)
        if self.statusType == "finished"{
            if let rating = (assign_cleaner["pivot"] as! [String : Any])["rating"] as? Int {
                
                if rating < 1 {
                    
                    let cell  = tableView.dequeueReusableCell(withIdentifier: "ClientReviewCell") as! ClientReviewCell
                    cell.lblName.text = assign_cleaner["full_name"] as? String ?? "NULL"
                    cell.lblPhone.text = "\(assign_cleaner["phone"] as? String ?? "+9322234242")"
                    cell.imgViewMain.sd_setImage(with: URL.init(string: assign_cleaner["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
                    cell.selectionStyle = .none
                    return cell
                }
            }
        }
    
       
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "ClientCell") as! ClientCell
    
        
        cell.lblName.text = assign_cleaner["full_name"] as? String ?? "NULL"
        cell.lblPhone.text = "\(assign_cleaner["phone"] as? String ?? "+9322234242")"
        cell.imgViewMain.sd_setImage(with: URL.init(string: assign_cleaner["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.statusType == "finished"{
            var employee = self.assign_cleaners[indexPath.section]
            let employees = employee["employees"] as? [[String : Any]]
            var assign_cleaner = employees![indexPath.row]
            
            print(assign_cleaner["pivot"])
            
            if let rating = (assign_cleaner["pivot"] as! [String : Any])["rating"] as? Int {
                
                if rating < 1 {
                    let storyboard = UIStoryboard(name: "BookingExtra", bundle: nil)
                    let viewObj = (storyboard.instantiateViewController(withIdentifier: "WriteReviewViewController")) as! WriteReviewViewController
                    viewObj.mainData = assign_cleaner["pivot"] as! [String : Any]
                    viewObj.isEmployeRating = true
                    self.navigationController?.pushViewController(viewObj, animated: true)
                    
                }
            }
        }
    }
    
    
    func GetHours()-> Int{

        let dateRangeEnd = self.getDateObject(milisecond:self.dataCompany["time_starts"] as! Int)


        let dateRangeStart = self.getDateObject(milisecond:self.dataCompany["time_ends"] as! Int)

        let components = Calendar.current.dateComponents([.hour ], from: dateRangeEnd, to: dateRangeStart)


        print(components.hour!)
        return components.hour!
    }
    
}
