//
//  NewCompanyDetailViewController.swift
//  Cleaning & Servent
//
//  Created by waseem on 06/04/2018.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class NewCompanyDetailViewController: BaseViewController , UITableViewDataSource, UITableViewDelegate , UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var imgViewBack: UIImageView!
    var selectedServices = [Int]()
    var dataCompany = [String : Any]()
    var mainData = [String : Any]()
    var translation = [String : Any]()
    var arrayServices = [[String : Any]]()
    
    @IBOutlet var tbleViewMain : UITableView!
    
    @IBOutlet var lblHeading : UILabel!
    
    var arrayType = [[String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
        }
        self.tbleViewMain.register(UINib(nibName: "CompanyDetailHEadingCell", bundle: nil), forCellReuseIdentifier: "CompanyDetailHEadingCell")
        self.tbleViewMain.register(UINib(nibName: "TextWithHeadingCell", bundle: nil), forCellReuseIdentifier: "TextWithHeadingCell")
        self.tbleViewMain.register(UINib(nibName: "MainHeadingCell", bundle: nil), forCellReuseIdentifier: "MainHeadingCell")
        
        self.tbleViewMain.register(UINib(nibName: "ServicesTableCell", bundle: nil), forCellReuseIdentifier: "ServicesTableCell")



        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.translation = self.dataCompany["translation"] as! [String : Any]
        self.lblHeading.text = self.translation["title"] as? String
        
        self.APICAll()
    }
 
    func ReloadData(){
        self.arrayType.removeAll()
        
        self.arrayType.append(["value" : 0]) // Header
        self.arrayType.append(["value" : 1]) // About Us
        self.arrayType.append(["value" : 2]) // Service Cell
        self.tbleViewMain.reloadData()
    }
    
    
    
    func APICAll(){
        
        self.selectedServices.removeAll()
        
        var newParam = [String : AnyObject]()
        newParam["company_id"] = self.dataCompany["id"] as AnyObject
        self.showLoading()
        NetworkManager.getWithPArams("company/detail", isLoading: true, withParams: newParam, onView: self) { (mainResponse) in
            self.hideLoading()
            if (mainResponse?["status_code"] as! Int)  == 200 {
                self.mainData = mainResponse?["data"] as! [String : Any]
                self.arrayServices = self.mainData["services"] as! [[String : AnyObject]]
//                self.arrayReview = self.mainData["reviews"] as! [[String : AnyObject]]
                
//                self.lblURL.text = self.mainData["company_url"] as? String
                
//                self.review_count = self.arrayReview.count
            }else {
                self.hideLoading()
                self.ShowErrorAlert(message: (mainResponse?["message"] as! String))
            }
            
            self.ReloadData()
//            self.TBL_Review.reloadData()
//            self.Services_Collection_view.reloadData()
        }
        
//        self.lblName.text = self.translation["title"] as? String
//        self.lblAboutUS.text = self.translation["about"] as? String
//        //        self.lblAboutUS.text = "No About me"
//        self.lblRating.text =  String(describing: self.dataCompany["average_rating"] as! Double)
//        self.lblPhone.text = self.dataCompany["phone"] as? String
//
//
//
//
//        let newRate = self.dataCompany["rate_per_hour"] as? [String : AnyObject]
//
//        let rateDict = newRate!["usd"] as! [String : AnyObject]
//        self.lblRate.text = "$" + String(rateDict["amount"] as! Double)
//        self.lblserviceCount.text = "Company type:" + (self.dataCompany["company_type"] as! String)
//
//        self.lblWorkhour.text = "Work Hour: " + self.getTime(milisecond:self.dataCompany["time_starts"] as! Int) + "-" +  self.getTime(milisecond:self.dataCompany["time_ends"] as! Int)
//
//        self.imgViewMain.sd_setImage(with: URL.init(string: self.dataCompany["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
//
//
//        self.latMain = self.dataCompany["latitude"] as! Double
//        self.longMain = self.dataCompany["longitude"] as! Double
//
//        let location = CLLocation.init(latitude: latMain, longitude: longMain)
//
//        let center = CLLocationCoordinate2D(latitude: latMain, longitude: longMain)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = (location.coordinate)
//        annotation.title = self.lblName.text
//        annotation.subtitle = self.dataCompany["company_type"] as! String
//        self.Map.addAnnotation(annotation)
//        self.Map.setRegion(region, animated: true)
//
//
//
//        if Double(self.lblRating.text!)! < 1.0 {
//            self.imgViewRating.image = #imageLiteral(resourceName: "starts")
//        }else if Double(self.lblRating.text!)! < 2.0 {
//            self.imgViewRating.image = #imageLiteral(resourceName: "starts1")
//        }else if Double(self.lblRating.text!)! < 3.0 {
//            self.imgViewRating.image = #imageLiteral(resourceName: "starts2")
//        }else if Double(self.lblRating.text!)! < 4.0 {
//            self.imgViewRating.image = #imageLiteral(resourceName: "starts3")
//        }else if Double(self.lblRating.text!)! < 5.0 {
//            self.imgViewRating.image = #imageLiteral(resourceName: "starts4")
//        }else {
//            self.imgViewRating.image = #imageLiteral(resourceName: "starts5")
//        }
//
//
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 2 {
            let sericeCount = self.arrayServices.count/3
            
            return (CGFloat(sericeCount * Int(self.tbleViewMain.bounds.size.width/3)))
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayType.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let mainData = self.arrayType[indexPath.row]
        
        switch (mainData["value"] as! Int) {
        case 1:
            return self.AboutUsCell(tableView:tableView  ,cellForRowAt:indexPath)
        
        case 2:
            return self.ServicesCell(tableView:tableView  ,cellForRowAt:indexPath)
            
        default:
            return self.HeaderCell(tableView:tableView  ,cellForRowAt:indexPath)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (self.tbleViewMain.bounds.size.width/3) , height: (self.tbleViewMain.bounds.size.width/3))
    }
    
    
}



