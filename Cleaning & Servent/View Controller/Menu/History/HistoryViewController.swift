//
//  HistoryViewController.swift
//  Servent
//
//  Created by waseem on 11/02/2018.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HistoryViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, moveonLogin{
    
//    var  menuheader =  MenuHeaderCell()
    @IBOutlet weak var notification_badge_view: CircleView!
    
    @IBOutlet weak var lbl_notification_count: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!
    
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btncancel: UIButton!
    @IBOutlet weak var date_picker_view: UIView!
    @IBOutlet var tbleViewHistory : UITableView!
    var isPending : Bool = true
    @IBOutlet weak var Calendar_menu_view: UIView!
    @IBOutlet weak var Notificaiton_btn_view: UIView!
    @IBOutlet weak var TBL_menu: UITableView!
    @IBOutlet weak var MenuView_detail: UIView!
    @IBOutlet weak var MenuView: UIView!
    @IBOutlet weak var Constraint_Menu_Left: NSLayoutConstraint!
    
    @IBOutlet weak var IMG_Menu_icon: UIImageView!
    @IBOutlet weak var uv_historyContainter: UIView!
    
//    @IBOutlet var Compny_tab_view : UIView!
    
    @IBOutlet var lblUpcoming : UILabel!
    @IBOutlet var lblEompleted : UILabel!
    @IBOutlet var lblConfirm : UILabel!
    @IBOutlet var lblCanceled : UILabel!
    @IBOutlet var lblPaid : UILabel!
    @IBOutlet var lblInProgress : UILabel!
//    @IBOutlet var lblUpcoming_company : UILabel!
//    @IBOutlet var lblEompleted_company : UILabel!
//    @IBOutlet var lblConfirm_company : UILabel!
//    @IBOutlet var lblCanceled_company : UILabel!
//    @IBOutlet var lblInProgress_company : UILabel!
    
    @IBOutlet var lbl_date : UILabel!
    @IBOutlet var btn_clear : UIButton!
    @IBOutlet var lc_tabbarViewTop : NSLayoutConstraint!
    @IBOutlet var dpkr_picker : UIDatePicker!
    
    @IBOutlet var viewPaid : UIView!
    @IBOutlet var uv_under_Upcoming : UIView!
    @IBOutlet var uv_under_Confirm : UIView!
    @IBOutlet var uv_under_Paid : UIView!
    @IBOutlet var uv_under_InProgress : UIView!
    @IBOutlet var uv_under_Eompleted : UIView!
    @IBOutlet var uv_under_Canceled : UIView!
    
    
    
//    @IBOutlet var viewUpcoming_company : UIView!
//    @IBOutlet var viewEompleted_company : UIView!
//    @IBOutlet var viewConfirm_company : UIView!
//    @IBOutlet var viewCanceled_company : UIView!
//    @IBOutlet var viewInProgress_company : UIView!
    @IBOutlet var btn_pending : UIButton!
    @IBOutlet var btn_confirmed : UIButton!
    @IBOutlet var btn_paid : UIButton!
    @IBOutlet var btn_inProgress : UIButton!
    @IBOutlet var btn_finish : UIButton!
    @IBOutlet var btn_cancelled : UIButton!
    
    var refreshControl = UIRefreshControl()
    
    var dateSeconds : Int?
    var isRequestSent : Bool = false
    var pageInfo : PageInfo?
    var isLoadMore : Bool{
        get {
            if let pageInfo = pageInfo{
                if let current = pageInfo.current_page, let last = pageInfo.last_page{
                    return current < last
                }
                else{
                    return false
                }
            }
            else{
                return true
            }
        }
    }
    var nextPage : Int {
        get {
            if let pageInfo = pageInfo{
                if let current = pageInfo.current_page{
                    return current + 1
                }
                else{
                    return 1
                }
            }
            else{
                return 1
            }
        }
    }
    
    var arrayMainPending = [[String : Any]]()
    var arrayMainConfirmed = [[String : Any]]()
    var arrayMainFinished = [[String : Any]]()
    var arrayMainCancelled = [[String : Any]]()
    var arrayMainInProgree = [[String : Any]]()
    var arrayMainPaid = [[String : Any]]()
    
    var arrayMaintbleView = [[String : Any]]()
    var pageNumber = 1
    fileprivate var shouldLoadMore = true
    var isType = 0
    var appi_call = ""
    var isCompany : Bool = false
    
    var timer = Timer()
    
    
    override func viewDidLoad() {
        
//        settings.style.buttonBarBackgroundColor = .clear
//        settings.style.buttonBarItemBackgroundColor = .clear
//        settings.style.buttonBarItemTitleColor = .green//self.btnTapSelectColor
////        settings.style.buttonBarItemFont = UIFont(name: "Poppins", size: 15)! //.boldSystemFont(ofSize: 16)
//
//        settings.style.buttonBarMinimumLineSpacing = 0
//        settings.style.buttonBarItemTitleColor = UIColor.darkGray
//        settings.style.buttonBarItemsShouldFillAvailableWidth = true
//        settings.style.buttonBarLeftContentInset = 5
//        settings.style.buttonBarRightContentInset = 5
//
//
//        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
//            guard changeCurrentIndex == true else { return }
//
//            oldCell?.label.textColor = UIColor.black
//            oldCell?.backgroundColor = .white
//
//            newCell?.label.textColor = .white
//            newCell?.backgroundColor = .green //self?.btnTapSelectColor
//
//        }
        
        super.viewDidLoad()
//        self.navigationController?.isNavigationBarHidden = false
//        self.navigationController!.navigationBar.isTranslucent = false
        if DataManager.sharedInstance.getPermanentlySavedUser()?.user_type == "company"{
            isCompany = true
        }
        DataManager.sharedInstance.current_nav = self.navigationController
        self.REloadViews()
        self.isType = 1
        
        if self.isArabic() {
            view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi) * 2)
        }
        else {
            view.transform = CGAffineTransform(rotationAngle: 0)
        }
        
        tbleViewHistory.estimatedRowHeight = 1000
