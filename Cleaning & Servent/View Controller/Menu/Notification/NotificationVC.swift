//
//  NotificationVC.swift
//  Servent
//
//  Created by Jawad ali on 2/11/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class NotificationVC: BaseViewController , UITableViewDelegate , UITableViewDataSource{
     @IBOutlet weak var AccessDediendView: UIView!
    @IBOutlet weak var tabel_view: UITableView!
    
    @IBOutlet weak var imgViewBack: UIImageView!
    @IBOutlet weak var lblHEading: UILabel!
    var refreshControl = UIRefreshControl()
    
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
    
    var arrayMain = [[String :Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(pullToRefreshView), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized)
        tabel_view.refreshControl = refreshControl
        
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
        }
        
        self.lblHEading.text = "Notification".localized
        self.tabel_view.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
         if  (DataManager.sharedInstance.user?.userid) != nil {
             AccessDediendView.isHidden = true
        }
        
          self.GetAllNotifications()
    }
    @objc func pullToRefreshView(){
        pageInfo = nil
        GetAllNotifications()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func GetAllNotifications(){
//        self.arrayMain.removeAll()
        self.showLoading()
        NetworkManager.get("notifications/list-all", isLoading: true, onView: self) { [weak self] (mainData) in
            print(mainData)
            self!.hideLoading()
            if(mainData?["status_code"] as! Int  == 200){
                self?.arrayMain = mainData?["data"] as! [[String : Any]]
                
                let pageDictionary = mainData?["pagination"] as? [String : Any]
                
                self?.pageInfo = PageInfo.parsePageInfo(pageDictionary)
                
            }else{
                self!.hideLoading()
                self?.ShowErrorAlert(message: mainData?["message"] as! String )
            }
            self?.refreshControl.endRefreshing()
            self?.tabel_view.reloadData()
            self?.ReloadData()
            
        }
    }
    
    @IBAction func Back(_ sender: Any) {
        self.Back()
    }

    @IBAction func OnClickLogin(_ sender: Any) {
         self.PushView(nameViewController: "LoginVC", nameStoryBoard: "Main")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.arrayMain.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        
        print(self.arrayMain[indexPath.row])
        print(self.arrayMain[indexPath.row]["receiver"] as Any)
        let receiver = self.arrayMain[indexPath.row]["receiver"] as! [String : Any]
        
//        cell.lblDescription.text = self.arrayMain[indexPath.row]["description"] as? String
        let name = self.arrayMain[indexPath.row]["title"] as? String
        cell.lblDescription.text = self.arrayMain[indexPath.row]["description"] as? String
        cell.lblName.text = "\(name!)".localized
        print(cell.lblName.text)
        if  let date  =  self.arrayMain[indexPath.row]["created_at"] as? Double{
            cell.LBLTime.text = "\(date)".getDateWithFormate(formate: "hh:mm a dd MMM yyyy")
        }
       
        cell.imgViewMain.sd_setImage(with: URL.init(string: receiver["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)

        cell.imgViewMain.RoundView()
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let HistoryDetail = self.storyboard?.instantiateViewController(withIdentifier: "HistoryDetailsVC") as! HistoryDetailsVC
        HistoryDetail.mainData = ["id": Int(self.arrayMain[indexPath.row]["extra"] as! String)]
        
        self.navigationController?.pushViewController(HistoryDetail, animated: true)
        
    }
    func ReloadData(){
        if(self.arrayMain.count == 0){
            self.tabel_view.NoDataAvailable(text: "No Notification Present".localized)
        }else{
            self.tabel_view.RemoNoDataLbl()
        }
        
    }

}


extension UIView {
    func RoundView()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.borderColor = UIColor.clear.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    
    func GreenRoundView()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = self.frame.size.height/2
//        self.layer.cornerRadius = 0
        self.layer.borderColor = UIColor.init(red: (105/255), green: (175/255), blue: (74/255), alpha: 1.0).cgColor
//        self.clipsToBounds = true
//        self.layer.masksToBounds = true
    }
    
}

