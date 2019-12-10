//
//  CompanyReviewVC.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 4/7/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit
//import Cosmos

class CompanyReviewVC: BaseViewController{
    
    @IBOutlet var lblCompany : UILabel!
    @IBOutlet var lblCleaner : UILabel!
    
    @IBOutlet weak var imgViewBack: UIImageView!
    @IBOutlet var viewCompany : UIView!
    @IBOutlet var viewCleaner : UIView!
    
    @IBOutlet weak var lbl_Reviewsheading: UILabel!
    @IBOutlet weak var lbl_Reviews: UILabel!
    
    @IBOutlet weak var lbl_Ratingheading: UILabel!
    @IBOutlet weak var lbl_Rating: UILabel!
    
    //
    //
    var isCompanyChoose  = true
    @IBOutlet weak var lbl_Heading: UILabel!

    var companyArray = [[String : Any]]()
    var cleanerArray = [[String : Any]]()
    
    @IBOutlet var tbleViewMain : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
        }
        self.lbl_Heading.text = "Reviews".localized
        self.lblCompany.text = "Company Reviews".localized
        self.lblCleaner.text = "Cleaners Reviews".localized
        
        lbl_Reviewsheading.text = "Total Reviews:".localized
        lbl_Ratingheading.text = "Rating".localized

        self.tbleViewMain.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
         self.APiCallForCompany()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func CleanerAction(sender : UIButton){
        isCompanyChoose = false
        viewCleaner.backgroundColor = UIColor(red: 0x00 / 0xFF, green: 0xa6 / 0xFF, blue: 0x51 / 0xFF, alpha: 0xFF / 0xFF)
        lblCleaner.textColor = viewCleaner.backgroundColor
        viewCompany.backgroundColor = UIColor.clear
        lblCompany.textColor = UIColor.black
        
        if cleanerArray.count == 0 {
            self.APiCallForCleaner()
        }
        else{
            lbl_Reviews.text = "\(cleanerArray.count)"
            tbleViewMain.reloadData()
        }
    }
    
    @IBAction func CompanyAction(sender : UIButton){
        isCompanyChoose = true
        viewCompany.backgroundColor = UIColor(red: 0x00 / 0xFF, green: 0xa6 / 0xFF, blue: 0x51 / 0xFF, alpha: 0xFF / 0xFF)
        lblCompany.textColor = viewCompany.backgroundColor
        viewCleaner.backgroundColor = UIColor.clear
        lblCleaner.textColor = UIColor.black
        
        if companyArray.count == 0 {
            self.APiCallForCompany()
        }
        else{
            lbl_Reviews.text = "\(companyArray.count)"
            tbleViewMain.reloadData()
        }
        
    }
    
    func APiCallForCompany(){
        
        self.companyArray.removeAll()
        self.showLoading()
        NetworkManager.get("company/reviews", isLoading: true, onView: self) { (MainResponse) in
            print(MainResponse)
            self.hideLoading()
            if (MainResponse?["status_code"] as! Int) == 200 {
                
                self.companyArray = (MainResponse?["data"] as? [[String : AnyObject]])!
                
                self.lbl_Reviews.text = "\(self.companyArray.count)"
                
            }else{
                self.hideLoading()
                self.ShowErrorAlert(message:  MainResponse?["message"] as! String)
            }
            
            self.tbleViewMain.reloadData()
        }
    }
    
    func APiCallForCleaner(){
        self.cleanerArray.removeAll()
        self.showLoading()
//        NetworkManager.get("user/reviews/add-employee-reviews", isLoading: true, onView: self) { (MainResponse) in
        NetworkManager.get("company/employee/reviews", isLoading: true, onView: self) { (MainResponse) in
            print(MainResponse)
            self.hideLoading()
            if (MainResponse?["status_code"] as! Int) == 200 {
                self.cleanerArray = (MainResponse?["data"] as? [[String : AnyObject]])!
                
            }else{
                self.hideLoading()
                self.ShowErrorAlert(message:  MainResponse?["message"] as! String)
            }
            self.lbl_Reviews.text = "\(self.cleanerArray.count)"
            self.tbleViewMain.reloadData()
        }
    }
    @IBAction func BackAction(sender : UIButton){
        self.Back()
    }
}

extension CompanyReviewVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isCompanyChoose{
            return self.companyArray.count
        }
        return self.cleanerArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        if isCompanyChoose {
            var data  = self.companyArray[indexPath.row]["user"] as? [String : Any]
            cell.IMG_userimg.sd_setImage(with: URL.init(string: (data!["image"] as? String)!), completed: nil)
            cell.LBL_Username.text = data!["full_name"] as? String
            cell.LBL_date.text =  (data!["updated_at"] as? String )?.ConvertTODate()
            cell.LBL_Review_detail.text =  self.companyArray[indexPath.row]["review_text"] as? String
            if let averageRatting = self.companyArray[indexPath.row]["rating"] as? Double {
                //            cell.lblRating.text = String(format: "%.2f", averageRatting)
                cell.LBL_Rating_Count.text =  String(format: "%.1f", averageRatting)
                cell.cv_rating.rating = averageRatting
                //                cell.cv.text =  String(format: "%.2f", averageRatting)
            }
        }else {
            var data  = self.cleanerArray[indexPath.row]["user"] as? [String : Any]
            cell.IMG_userimg.sd_setImage(with: URL.init(string: (data!["image"] as? String)!), completed: nil)
            cell.LBL_Username.text = data!["full_name"] as? String
            cell.LBL_date.text =  (data!["updated_at"] as? String )?.ConvertTODate()
            cell.LBL_Review_detail.text =  self.cleanerArray[indexPath.row]["review_text"] as? String
            if let averageRatting = self.cleanerArray[indexPath.row]["rating"] as? Double {
                //            cell.lblRating.text = String(format: "%.2f", averageRatting)
                cell.LBL_Rating_Count.text =  String(format: "%.1f", averageRatting)
                cell.cv_rating.rating = averageRatting
//                cell.cv.text =  String(format: "%.2f", averageRatting)
            }
            //        self.lblRating.text =  String(describing: self.dataCompany["average_rating"] as! Double)

        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}