//        self.APICAllPending()
        
        self.lblPaid.text = "Paid".localized
        self.lblConfirm.text = "Confirmed".localized
        self.lblCanceled.text = "Cancelled".localized
        self.lblUpcoming.text = "Pending".localized
        self.lblEompleted.text = "Finished".localized
        self.lblInProgress.text = "In progress".localized
//        self.lblConfirm_company.text = "Finished".localized
//        self.lblCanceled_company.text = "Cancelled".localized
//        self.lblEompleted_company.text = "Confirmed".localized
//        self.lblInProgress_company.text = "In progress".localized
//        self.lblUpcoming_company.text = "Pending".localized
        self.btnDone.setTitle("Done".localized, for: .normal)
         self.btncancel.setTitle("Cancel".localized, for: .normal)
        self.lblUpcoming.textColor = Constants.kGreenColor
//        self.lblUpcoming_company.textColor =  Constants.kGreenColor
        self.uv_under_Upcoming.isHidden = false

        self.btn_clear.setTitle("Clear".localized, for: .normal)
        self.Constraint_Menu_Left.constant = -250
        self.MenuView.isHidden = true
        
        self.TBL_menu.register(UINib.init(nibName: "MenuHeaderCell", bundle: nil), forCellReuseIdentifier: "MenuHeaderCell")
        
        self.TBL_menu.register(UINib.init(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
        
        refreshControl.addTarget(self, action: #selector(pullToRefreshView), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized)
        tbleViewHistory.refreshControl = refreshControl
        

        if isCompany {
            let user = DataManager.sharedInstance.user
            if user?.CompanyType == "cleaning" {
                self.viewPaid.isHidden = false
            }else{
                self.viewPaid.isHidden = true
            }
        }
        
        
    }
    func isArabic() -> Bool{
        let userDefaults = UserDefaults.standard
        if (userDefaults.value(forKey: "L") != nil) {
            if (userDefaults.value(forKey: "L") as! String) == "1" {
                return true
            }
        }
        
        return false
    }
   
    @objc func pullToRefreshView(){
        pageInfo = nil
        fetchBookingOrders()
    }
    func fetchBookingOrders(){
        return
        switch self.isType
        {
        case 1:
            APICAllPending()
        case 2:
            APICAllFinished()
        case 3:
            APICAllPaid()
        case 4:
            APICAllInProgree()
        case 5:
            APICAllConfirmed()
        case 6:
            APICAllCancelled()
        default:
            break
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    func runTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 8, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    @objc func updateTimer() {
         print("Call Notifcation API timer Interval = 8")
         getNotificationCount()
    }
    
    func getNotificationCount()  {
        
        NetworkManager.get("notifications/unread", isLoading: false,handleFailure: false, onView: self) { (mainResponse) in
            print(mainResponse ?? [:])
            if let data = mainResponse?["data"] as? [String : Any]{
                if let cont : Int =  data["unread_count"] as? Int{
                    if cont > 0 {
                        self.notification_badge_view.isHidden = false
                        self.lbl_notification_count.text = "\(cont)"
                    }else{
                        self.notification_badge_view.isHidden = true
                        self.lbl_notification_count.text = "\(0)"
                    }
                }
            }
            
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tbleViewHistory.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
        if isCompany {
            self.lbl_Title.text = "Fareed".localized //"Cleaning & Maintenance".localized
            self.IMG_Menu_icon.image = #imageLiteral(resourceName: "menu")
            self.Notificaiton_btn_view.isHidden = false
            self.Calendar_menu_view.isHidden = false
            pageInfo = nil
//            fetchBookingOrders()
            if DataManager.sharedInstance.isCleaningCompany() {
//                self.Compny_tab_view.isHidden = true
            }else{
//                self.Compny_tab_view.isHidden = false
            }
            
          
            self.runTimer()
            self.getNotificationCount()
            
        }else{
            self.lbl_Title.text = "History".localized
//             self.Compny_tab_view.isHidden = true
            
            if self.isArabic() {
                self.IMG_Menu_icon.image = #imageLiteral(resourceName: "backArabic")
            }else {
             self.IMG_Menu_icon.image = #imageLiteral(resourceName: "back")
            }
            self.Notificaiton_btn_view.isHidden = true
            self.Calendar_menu_view.isHidden = true
            pageInfo = nil
            fetchBookingOrders()
//            if  (UIApplication.shared.delegate as! AppDelegate).isRefreshAfterCancel {
//                self.APICAllPending()
//                self.APICAllConfirmed()
//                self.APICAllFinished()
//                self.APICAllCancelled()
//                self.APICAllInProgree()
//                self.APICAllPaid()
//                (UIApplication.shared.delegate as! AppDelegate).isRefreshAfterCancel = false
//            }
        }
    }
    
    
    
    func APICAllPending(){
        enableButton(value: false)
        isPending = true
        var url = "user/bookings/pending?page=\(nextPage)"
        if let date = dateSeconds {
            url = url + "&booking_date=\(date)"
        }
        
        NetworkManager.get(url, isLoading: (nextPage == 1), onView: self) { (mainResponse) in
            print(mainResponse)
            
            if (mainResponse?["status_code"] as! Int)  == 200 {
                let pageDictionary = mainResponse?["pagination"] as? [String : Any]
                
                self.pageInfo = PageInfo.parsePageInfo(pageDictionary)
                if let pageInfo = self.pageInfo {
                    if pageInfo.current_page == 1 {
                        self.arrayMainPending = mainResponse?["data"] as! [[String : Any]]
                    }
                    else{
                        self.arrayMainPending += mainResponse?["data"] as! [[String : Any]]
                    }
                }
                else{
                    self.arrayMainPending = []
                }
                
                
                self.ReloadData()
            }else {
                self.ShowErrorAlert(message: (mainResponse?["message"] as! String))
            }
            
            if self.isType == 1 {
                self.arrayMaintbleView = self.arrayMainPending
                self.ReloadData()
                
                self.tbleViewHistory.reloadData()
            }
            
            
            self.enableButton()
        }
    }
    
    func APICAllConfirmed(){
        isPending = false
        appi_call = "user/bookings/confirmed"
        enableButton(value: false)
        var url = "user/bookings/confirmed?page=\(nextPage)"
        if let date = dateSeconds {
            url = url + "&booking_date=\(date)"
        }
        
        NetworkManager.get(url, isLoading: (nextPage == 1), onView: self) { (mainResponse) in
            print(mainResponse)
            if (mainResponse?["status_code"] as! Int)  == 200 {
                let pageDictionary = mainResponse?["pagination"] as? [String : Any]
                self.pageInfo = PageInfo.parsePageInfo(pageDictionary)
                if let pageInfo = self.pageInfo{
                    if pageInfo.current_page == 1 {
                        self.arrayMainConfirmed = mainResponse?["data"] as! [[String : Any]]
                    }
                    else{
                        self.arrayMainConfirmed += mainResponse?["data"] as! [[String : Any]]
                    }
                }
                else{
                    self.arrayMainConfirmed = []// mainResponse?["data"] as! [[String : Any]]
                }
                
                self.ReloadData()
            }else {
                self.ShowErrorAlert(message: (mainResponse?["message"] as! String))
            }
            
            if self.isType == 5 {
                self.arrayMaintbleView = self.arrayMainConfirmed
                self.ReloadData()
                self.tbleViewHistory.reloadData()
                
            }
            self.enableButton()
        }
    }
    
    func APICAllFinished(){
        isPending = false
        appi_call = "user/bookings/finished"
        enableButton(value: false)
        var url = "user/bookings/finished?page=\(nextPage)"
        if let date = dateSeconds {
            url = url + "&booking_date=\(date)"
        }
        NetworkManager.get(url, isLoading: (nextPage == 1), onView: self) { (mainResponse) in
            print(mainResponse)
            
            if self.isType != 2{
                return
            }
            
            if (mainResponse?["status_code"] as! Int)  == 200 {
                
                let pageDictionary = mainResponse?["pagination"] as? [String : Any]
                self.pageInfo = PageInfo.parsePageInfo(pageDictionary)
                if let pageInfo = self.pageInfo {
                    if pageInfo.current_page == 1 {
                        self.arrayMainFinished = mainResponse?["data"] as! [[String : Any]]
                    }
                    else{
                        self.arrayMainFinished += mainResponse?["data"] as! [[String : Any]]
                    }
                }
                else{
                    self.arrayMainFinished = []
                }
                
                
                self.ReloadData()
            }else {
                self.ShowErrorAlert(message: (mainResponse?["message"] as! String))
            }
            
            if self.isType == 2 {
                self.arrayMaintbleView = self.arrayMainFinished
                self.ReloadData()
                self.tbleViewHistory.reloadData()
            }
            
            self.enableButton()
        }
    }
    
    func APICAllCancelled(){
        isPending = false
        appi_call = "user/bookings/cancelled"
        enableButton(value: false)
        NetworkManager.get("user/bookings/cancelled?page=\(nextPage)", isLoading: (nextPage == 1), onView: self) { (mainResponse) in
            print(mainResponse)
            
            if self.isType != 6{
                return
            }
            
            if (mainResponse?["status_code"] as! Int)  == 200 {
                let pageDictionary = mainResponse?["pagination"] as? [String : Any]
                self.pageInfo = PageInfo.parsePageInfo(pageDictionary)
                if let pageInfo = self.pageInfo{
                    if pageInfo.current_page == 1 {
                        self.arrayMainCancelled = mainResponse?["data"] as! [[String : Any]]
                    }
                    else{
                        self.arrayMainCancelled += mainResponse?["data"] as! [[String : Any]]
                    }
                }
                else{
                    self.arrayMainCancelled = []
                }
                
                self.ReloadData()
            }else {
                self.ShowErrorAlert(message: (mainResponse?["message"] as! String))
            }
            
            if self.isType == 6 {
                self.arrayMaintbleView = self.arrayMainCancelled
                self.ReloadData()
                self.tbleViewHistory.reloadData()
            }
           self.enableButton()
        }
    }
    
    
    @IBAction func OnClickNotificaiton(_ sender: Any) {
        self.PushView(nameViewController: "NotificationVC", nameStoryBoard: "Main")
    }
    @IBAction func OnClickCalander(_ sender: Any) {
         self.date_picker_view.isHidden = false
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
        let date2 = dateformator.date(from: dateString)
        
        dateSeconds = Int(date2!.timeIntervalSince1970)
        lc_tabbarViewTop.constant = 30
        DataManager.sharedInstance.filter_date = dateSeconds
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Booking_Filter_Date_upated"), object: nil, userInfo: nil)
        
//        fetchBookingOrders()
//        let datefoamter = "E, d MMM yyyy"
        
        
        
        
        
        
        
        
    }
    @IBAction func Back_Action(){
        if isCompany {
            self.TBL_menu.reloadData()
            self.MenuView.isHidden = false
            self.MenuView.fadeIn()
            DispatchQueue.main.async {
//                print(self.Constraint_Menu_Left.constant)
                self.Constraint_Menu_Left.constant = 250
                UIView.animate(withDuration: 0.5, animations: {
                    self.MenuView.layoutIfNeeded()
                    self.MenuView_detail.layoutIfNeeded()
                    self.view.layoutIfNeeded()
                    
                })
            }
        }else{
//            for controller in self.navigationController!.viewControllers as Array {
//                if controller.isKind(of: HomeVC.self) {
//                    self.navigationController!.popToViewController(controller, animated: false)
//                    break
//                }
//            }
             self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if tableView.tag == 555 {
           return self.getMenuData().count + 1
        }
        
        return  self.arrayMaintbleView.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
////    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("Table will display Cell Row:\(indexPath.row) Section:\(indexPath.section)")
        if tableView.tag == 55 {
            
        }
        else{
            if DataManager.sharedInstance.getPermanentlySavedUser()?.user_type == "company"{
                if !isRequestSent && isLoadMore && (indexPath.row == (arrayMaintbleView.count - 1))  {
                    fetchBookingOrders()
                }
            }
            
            else{
                if !isRequestSent && isLoadMore && (indexPath.row == (arrayMaintbleView.count - 1))  {
                    fetchBookingOrders()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView.tag == 555 {
            if(indexPath.row == 0){
                let cell = tableView.dequeueReusableCell(withIdentifier: "MenuHeaderCell") as! MenuHeaderCell
                cell.setUI()
                cell.selectionStyle = .none
                cell.delegate = self
//                menuheader.delegate = self
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
                cell.IMG_icon.image = self.getMenuData()[indexPath.row-1]["image"] as? UIImage
                cell.LBL_title.text =  self.getMenuData()[indexPath.row-1]["title"] as? String
                
                cell.LBL_notificationCount.isHidden = true
                if isCompany{
                    if(indexPath.row == 4 || indexPath.row == 6){
                        cell.View_line.isHidden = false
                    }else{
                        cell.View_line.isHidden = true
                    }
                }else{
                    if(indexPath.row == 6){
                        cell.View_line.isHidden = false
                    }else{
                        cell.View_line.isHidden = true
                    }
                }
                cell.selectionStyle = .none
                
                return cell
            }
        }else {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
            cell.selectionStyle = .none
            var start_time  = "Start Timing".localized
//            if isPending ||  self.isType == 5{
                start_time = "Booking Time".localized
//            }else{
//                 start_time = "Start Timing"
//            }
            var companyInfo = [String : Any]()
            if DataManager.sharedInstance.getPermanentlySavedUser()?.user_type == "company"{
                
                companyInfo =  self.arrayMaintbleView[indexPath.row]["user"] as! [String : Any]
                cell.lblName.text = companyInfo["full_name"] as? String
//                print(self.arrayMaintbleView[indexPath.row])
//                cell.lblStartTime.text = "\(start_time): " + (String(describing: self.arrayMaintbleView[indexPath.row]["start_time"]  as! Int).GetTimeFormDate(value: "h:mm a"))
                let startTime = arrayMaintbleView[indexPath.row]["start_time"] as! Double
                let endTime = arrayMaintbleView[indexPath.row]["end_time"] as! Double
                
                
                
                cell.lblStartTime.text = "\(start_time): " + String.timeFromDate(formate: "h:mm a", date: startTime) + "-" + String.timeFromDate(formate: "h:mm a", date: endTime)
                
//                cell.lblDate.text = String(describing: self.arrayMaintbleView[indexPath.row]["booking_date"]  as! Int).GetTimeFormDate(value: "dd MMM yyy")
                
                let bDate = self.arrayMaintbleView[indexPath.row]["booking_date"]  as! Double
                
                cell.lblDate.text = String.timeFromDate(formate: "dd MMM yyy", date: bDate)
                
                
                cell.imgvieWMain.sd_setImage(with: URL.init(string: companyInfo["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
                
            }else {
                companyInfo =  self.arrayMaintbleView[indexPath.row]["company"] as! [String : Any]
                var translationInfo =  companyInfo["translation"] as! [String : Any]
                cell.lblName.text = translationInfo["title"] as? String
//                print(self.arrayMaintbleView[indexPath.row])
                cell.lblStartTime.text = "\(start_time): " + (String(describing: self.arrayMaintbleView[indexPath.row]["start_time"]  as! Int).GetTimeFormDate(value: "h:mm a")) + " - "  + (String(describing: self.arrayMaintbleView[indexPath.row]["end_time"]  as! Int).GetTimeFormDate(value: "h:mm a"))
                cell.lblDate.text = String(describing: self.arrayMaintbleView[indexPath.row]["booking_date"]  as! Int).GetTimeFormDate(value: "dd MMM yyy")
                
                cell.imgvieWMain.sd_setImage(with: URL.init(string: companyInfo["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
            }
            return cell
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath)
        if tableView.tag == 555 {
            if !self.CheckLogin(){
                return
            }
            switch indexPath.row {
            case 1:
                self.CloseMenu()
                break
                
            case 2:
                self.CloseMenu()
                if isCompany{
                    // Open Client
                    self.PushView(nameViewController: "ClientVC", nameStoryBoard: "Booking")
                }else{
                    self.PushViewWithIdentifier(name: "HistoryViewController")
                }
                
                
                break
            case 3:
                self.CloseMenu()
                if isCompany {
                    // Open Reviews
                    self.PushView(nameViewController: "CompanyReviewVC", nameStoryBoard: "Booking")
                }else{
                    self.PushViewWithIdentifier(name: "AddressBookVC")
                }
                break
            case 4:
                self.CloseMenu()
                if isCompany {
                    // Open Usr Profile
                    self.PushViewWithIdentifier(name: "EditProfileViewController")
                }else{
                    self.PushViewWithIdentifier(name: "NotificationVC")
                }
                
                break
            case 5:
                self.CloseMenu()
                if isCompany {
                    // Open Company Profile
                    self.PushView(nameViewController: "CompanyPofileVC", nameStoryBoard: "Booking")
                }else{
                    self.PushViewWithIdentifier(name: "EditProfileViewController")
                }
                
                break
                
            case 6:
                self.CloseMenu()
                if isCompany {
                    // Open Manage Cleaners
                    self.PushView(nameViewController: "ManageCleanerVC", nameStoryBoard: "Booking")
                }else{
                    self.PushViewWithIdentifier(name: "CompanyInfoViewController")
                }
                
                break
                
            case 7:
                self.CloseMenu()
                self.PushViewWithIdentifier(name: "SelectLanguageVC")
                break
                
            case 8:
                self.CloseMenu()
                self.PushViewWithIdentifier(name: "SelectCurencyVC")
                break
                
                
            case 9:
                self.CloseMenu()
                self.PushViewWithIdentifier(name: "TestimonialVC")
                break
            case 10:
                self.CloseMenu()
                self.PushViewWithIdentifier(name: "FaqVC")
                break
            case 11:
                self.CloseMenu()
                self.PushViewWithIdentifier(name: "TermsConditionVC")
                break
            case 12:
                self.CloseMenu()
                self.PushViewWithIdentifier(name: "PrivacyPolicyVC")
                break
            case 13:
                self.CloseMenu()
                self.PushViewWithIdentifier(name: "AboutUsVC")
                break
            case 14:
                self.CloseMenu()
                self.PushViewWithIdentifier(name: "ConactUs")
                break
                
            default:
                break
                
            }
        }else {
            if isCompany {
                let HistoryDetail = self.storyboard?.instantiateViewController(withIdentifier: "CompanyBookingDetailViewController") as! CompanyBookingDetailViewController
                HistoryDetail.mainData = self.arrayMaintbleView[indexPath.row]
                HistoryDetail.isType = self.isType
                self.navigationController?.pushViewController(HistoryDetail, animated: true)
            }else {
                let HistoryDetail = self.storyboard?.instantiateViewController(withIdentifier: "HistoryDetailsVC") as! HistoryDetailsVC
                HistoryDetail.mainData = self.arrayMaintbleView[indexPath.row]
                HistoryDetail.isType = self.isType
                self.navigationController?.pushViewController(HistoryDetail, animated: true)
            }
                
            
            
            
            
        }
        
     
    }
    
    func getMenuData() -> [[String : Any]] {
        
            var data = [[String : Any]] ()
            data.append(["image" : #imageLiteral(resourceName: "home") , "title" : "Home".localized])
            data.append(["image" : #imageLiteral(resourceName: "proffesional") , "title" : "Clients".localized])
            data.append(["image" : #imageLiteral(resourceName: "reviews") , "title" : "Reviews".localized])
            data.append(["image" : #imageLiteral(resourceName: "profile") , "title" : "User Profile".localized])
            data.append(["image" : #imageLiteral(resourceName: "profile") , "title" : "Company Profile".localized])
            data.append(["image" : #imageLiteral(resourceName: "cleaners") , "title" : "Manage Employment".localized])
            data.append(["image" : #imageLiteral(resourceName: "language") , "title" : "Change Language".localized])
            data.append(["image" : #imageLiteral(resourceName: "currency") , "title" : "Currency".localized])
            data.append(["image" : #imageLiteral(resourceName: "testimonials") , "title" : "Testimonials".localized])
            data.append(["image" : #imageLiteral(resourceName: "FAQ") , "title" : "FAQ".localized])
            data.append(["image" : #imageLiteral(resourceName: "terms&condition") , "title" : "Terms & Conditions".localized])
            data.append(["image" : #imageLiteral(resourceName: "password") , "title" : "Privacy Policy".localized])
            data.append(["image" : #imageLiteral(resourceName: "about") , "title" : "About".localized])
            data.append(["image" : #imageLiteral(resourceName: "Contact") , "title" : "Contact Us".localized])
            return data
        
        
    }
    
    func loginAction(cell: MenuHeaderCell) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    
    
    
    func APICAllInProgree(){
        isPending = false
        appi_call = "user/bookings/in-progress"
//        enableButton(value: false)
        var url = "user/bookings/in-progress?page=\(nextPage)"
        if let date = dateSeconds {
            url = url + "&booking_date=\(date)"
        }
        NetworkManager.get(url, isLoading: (nextPage == 1), onView: self) { (mainResponse) in
            print(mainResponse)
            if self.isType != 4 {
                return
            }
            if (mainResponse?["status_code"] as! Int)  == 200 {
                let pageDictionary = mainResponse?["pagination"] as? [String : Any]
                self.pageInfo = PageInfo.parsePageInfo(pageDictionary)
                if let pageInfo = self.pageInfo {
                    if pageInfo.current_page == 1 {
                        self.arrayMainInProgree = mainResponse?["data"] as! [[String : Any]]
                    }
                    else{
                        self.arrayMainInProgree += mainResponse?["data"] as! [[String : Any]]
                    }
                }
                else{
                    self.arrayMainInProgree = []
                }
                
                self.ReloadData()
            }else {
                self.ShowErrorAlert(message: (mainResponse?["message"] as! String))
            }
            
            if self.isType == 4 {
                self.arrayMaintbleView = self.arrayMainInProgree
                self.ReloadData()
                self.tbleViewHistory.reloadData()
            }
            self.enableButton()
        }
    }
    
    
    
    
    func APICAllPaid(){
        isPending = false
        appi_call = "user/bookings/payed"
        enableButton(value: false)
        var url = "user/bookings/payed?page=\(nextPage)"
        if let date = dateSeconds {
            url = url + "&booking_date=\(date)"
        }
        NetworkManager.get(url, isLoading: (nextPage == 1), onView: self) { (mainResponse) in
            print(mainResponse)
            if (mainResponse?["status_code"] as! Int)  == 200 {
                let pageDictionary = mainResponse?["pagination"] as? [String : Any]
                self.pageInfo = PageInfo.parsePageInfo(pageDictionary)
                if let pageInfo = self.pageInfo {
                    if pageInfo.current_page == 1 {
                        self.arrayMainPaid = mainResponse?["data"] as! [[String : Any]]
                    }
                    else{
                        self.arrayMainPaid += mainResponse?["data"] as! [[String : Any]]
                    }
                }
                else{
                    self.arrayMainPaid = []
                }
                
                self.ReloadData()
            }else {
                self.ShowErrorAlert(message: (mainResponse?["message"] as! String))
            }
            
            if self.isType == 3 {
                self.arrayMaintbleView = self.arrayMainPaid
                self.ReloadData()
                self.tbleViewHistory.reloadData()
            }
            
           self.enableButton()
        }
    }
    
    
    @IBAction func Upcoming(sender : UIButton){
        if isType == 1 {
            return
            
        }
        
        self.REloadViews()
        self.isType = 1
        self.lblUpcoming.textColor = Constants.kGreenColor
        self.uv_under_Upcoming.isHidden = false
        self.lblUpcoming.textColor = Constants.kGreenColor
        //        self.viewUpcoming_company.isHidden = false
        
        self.pageInfo = nil
        self.arrayMaintbleView = []
        self.tbleViewHistory.reloadData()
        //        if self.arrayMainPending.count > 0 {
        //            self.arrayMaintbleView = self.arrayMainPending
        //            self.tbleViewHistory.reloadData()
        //        }else {
        self.APICAllPending()
        //        }
        
    }
    @IBAction func Confirm(sender : UIButton){
        if self.isType == 5 {
            return
        }
        self.REloadViews()
        self.isType = 5
//        self.lblEompleted.textColor = Constants.kGreenColor
        self.uv_under_Confirm.isHidden = false
        self.lblConfirm.textColor = Constants.kGreenColor
//        self.viewEompleted.isHidden = false
        self.pageInfo = nil
        self.arrayMaintbleView = []
        self.tbleViewHistory.reloadData()
//        if self.arrayMainFinished.count > 0 {
//            self.arrayMaintbleView = self.arrayMainFinished
//            self.tbleViewHistory.reloadData()
//        }else {
            self.APICAllConfirmed()
//        }
        
    }
    @IBAction func Paid(sender : UIButton){
        if self.isType == 3 {
            return
        }
        self.REloadViews()
        self.isType = 3
        self.lblPaid.textColor = Constants.kGreenColor
        self.uv_under_Paid.isHidden = false
        self.pageInfo = nil
        self.arrayMaintbleView = []
        self.tbleViewHistory.reloadData()
        //        if self.arrayMainPaid.count > 0 {
        //            self.arrayMaintbleView = self.arrayMainPaid
        //            self.tbleViewHistory.reloadData()
        //        }else {
        self.APICAllPaid()
        //        }
        
    }
    @IBAction func InProgree(sender : UIButton){
        if self.isType == 4 {
            return
        }
        self.REloadViews()
        self.isType = 4
        self.lblInProgress.textColor = Constants.kGreenColor
        self.uv_under_InProgress.isHidden = false
        self.lblInProgress.textColor = Constants.kGreenColor
        //        self.viewInProgress_company.isHidden = false
        self.pageInfo = nil
//        self.arrayMaintbleView = []
        self.tbleViewHistory.reloadData()
        //        if self.arrayMainInProgree.count > 0 {
        //            self.arrayMaintbleView = self.arrayMainInProgree
        //            self.tbleViewHistory.reloadData()
        //        }else {
        self.APICAllInProgree()
        //        }
        
    }
    @IBAction func Completed(sender : UIButton){
        if self.isType == 2 {
            return
        }
        
        self.REloadViews()
        self.isType = 2
//        self.lblConfirm.textColor = Constants.kGreenColor
        self.uv_under_Eompleted.isHidden = false
        self.lblEompleted.textColor = Constants.kGreenColor
//        self.viewConfirm_company.isHidden = false
        self.pageInfo = nil
//        self.arrayMaintbleView = []
        self.tbleViewHistory.reloadData()
//        if self.arrayMainConfirmed.count > 0 {
//            self.arrayMaintbleView = self.arrayMainConfirmed
//            self.tbleViewHistory.reloadData()
//        }else {
            self.APICAllFinished()
//        }
    }
    @IBAction func Cancelled(sender : UIButton){
        if isType == 6 {
            return
        }
        
        self.REloadViews()
        self.isType = 6
        self.lblCanceled.textColor = Constants.kGreenColor
        self.uv_under_Canceled.isHidden = false
        self.lblCanceled.textColor = Constants.kGreenColor
//        self.viewCanceled_company.isHidden = false
        self.pageInfo = nil
//        self.arrayMaintbleView = []
        self.tbleViewHistory.reloadData()
//        if self.arrayMainCancelled.count > 0 {
//            self.arrayMaintbleView = self.arrayMainCancelled
//            self.tbleViewHistory.reloadData()
//        }else {
            self.APICAllCancelled()
//        }
    }
    
    
    func REloadViews(){
        self.lblConfirm.textColor = UIColor.black
        self.lblCanceled.textColor = UIColor.black
        self.lblUpcoming.textColor = UIColor.black
        self.lblEompleted.textColor = UIColor.black
        self.lblPaid.textColor = UIColor.black
        self.lblInProgress.textColor = UIColor.black
//        self.viewPaid.isHidden = true
//        self.lblConfirm_company.textColor = UIColor.black
//        self.lblCanceled_company.textColor = UIColor.black
//        self.lblUpcoming_company.textColor = UIColor.black
//        self.lblEompleted_company.textColor = UIColor.black
//        self.lblInProgress_company.textColor = UIColor.black
        
        self.uv_under_Upcoming.isHidden = true
        self.uv_under_Confirm.isHidden = true
        self.uv_under_Paid.isHidden = true
        self.uv_under_InProgress.isHidden = true
        self.uv_under_Eompleted.isHidden = true
        self.uv_under_Canceled.isHidden = true
//        self.viewConfirm.isHidden = true
//        self.viewCanceled.isHidden = true
//        self.viewUpcoming.isHidden = true
//        
//        self.viewInProgress.isHidden = true
//        self.viewEompleted_company.isHidden = true
//        self.viewConfirm_company.isHidden = true
//        self.viewCanceled_company.isHidden = true
//        self.viewUpcoming_company.isHidden = true
//        self.viewInProgress_company.isHidden = true
        
    }
    
    //MARK: Menu Action
    func enableButton(value : Bool = true){
        if value {
            self.refreshControl.endRefreshing()
        }
        
        isRequestSent = !value
//        btn_pending.isEnabled = value
//        btn_confirmed.isEnabled = value
//        btn_inProgress.isEnabled = value
//        btn_finish.isEnabled = value
//        btn_cancelled.isEnabled = value
    }
    @IBAction func OnClickCloseMenu(_ sender: Any) {
        self.CloseMenu()
    }
    
    func CloseMenu() {
        self.MenuView.fadeOut()
        DispatchQueue.main.async {
//            print(self.Constraint_Menu_Left.constant)
            self.Constraint_Menu_Left.constant = -250
            UIView.animate(withDuration: 0.5, animations: {
                self.MenuView.layoutIfNeeded()
                self.MenuView_detail.layoutIfNeeded()
                self.view.layoutIfNeeded()
                
            })
        }
    }
    @IBAction func OnClickMenu(_ sender: Any) {
        self.MenuView.isHidden = false
        self.MenuView.fadeIn()
        self.TBL_menu.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .bottom, animated: false)

        DispatchQueue.main.async {
//            print(self.Constraint_Menu_Left.constant)
            self.Constraint_Menu_Left.constant = 250
            UIView.animate(withDuration: 0.5, animations: {
                self.MenuView.layoutIfNeeded()
                self.MenuView_detail.layoutIfNeeded()
                self.view.layoutIfNeeded()
                
            })
        }
    }
    @IBAction func onclick_clear(_ sender: Any) {
        lc_tabbarViewTop.constant = 0
        pageInfo = nil
        dateSeconds = nil
        
        DataManager.sharedInstance.filter_date = nil
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Booking_Filter_Date_upated"), object: nil, userInfo: nil)
        fetchBookingOrders()
        
    }
    func ReloadData(){
        if(self.arrayMaintbleView.count == 0){
            self.tbleViewHistory.NoDataAvailable(text: "No Booking Present".localized)
        }else{
            self.tbleViewHistory.RemoNoDataLbl()
        }
        
    }
    
    
    ///////////////////
    func ShowErrorAlert(message : String , AlertTitle : String = "Alert".localized) {
        let alert = UIAlertController(title: AlertTitle , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: kOKBtnTitle, style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        })
        self.present(alert, animated: true, completion: nil)
    }
    func PushViewWithIdentifier(name : String , isanimated : Bool = true) {


        let viewPush = self.storyboard?.instantiateViewController(withIdentifier: name)
        self.navigationController?.pushViewController(viewPush!, animated: isanimated)

        
        
        
    }
    func PushView(nameViewController : String , nameStoryBoard : String , isAnimated : Bool = true)  {
        let storyboard = UIStoryboard(name: nameStoryBoard, bundle: nil)
        let viewObj = (storyboard.instantiateViewController(withIdentifier: nameViewController)) as UIViewController
        
        self.navigationController?.pushViewController(viewObj, animated: isAnimated)
        
    }
    func CheckLogin() -> Bool{
        if DataManager.sharedInstance.getPermanentlySavedUser() == nil || DataManager.sharedInstance.getPermanentlySavedUser()?.session_token == nil ||
            DataManager.sharedInstance.getPermanentlySavedUser()?.session_token == ""  {
            self.PushViewWithIdentifier(name: "LoginVC")
            return false
        }
        return true
    }
}


