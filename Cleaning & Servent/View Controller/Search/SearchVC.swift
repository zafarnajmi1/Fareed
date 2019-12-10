//
//  SearchVC.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 3/17/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class SearchVC: BaseViewController , UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout , UITableViewDataSource , UITableViewDelegate{
    @IBOutlet weak var imgViewBack: UIImageView!
    @IBOutlet weak var btnsearch: UIButton!

    @IBOutlet weak var txtFieldSearch: UITextField!
    let kCloseCellHeight: CGFloat = 120
    var cellHeights: [CGFloat] = []
    var OpencellHeights: [CGFloat] = []
    var arrayService = [[String : Any]]()
    var storeArrayService = [[String : Any]]()
    var companyArray = [[String : Any]]()
    var storedCompanyArray = [[String : Any]]()
    var anyCellIsOpen = false
    var indexArr = [Int]()
    var ind = 0
    var currency : String {
        get {
            return DataManager.sharedInstance.getSelectedCurrency()
        }
    }
    let kRowsCount = 10    
    var selectedArray = [Int]()
    @IBOutlet weak var TBL_Componies: UITableView!
    
    var arr : [Bool] = [false ,false ,false ,false ,false  ]
    var isExpand : Bool = false
    @IBOutlet weak var Services_Collection_view: UICollectionView!
    @IBOutlet weak var Services_View: UIView!
    @IBOutlet weak var IMG_indicator_componies: UIImageView!
    @IBOutlet weak var LBL_Componies: UILabel!
    @IBOutlet weak var IMG_indicator_services: UIImageView!
    @IBOutlet weak var LBL_Services: UILabel!
    
    var appi_call = ""
    var isRequestSent : Bool = false
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
    
    override func viewDidLoad(){
        super.viewDidLoad()
        LBL_Componies.text = "Companies".localized
        LBL_Services.text = "Services".localized
        btnsearch.setTitle("SEARCH".localized, for: .normal)
        self.txtFieldSearch.placeholder = "Search".localized
    
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
        }
        txtFieldSearch.addTarget(self, action: #selector(searchFieldChanged), for: .editingChanged)
        self.Services_Collection_view.register(UINib.init(nibName: "ServicesCell", bundle: nil), forCellWithReuseIdentifier: "ServicesCell")
        
        
        self.TBL_Componies.register(UINib(nibName: "ComponiesFoldingCell", bundle: nil), forCellReuseIdentifier: "ComponiesFoldingCell")
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        self.TBL_Componies.estimatedRowHeight = kCloseCellHeight
        self.TBL_Componies.rowHeight = UITableView.automaticDimension
        
        
        
        
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width:self.Services_Collection_view.frame.width, height: self.Services_Collection_view.frame.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        self.Services_Collection_view!.collectionViewLayout = layout
        
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
        APICallforCompany()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.companyArray.count == 0 {
              self.APICallforCompany()
        }
    }
    @objc func searchFieldChanged(){
        if Services_View.isHidden {
            if txtFieldSearch.text == "" {
                companyArray = storedCompanyArray
            }
            else{
                
                
                var array : [[String : Any]] = []
                for company in storedCompanyArray {
                    let translation = company["translation"] as! [String : Any]
                    let title = (translation["title"] as! String).lowercased()
                    if title.contains(txtFieldSearch.text!.lowercased()){
                        array.append(company)
                        
                    }
                }
                companyArray = array
                
                
            }
            TBL_Componies.reloadData()
        }
        else{
            if txtFieldSearch.text == "" {
                arrayService = storeArrayService
            }
            else{
                
                
                var array : [[String : Any]] = []
                for company in storeArrayService {
                    let translation = company["translation"] as! [String : Any]
                    let title = (translation["title"] as! String).lowercased()
                    if title.contains(txtFieldSearch.text!.lowercased()){
                        array.append(company)
                        
                    }
                }
                arrayService = array
                
                
            }
            Services_Collection_view.reloadData()
        }
        
    }
    @IBAction func OnClickComponies(_ sender: Any) {
        if self.TBL_Componies.isHidden {
            txtFieldSearch.text = ""
            self.LBL_Componies.textColor = UIColor.init(red: (90/255), green: (165/255), blue: (80/255), alpha: 1.0)
            self.IMG_indicator_componies.isHidden = false
            
            self.LBL_Services.textColor = UIColor.darkGray
            self.IMG_indicator_services.isHidden = true
            self.Services_View.isHidden = true
            self.TBL_Componies.isHidden = false
            APICallforCompany()
            //companyArray = storedCompanyArray
            TBL_Componies.reloadData()
        }
        
    }
    @IBAction func OnClickServices(_ sender: Any) {
        if self.Services_View.isHidden{
            txtFieldSearch.text = ""
            self.LBL_Services.textColor = UIColor.init(red: (90/255), green: (165/255), blue: (80/255), alpha: 1.0)
            self.IMG_indicator_services.isHidden = false
            
            self.LBL_Componies.textColor = UIColor.darkGray
            self.IMG_indicator_componies.isHidden = true
            self.Services_View.isHidden = false
            self.TBL_Componies.isHidden = true
            
            if self.arrayService.count == 0 {
                self.GetAllServices()
            }
            else{
                arrayService = storeArrayService
                Services_Collection_view.reloadData()
            }
        }
        
        
        
        
    }
    @IBAction func Back(_ sender: Any) {
        self.Back()
    }
    
    @IBAction func OnClickSearchService(_ sender: Any) {
          self.PushViewWithIdentifier(name: "SelectServiceStep2VC")
    }
    
    //MARK : Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayService.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (self.Services_Collection_view.bounds.size.width/3) , height: (self.Services_Collection_view.bounds.size.width/3))
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "ServicesCell", for: indexPath) as! ServicesCell
        cell.check_box_img.image = UIImage.init(named: "uncheckselectedcheckbox")
        let translation = self.arrayService[indexPath.row]["translation"] as! [String : Any]
        
        cell.service_name.text = translation["title"] as? String
        cell.img.sd_setImage(with: URL.init(string: self.arrayService[indexPath.row]["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
        
        
        print(self.arrayService.count % 3)
        cell.bottomView.isHidden = false
        if indexPath.row >= (self.arrayService.count - (self.arrayService.count % 3) ) {
            cell.bottomView.isHidden = true
            
        }
        
        cell.rightView.isHidden = false
        if ((indexPath.row + 1)  % 3) == 0  {
            cell.rightView.isHidden = true
            
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.Services_Collection_view.cellForItem(at: indexPath) as! ServicesCell
        let chk = UIImage.init(named: "uncheckselectedcheckbox")
//        print(chk)
        //#imageLiteral(resourceName: "check_box")
        if(cell.check_box_img.image == chk ){
            cell.check_box_img.image = UIImage.init(named: "selectedcheckbox") // #imageLiteral(resourceName: "check_box_checked")
        }else{
            cell.check_box_img.image = chk // #imageLiteral(resourceName: "check_box")
        }
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
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComponiesFoldingCell", for: indexPath) as! ComponiesFoldingCell
        let durations: [TimeInterval] = [0.1, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        
        
        cell.workingHours.text = "Working Hour".localized
        cell.dataCompany = self.companyArray[indexPath.row]
        cell.backgroundColor = .clear
        
        cell.lblPerHour.text = "Per Hour".localized
        cell.lblPerHourTop.text = "Per Hour".localized
        
//        cell.lblPerMeterText.text = "Per Meter"
//        cell.lblPerMeterTopText.text = "Per Meter"
//
        
        
      
        let ratePrice = self.companyArray[indexPath.row]["rate_per_hour"] as! [String : Any]
        let priceHourOMR = ratePrice["usd"] as! [String : Any]
        let priceHourAED = ratePrice["aed"] as! [String : Any]
        
//        let rateMeter = self.companyArray[indexPath.row]["rate_per_meter"] as! [String : Any]
////        let rateMeterPrice = rateMeter["usd"] as! [String : Any]
//        let priceMeterOMR = ratePrice["usd"] as! [String : Any]
//        let priceMeterAED = ratePrice["aed"] as! [String : Any]
        
        if currency == "2"
        {
            cell.lblRateTop.text = "AED" + String(priceHourAED["amount"] as! Double) //"AED " + (priceHourAED["formatted"] as! String) //String(priceHourAED["amount"] as! Float).FloatValue()
            cell.lblRate.text = "AED" + String(priceHourAED["amount"] as! Double) //"AED " + (priceHourAED["formatted"] as! String)//String(priceHourAED["amount"] as! Double).FloatValue()
//            cell.lblPerMeterRate.text = "AED" + String(priceMeterAED["amount"] as! Int).FloatValue()
//            cell.lblPerMeterTopRate.text = "AED" + String(priceMeterAED["amount"] as! Int).FloatValue()
        }
        else
        {
            cell.lblRateTop.text = "OMR " + String(priceHourOMR["amount"] as! Double)// + String(priceHourOMR["amount"] as! Int).FloatValue()
            cell.lblRate.text = "OMR " + String(priceHourOMR["amount"] as! Double)//String(priceHourOMR["amount"] as! Int).FloatValue()
//            cell.lblPerMeterRate.text = "OMR" + String(priceMeterOMR["amount"] as! Int).FloatValue()
//            cell.lblPerMeterTopRate.text = "OMR" + String(priceMeterOMR["amount"] as! Int).FloatValue()
        }
        

        cell.imgviewMain.sd_setImage(with: URL.init(string: self.companyArray[indexPath.row]["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
        
        cell.imgviewMainTop.sd_setImage(with: URL.init(string: self.companyArray[indexPath.row]["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
        
        if let averageRatting = self.companyArray[indexPath.row]["average_rating"] as? Double {
            
            
            
            cell.lblRating.text = String(format: "%.1f", averageRatting) //String((self.companyArray[indexPath.row]["average_rating"] as! Double))
            cell.lblRatingTop.text = cell.lblRating.text
            
            if averageRatting < 1 {
                cell.imgviewStar.image = #imageLiteral(resourceName: "starts")
                cell.imgviewStarTop.image = #imageLiteral(resourceName: "starts")
                
            }else if averageRatting < 2 {
                cell.imgviewStar.image = #imageLiteral(resourceName: "starts1")
                cell.imgviewStarTop.image = #imageLiteral(resourceName: "starts1")
                
            }else if averageRatting < 3 {
                cell.imgviewStar.image = #imageLiteral(resourceName: "starts2")
                cell.imgviewStarTop.image = #imageLiteral(resourceName: "starts2")
                
            }else if averageRatting < 4 {
                cell.imgviewStar.image = #imageLiteral(resourceName: "starts3")
                cell.imgviewStarTop.image = #imageLiteral(resourceName: "starts3")
                
            }else if averageRatting < 5 {
                cell.imgviewStar.image = #imageLiteral(resourceName: "starts4")
                cell.imgviewStarTop.image = #imageLiteral(resourceName: "starts4")
                
            }else {
                cell.imgviewStar.image = #imageLiteral(resourceName: "starts5")
                cell.imgviewStarTop.image = #imageLiteral(resourceName: "starts5")
                
            }
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
        
        cell.lblWorkHour.text = "Work Hour: ".localized + self.getTime(milisecond:self.companyArray[indexPath.row]["time_starts"] as! Int) + "-" +  self.getTime(milisecond:self.companyArray[indexPath.row]["time_ends"] as! Int)
        
        cell.lblWorkHourTop.text = cell.lblWorkHour.text
        cell.contentView.dropShadow()
        return cell
    }
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        _ = cellHeights[indexPath.row] == kCloseCellHeight
            return cellHeights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == kCloseCellHeight
        
        
//        if cellIsCollapsed {
//            if anyCellIsOpen {
//                return
//
//            }
//        }
        
        
        if cellIsCollapsed {
            
            if self.ind >= 0 {
            cellHeights[self.ind] = kCloseCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.2
            self.TBL_Componies.reloadData()
        }
            self.ind = indexPath.row
            cellHeights[indexPath.row] = kCloseCellHeight
            cellHeights[indexPath.row] = OpencellHeights[indexPath.row]
            cell.unfold(true, animated: true, completion: nil)
            
            duration = 0.1
        } else {
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.2
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            
            tableView.beginUpdates()
    
            tableView.endUpdates()
          
            self.anyCellIsOpen = !self.anyCellIsOpen
        }, completion: nil)
    }
    
    
    func APICallforCompany(){
        
//        var newParam = [String : AnyObject]()
        enableButton(value: false)
        appi_call = "companies"
        let url = "companies?page=\(nextPage)"
        print(url)
       // self.companyArray.removeAll()
        self.showLoading()
        NetworkManager.get(url , isLoading: (nextPage == 1), onView: self) { (Mainresponse) in
           self.hideLoading()
            print("All Companies Response :\(String(describing: Mainresponse))")
            
            if (Mainresponse?["status_code"] as! Int)  == 200 {
               
                let pageDictionary = Mainresponse?["pagination"] as? [String : Any]
                
                self.pageInfo = PageInfo.parsePageInfo(pageDictionary)
                
                if self.pageInfo?.current_page == 1 {
                    
                   // self.companyArray = Mainresponse?["data"] as! [[String : Any]]
                    
                            self.storedCompanyArray = Mainresponse?["data"] as! [[String : Any]]
                    self.companyArray = self.storedCompanyArray
                    
                }else{
                    //self.companyArray += Mainresponse?["data"] as! [[String : Any]]
                    self.storedCompanyArray += Mainresponse?["data"] as! [[String : Any]]
                     self.companyArray = self.storedCompanyArray
                }
                
//                if let pageInfo = self.pageInfo{
//                    if pageInfo.current_page == 1 {
//                        self.storedCompanyArray = Mainresponse?["data"] as! [[String : Any]]
//                    }
//                    else{
//                        self.storedCompanyArray += Mainresponse?["data"] as! [[String : Any]]
//                    }
//                    self.companyArray = self.storedCompanyArray
//                }
//                else{
//                   self.storedCompanyArray = Mainresponse?["data"] as! [[String : Any]]
 //                   self.companyArray = self.storedCompanyArray
//                }
                self.ReloadDataOfCompanies()
            } else {
                self.hideLoading()
                self.ShowErrorAlert(message: (Mainresponse?["message"] as! String))
            }
            
            for indexObj in self.companyArray {
                var translation = indexObj["translation"] as! [String : Any]
                let aboutMain = translation["about"] as? String
                self.cellHeights.append(140)
                self.OpencellHeights.append(self.estimatedHeightOfLabel(text: aboutMain!) + 200)
            }
            
            self.enableButton()
            self.TBL_Componies.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func GetAllServices(){
        
        self.arrayService.removeAll()
        self.showLoading()
        NetworkManager.get("services", isLoading: true, onView: self) { (mainResponse) in
            self.hideLoading()
            print(mainResponse ?? "")
            if (mainResponse?["status_code"] as! Int)  == 200 {

                self.storeArrayService = mainResponse?["data"] as! [[String : Any]]
                self.arrayService = self.storeArrayService
                
                
                
            }else {
                self.hideLoading()
                self.ShowErrorAlert(message: (mainResponse?["message"] as! String))
            }
            
            self.Services_Collection_view.reloadData()
        }
    }
    

}

extension SearchVC : UIScrollViewDelegate{
    
    func ReloadDataOfCompanies(){
        
        if(self.companyArray.count == 0){
            self.TBL_Componies.NoDataAvailable(text: "No Company Available".localized)
        }else{
            self.TBL_Componies.RemoNoDataLbl()
        }
        
    }
}