extension NewCompanyDetailViewController {
    func HeaderCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let headerCell  = tableView.dequeueReusableCell(withIdentifier: "CompanyDetailHEadingCell") as! CompanyDetailHEadingCell
        
        headerCell.lblName.text = self.translation["title"] as? String
        headerCell.lblRating.text =  String(describing: self.dataCompany["average_rating"] as! Double)
        headerCell.lblPhoneNumber.text = self.dataCompany["phone"] as? String
        let newRate = self.dataCompany["rate_per_hour"] as? [String : AnyObject]
        
        let rateDict = newRate!["usd"] as! [String : AnyObject]
        
        if UserDefaults.standard.value(forKey: "Currency") as? String == "2" {
            headerCell.lblRate.text = "AED" + String(rateDict["amount"] as! Double)
        }else {
            headerCell.lblRate.text = "OMR" + String(rateDict["amount"] as! Double)
        }
        
        headerCell.lblCompanyType.text = "Company type:" + (self.dataCompany["company_type"] as! String)
        
        headerCell.lblWorkhour.text = "Work Hour: ".localized + self.getTime(milisecond:self.dataCompany["time_starts"] as! Int) + "-" +  self.getTime(milisecond:self.dataCompany["time_ends"] as! Int)
        
        headerCell.imgViewMain.sd_setImage(with: URL.init(string: self.dataCompany["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
        
        
        headerCell.selectionStyle = .none
        return headerCell
    }
    
    
    func AboutUsCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aboutusCell  = tableView.dequeueReusableCell(withIdentifier: "TextWithHeadingCell") as! TextWithHeadingCell
        aboutusCell.lblHeading.text = "About Us"
        aboutusCell.lblText.text = self.translation["about"] as? String
        aboutusCell.selectionStyle = .none
        return aboutusCell
        
    }
    
    func MainTextHeadingCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let headingMainCell  = tableView.dequeueReusableCell(withIdentifier: "MainHeadingCell") as! MainHeadingCell
        
        headingMainCell.lblHeading.text = "About Us"
        headingMainCell.selectionStyle = .none
        return headingMainCell
        
    }
    
    
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? ServicesTableCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        
    }
    
    func ServicesCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let serVicesCell  = tableView.dequeueReusableCell(withIdentifier: "ServicesTableCell") as! ServicesTableCell

        
        serVicesCell.collectionView.register(UINib.init(nibName: "ServicesCell", bundle: nil), forCellWithReuseIdentifier: "ServicesCell")

        return serVicesCell
    }
    @IBAction func BAckAction(sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}


extension NewCompanyDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let item_count : Int  = self.arrayServices.count
        
      
        return item_count
    }
    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "ServicesCell", for: indexPath) as! ServicesCell
        
        let translation = self.arrayServices[indexPath.row]["translation"] as! [String : Any]
        
        cell.service_name.text = translation["title"] as? String
        cell.img.sd_setImage(with: URL.init(string: self.arrayServices[indexPath.row]["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
        
        
        print(self.arrayServices.count % 3)
        cell.bottomView.isHidden = false
        if indexPath.row >= (self.arrayServices.count - (self.arrayServices.count % 3) ) {
            cell.bottomView.isHidden = true
            
        }
        
        cell.rightView.isHidden = false
        if ((indexPath.row + 1)  % 3) == 0  {
            cell.rightView.isHidden = true
            
        }
        cell.check_box_img.image = UIImage.init(named: "uncheckselectedcheckbox")//#imageLiteral(resourceName: "check_box")
        
        if selectedServices.contains(indexPath.row) {
            cell.check_box_img.image = UIImage.init(named: "selectedcheckbox")//#imageLiteral(resourceName: "check_box_checked")
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ServicesCell
        
        
        if selectedServices.contains(indexPath.row) {
            if let index = selectedServices.index(of: indexPath.row) {
                selectedServices.remove(at: index)
            }
        }else {
            selectedServices.append(indexPath.row)
        }
        
        if(cell.check_box_img.image == UIImage.init(named: "uncheckselectedcheckbox"))
            {
            cell.check_box_img.image = UIImage.init(named: "selectedcheckbox")//#imageLiteral(resourceName: "check_box_checked")
        }else{
            cell.check_box_img.image = UIImage.init(named: "uncheckselectedcheckbox")//#imageLiteral(resourceName: "check_box")
        }
    }
    
    
   
}



class CompanyDetailHEadingCell : UITableViewCell {
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblCompanyType : UILabel!
    @IBOutlet var lblRate : UILabel!
    @IBOutlet var lblWorkhour : UILabel!
    @IBOutlet var lblRating : UILabel!
    @IBOutlet var lblPhoneNumber : UILabel!
    @IBOutlet var lblUrl : UILabel!
    
    @IBOutlet var imgViewMain : UIImageView!
    @IBOutlet var imgViewStar : UIImageView!
    
}

class TextWithHeadingCell : UITableViewCell {
    @IBOutlet var lblHeading : UILabel!
    @IBOutlet var lblText : UILabel!
}

class MainHeadingCell : UITableViewCell {
    @IBOutlet var lblHeading : UILabel!
}

class ServicesTableCell : UITableViewCell {
    @IBOutlet var collectionView : UICollectionView!
}


extension ServicesTableCell {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.setContentOffset(collectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        collectionView.reloadData()
    }
    
//    var collectionViewOffset: CGFloat {
//        set { collectionView.contentOffset.x = newValue }
//        get { return collectionView.contentOffset.x }
//    }
}

