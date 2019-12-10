//
//  SelectServiceStep2VC.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 3/15/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//
import UIKit

class SelectServiceStep2VC: BaseViewController, UITableViewDataSource , UITableViewDelegate , FilterDelegate{
    
     @IBOutlet weak var TBL_Componies: UITableView!
    
    @IBOutlet weak var imgViewBack: UIImageView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblTextOne: UILabel!
    @IBOutlet weak var lblTextTwo: UILabel!
    
    let kCloseCellHeight: CGFloat = 120
    var cellHeights: [CGFloat] = []
    var OpencellHeights: [CGFloat] = []
    
    var latchoose = ""
    var longchoose = ""
    
    var serviceType = ""
    var servicesSelected = [[String : Any]]()
    
    var anyCellIsOpen = false
    
    
    var currency : String {
        get {
            return DataManager.sharedInstance.getSelectedCurrency()
        }
    }
    
    
    var companyArray = [[String : Any]]()
    //For Pagination....
    var appi_call = ""
    var isRequestSent : Bool = false
    var ind = 0
    var refreshControl = UIRefreshControl()
    
    fileprivate var shouldLoadMore = true
    var pageNumber = 1
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
        }
        
        self.lblHeading.text = "Select Company".localized
        self.lblTextOne.text = "Step 2: Select Company".localized
        self.lblTextTwo.text = "Company".localized
        
        self.TBL_Componies.register(UINib(nibName: "ComponiesFoldingCell", bundle: nil), forCellReuseIdentifier: "ComponiesFoldingCell")
        self.TBL_Componies.estimatedRowHeight = kCloseCellHeight
        self.TBL_Componies.rowHeight = UITableView.automaticDimension
        
        refreshControl.addTarget(self, action: #selector(pullToRefreshView), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized)
        TBL_Componies.refreshControl = refreshControl
    }

    func enableButton(value : Bool = true){
        if value {
            self.refreshControl.endRefreshing()
        }
        isRequestSent = !value
    }
    
    @objc func pullToRefreshView(){
        pageInfo = nil
        //call api For Companies
        APICallforCompany()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func OnClickSelectFilter(_ sender: Any)
    {
        let FilterView = self.GetView(nameViewController: "FilterVC", nameStoryBoard: "Main") as! FilterVC
        FilterView.delegate  = self
        
        FilterView.serviceType = self.serviceType
        FilterView.servicesSelected = self.servicesSelected
        
        self.navigationController?.pushViewController(FilterView, animated: true)
    }
    
    func SearchText(searchText: String, latChoose: String, longChoose: String) {
       print(searchText)
        print(latChoose)
        print(longChoose)
        self.latchoose = latChoose
        self.longchoose = longChoose
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if self.companyArray.count == 0 {
            self.APICallforCompany()
//        }
        
    }
    
    func APICallforCompany(){
    
        
        enableButton(value: false)
        var newParam = [String : AnyObject]()
        newParam["company_type"] = self.serviceType as AnyObject
        
        var urlMain = ""
        
        for indexObj in self.servicesSelected{
            
            if urlMain.count == 0 {
                urlMain = String(indexObj["id"] as! Int)
            }else {
                urlMain = urlMain + "," + String(indexObj["id"] as! Int)
            }
        }
        
        urlMain = urlMain + "]&company_type=" + self.serviceType
      
        if self.latchoose.count > 0 {
            urlMain = urlMain + "&lat=" + self.latchoose
        }
        if self.longchoose.count > 0 {
            urlMain = urlMain + "&lng=" + self.longchoose
        }
        
        print(urlMain)
//        self.companyArray.removeAll()
        
        NetworkManager.get("companies?services=[" + urlMain + "&page=\(nextPage)" , isLoading: (nextPage == 1) , onView: self) { (Mainresponse) in
            print(Mainresponse)
            
            if (Mainresponse?["status_code"] as! Int)  == 200 {
                
                let pageDictionary = Mainresponse?["pagination"] as? [String : Any]
                
                self.pageInfo = PageInfo.parsePageInfo(pageDictionary)
                if self.pageInfo?.current_page == 1 {
                    
                    self.companyArray = Mainresponse?["data"] as! [[String : Any]]
                    
                }else{
                    self.companyArray += Mainresponse?["data"] as! [[String : Any]]
                }
                self.TBL_Componies.reloadData()
                //self.ReloadDataOfCompanies()
               // self.companyArray = Mainresponse?["data"] as! [[String : Any]]
            }else {
                self.ShowErrorAlert(message: (Mainresponse?["message"] as! String))
            }
            
            for indexObj in self.companyArray
            {
                var translation = indexObj["translation"] as! [String : Any]
                var aboutMain = translation["about"] as? String
                self.cellHeights.append(120)
                self.OpencellHeights.append(self.estimatedHeightOfLabel(text: aboutMain!) + 200)
            }
            
            self.enableButton()
            self.TBL_Componies.reloadData()
//            self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func OnClickLocation(_ sender: Any) {
        
        let viewPush = self.storyboard?.instantiateViewController(withIdentifier: "CompanyLocationVC") as! CompanyLocationVC
        viewPush.companyArray = self.companyArray
        viewPush.servicesSelected = servicesSelected
        viewPush.serviceType = serviceType
        self.navigationController?.pushViewController(viewPush, animated: true)
    }
    
    @IBAction func OnClicBack(_ sender: Any) {
        self.Back()
    }
    
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return self.companyArray.count
    }
    
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as ComponiesFoldingCell = cell else {
            return
        }
        
        if !isRequestSent && isLoadMore && (indexPath.row == (companyArray.count - 1))  {
            APICallforCompany()
        }
        
       cell.dataCompany = self.companyArray[indexPath.row]
        cell.backgroundColor = .clear
        cell.imgviewMain.sd_setImage(with: URL.init(string: self.companyArray[indexPath.row]["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)

        cell.imgviewMainTop.sd_setImage(with: URL.init(string: self.companyArray[indexPath.row]["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)

        cell.lblRating.text = String((self.companyArray[indexPath.row]["average_rating"] as! Double)).FloatValueTwo()
        cell.lblRatingTop.text = cell.lblRating.text
        
        if (self.companyArray[indexPath.row]["average_rating"] as! Double) < 1 {
            
            
            
            if (self.companyArray[indexPath.row]["average_rating"] as! Double) > 0.5 {
                
                cell.imgviewStar.image = #imageLiteral(resourceName: "starts1Half")
                cell.imgviewStarTop.image = #imageLiteral(resourceName: "starts1Half")
            }else {
                cell.imgviewStar.image = #imageLiteral(resourceName: "starts")
                cell.imgviewStarTop.image = #imageLiteral(resourceName: "starts")
            }
            
            
        }else if (self.companyArray[indexPath.row]["average_rating"] as! Double) < 1.5 {
            cell.imgviewStar.image = #imageLiteral(resourceName: "starts1")
            cell.imgviewStarTop.image = #imageLiteral(resourceName: "starts1")
            
        }else if (self.companyArray[indexPath.row]["average_rating"] as! Double) < 2 {
            cell.imgviewStar.image = #imageLiteral(resourceName: "starts1Half")
            cell.imgviewStarTop.image = #imageLiteral(resourceName: "starts1Half")
            
        }else if (self.companyArray[indexPath.row]["average_rating"] as! Double) < 2.5 {
            
            cell.imgviewStar.image = #imageLiteral(resourceName: "starts2")
            cell.imgviewStarTop.image = #imageLiteral(resourceName: "starts2")
        }else if (self.companyArray[indexPath.row]["average_rating"] as! Double) < 3 {
            cell.imgviewStar.image = #imageLiteral(resourceName: "starts2Half")
            cell.imgviewStarTop.image = #imageLiteral(resourceName: "starts2Half")
            
            
        }else if (self.companyArray[indexPath.row]["average_rating"] as! Double) < 3.5 {
            cell.imgviewStar.image = #imageLiteral(resourceName: "starts3")
            cell.imgviewStarTop.image = #imageLiteral(resourceName: "starts3")
            
        }else if (self.companyArray[indexPath.row]["average_rating"] as! Double) < 4 {
            cell.imgviewStar.image = #imageLiteral(resourceName: "starts3Half")
            cell.imgviewStarTop.image = #imageLiteral(resourceName: "starts3Half")
            
            
        }else if (self.companyArray[indexPath.row]["average_rating"] as! Double) < 4.5 {
            cell.imgviewStar.image = #imageLiteral(resourceName: "starts4")
            cell.imgviewStarTop.image = #imageLiteral(resourceName: "starts4")
            
        }else if (self.companyArray[indexPath.row]["average_rating"] as! Double) < 5 {
            cell.imgviewStar.image = #imageLiteral(resourceName: "starts4Half")
            cell.imgviewStarTop.image = #imageLiteral(resourceName: "starts4Half")
            
        }else {
            cell.imgviewStar.image = #imageLiteral(resourceName: "starts5")
            cell.imgviewStarTop.image = #imageLiteral(resourceName: "starts5")
            
        }
        
        var translation = self.companyArray[indexPath.row]["translation"] as! [String : Any]
        
        cell.lblDescription.text = translation["about"] as? String
        cell.lblName.text = translation["title"] as? String
        cell.lblNameTop.text = translation["title"] as? String
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
        
        let ratePrice = self.companyArray[indexPath.row]["rate_per_hour"] as! [String : Any]
        let priceMAin = ratePrice["usd"] as! [String : Any]
        
        let priceHourOMR = ratePrice["usd"] as! [String : Any]
        let priceHourAED = ratePrice["aed"] as! [String : Any]
        
        
//        let rateMeter = self.companyArray[indexPath.row]["rate_per_meter"] as! [String : Any]
//        let rateMeterPrice = rateMeter["usd"] as! [String : Any]
        
        if currency == "2"
        {
            cell.lblRate.text = "AED" + String(priceHourAED["amount"] as! Double)
//            cell.lblPerMeterRate.text = "AED" + String(rateMeterPrice["amount"] as! Int).FloatValue()
//            cell.lblPerMeterTopRate.text = "AED" + String(rateMeterPrice["amount"] as! Int).FloatValue()
        }
        else
        {
            cell.lblRate.text = "OMR" + String(priceHourOMR["amount"] as! Double)
//            cell.lblPerMeterRate.text = "OMR" + String(rateMeterPrice["amount"] as! Int).FloatValue()
//            cell.lblPerMeterTopRate.text = "OMR" + String(rateMeterPrice["amount"] as! Int).FloatValue()
        }
        
//        cell.lblPerMeterText.text = "Per Meter"
//        cell.lblPerMeterTopText.text = "Per Meter"
        
        cell.lblRateTop.text = cell.lblRate.text
        
//        cell.lblServicecount.text = "We Provide ".localized +  String(self.companyArray[indexPath.row]["services_count"] as! Int) + " Services".localized
        
        //cell.lblServicecountTop.text = cell.lblServicecount.text
        
        cell.lblWorkHour.text = self.getTime(milisecond:self.companyArray[indexPath.row]["time_starts"] as! Int) + "-" +  self.getTime(milisecond:self.companyArray[indexPath.row]["time_ends"] as! Int)
        
        cell.lblWorkHourTop.text = cell.lblWorkHour.text

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComponiesFoldingCell", for: indexPath) as! FoldingCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        
        return cell
    }
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        _ = cellHeights[indexPath.row] == kCloseCellHeight
        return cellHeights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        
        let cellIsCollapsed = cellHeights[indexPath.row] == kCloseCellHeight
        print(cellIsCollapsed)
        
        
//        if cellIsCollapsed {
//            if anyCellIsOpen {
//                return
//
//            }
//        }
        
        
        var duration = 0.0
        
        if cellIsCollapsed {
            
            if self.ind >= 0 {
                cellHeights[self.ind] = kCloseCellHeight
                cell.unfold(false, animated: true, completion: nil)
                duration = 0.2
                self.TBL_Componies.reloadData()
            }
            
            self.ind = indexPath.row
            cellHeights[indexPath.row] = OpencellHeights[indexPath.row]
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
//        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
            self.anyCellIsOpen = !self.anyCellIsOpen
//        }, completion: nil)
    }
}

extension String {
    func FloatValue() -> String{
        print(self)
        
        if self.count > 0 {
            return  String(format: "%.1f", Double(self)!)
        }else {
            return  "0.0"
        }
    }
    
    func FloatValueTwo() -> String{
        print(self)
        
        if self.count > 0 {
            return  String(format: "%.2f", Double(self)!)
        }else {
            return  "0.0"
        }
    }

}


extension SelectServiceStep2VC : UIScrollViewDelegate{
    
    func ReloadDataOfCompanies(){
        
        if(self.companyArray.count == 0){
            self.TBL_Componies.NoDataAvailable(text: "No Company Available".localized)
        }else{
            self.TBL_Componies.RemoNoDataLbl()
        }
        
    }
    
}
