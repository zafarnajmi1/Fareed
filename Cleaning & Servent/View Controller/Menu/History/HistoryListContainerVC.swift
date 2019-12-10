//
//  HistoryListContainerVC.swift
//  Fareed
//
//  Created by Asif Habib on 18/10/2019.
//  Copyright © 2019 Jaidee. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class HistoryListContainerVC: UIViewController, IndicatorInfoProvider {
    
    

    var pageURL : String = ""
    var historyItems = [[String : Any]]()
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
    var dateSeconds : Int?
    var refreshControl = UIRefreshControl()
    var isCompany : Bool = false
    var isType = 0
    var superNav : UINavigationController?
    
    @IBOutlet weak var tbl_history : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if DataManager.sharedInstance.getPermanentlySavedUser()?.user_type == "company"{
            isCompany = true
        }
        
        
        tbl_history.estimatedRowHeight = 1000
        refreshControl.addTarget(self, action: #selector(pullToRefreshView), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized)
        tbl_history.refreshControl = refreshControl
        tbl_history.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
        pageInfo = nil
        updatePageURL()
        APICAllHistoryList()
        print("History List VC ViewDidLoad Type:\(isType)")
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//
//
//        super.viewDidAppear(true)
//        print("History List VC viewWillAppear Type:\(isType)")
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        pageInfo = nil
        APICAllHistoryList()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        print("History List VC viewDidDisappear Type:\(isType)")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func updatePageURL(){
        switch isType {
        case 1:
            pageURL =  "user/bookings/pending?page="
        case 2:
            pageURL = "user/bookings/finished?page="
        case 3:
            pageURL = "user/bookings/payed?page="
        case 4:
            pageURL = "user/bookings/in-progress?page="
        case 5:
            pageURL = "user/bookings/confirmed?page="
        case 6:
            pageURL = "user/bookings/cancelled?page="
        default:
            print("Default Case Executed. Could Not find Right Type")
        }
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        
        switch isType {
        case 1:
            return IndicatorInfo.init(title: "Pending".localized)// pageURL =  "user/bookings/pending?page="
        case 2:
            return IndicatorInfo.init(title: "Finished".localized)//pageURL = "user/bookings/finished?page="
        case 3:
            return IndicatorInfo.init(title: "Paid".localized)//pageURL = "user/bookings/payed?page="
        case 4:
            return IndicatorInfo.init(title: "In progress".localized)//pageURL = "user/bookings/in-progress?page="
        case 5:
            return IndicatorInfo.init(title: "Confirmed".localized)//pageURL = "user/bookings/confirmed?page="
        case 6:
            return IndicatorInfo.init(title: "Cancelled".localized)//pageURL = "user/bookings/cancelled?page="
        default:
            return IndicatorInfo.init(title: "Pending".localized)//
            print("Default Case Executed. Could Not find Right Type")
        }
    }
    @objc func pullToRefreshView(){
        pageInfo = nil
        APICAllHistoryList()

    }
    func APICAllHistoryList(){

        var url = pageURL + "\(nextPage)"
        if let date = DataManager.sharedInstance.filter_date {
            url = url + "&booking_date=\(date)"
        }
        
        NetworkManager.get(url, isLoading: (nextPage == 1), onView: self) { [weak self] (mainResponse) in
            print(mainResponse ?? ["Dictionary":"Empty"])
            
            if (mainResponse?["status_code"] as! Int)  == 200 {
                let pageDictionary = mainResponse?["pagination"] as? [String : Any]
                
                self?.pageInfo = PageInfo.parsePageInfo(pageDictionary)
                if let pageInfo = self?.pageInfo {
                    if pageInfo.current_page == 1 {
                        self?.historyItems = mainResponse?["data"] as! [[String : Any]]
                    }
                    else{
                        self?.historyItems += mainResponse?["data"] as! [[String : Any]]
                    }
                }
                else{
                    self?.historyItems = []
                }
                self?.refreshControl.endRefreshing()
                self?.tbl_history.reloadData()
                self?.ReloadData()
            }else {
                self?.ShowErrorAlert(message: (mainResponse?["message"] as! String))
            }
        }
    }
    func ShowErrorAlert(message : String , AlertTitle : String = "Alert".localized) {
        let alert = UIAlertController(title: AlertTitle , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: kOKBtnTitle, style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        })
        self.present(alert, animated: true, completion: nil)
    }
    func ReloadData(){
        if(historyItems.count == 0){
            tbl_history.NoDataAvailable(text: "No Booking Present".localized)
        }else{
            tbl_history.RemoNoDataLbl()
        }
        
    }

}
extension HistoryListContainerVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        
        return  self.historyItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    //    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //
    ////    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("Table will display Cell Row:\(indexPath.row) Section:\(indexPath.section)")
        if !isRequestSent && isLoadMore && (indexPath.row == (historyItems.count - 1))  {
            APICAllHistoryList()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell  = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
            cell.selectionStyle = .none
            var start_time  = "Start Timing".localized
            start_time = "Booking Time".localized
    
        
            if DataManager.sharedInstance.getPermanentlySavedUser()?.user_type == "company"{
                
                var userInfo =  historyItems[indexPath.row]["user"] as! [String : Any]
                cell.lblName.text = userInfo["full_name"] as? String
                let startTime = historyItems[indexPath.row]["start_time"] as! Double
                let endTime = historyItems[indexPath.row]["end_time"] as! Double
                cell.lblStartTime.text = "\(start_time): " + String.timeFromDate(formate: "h:mm a", date: startTime) + "-" + String.timeFromDate(formate: "h:mm a", date: endTime)
                
                let bDate = historyItems[indexPath.row]["booking_date"]  as! Double
                
                cell.lblDate.text = String.timeFromDate(formate: "dd MMM yyy", date: bDate)
                
                
                cell.imgvieWMain.sd_setImage(with: URL.init(string: userInfo["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
                
            }else {
                var companyInfo =  historyItems[indexPath.row]["company"] as! [String : Any]
                var translationInfo =  companyInfo["translation"] as! [String : Any]
                cell.lblName.text = translationInfo["title"] as? String
                //                print(self.arrayMaintbleView[indexPath.row])
                cell.lblStartTime.text = "\(start_time): " + (String(describing: historyItems[indexPath.row]["start_time"]  as! Int).GetTimeFormDate(value: "h:mm a")) + " - "  + (String(describing: historyItems[indexPath.row]["end_time"]  as! Int).GetTimeFormDate(value: "h:mm a"))
                cell.lblDate.text = String(describing: historyItems[indexPath.row]["booking_date"]  as! Int).GetTimeFormDate(value: "dd MMM yyy")
                
                cell.imgvieWMain.sd_setImage(with: URL.init(string: companyInfo["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
            }
            return cell
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if isCompany {
            let HistoryDetail = self.storyboard?.instantiateViewController(withIdentifier: "CompanyBookingDetailViewController") as! CompanyBookingDetailViewController
            HistoryDetail.mainData = historyItems[indexPath.row]
            HistoryDetail.isType = isType
            DataManager.sharedInstance.current_nav?.pushViewController(HistoryDetail, animated: true)
        }else {
            let HistoryDetail = self.storyboard?.instantiateViewController(withIdentifier: "HistoryDetailsVC") as! HistoryDetailsVC
            HistoryDetail.mainData = historyItems[indexPath.row]
            HistoryDetail.isType = isType
            DataManager.sharedInstance.current_nav?.pushViewController(HistoryDetail, animated: true)
        }

        
    }
    
    
}
