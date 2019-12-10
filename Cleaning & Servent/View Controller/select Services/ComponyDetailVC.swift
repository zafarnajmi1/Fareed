//
//  ComponyDetailVC.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 3/28/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit
import MapKit

class ComponyDetailVC: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate,MKMapViewDelegate {
    
    @IBOutlet weak var imgViewBack: UIImageView!
    
    @IBOutlet var lbl_Heading: UILabel!
    @IBOutlet var lbl_Company: UILabel!
    @IBOutlet var lbl_URLHeading: UILabel!
    @IBOutlet var lbl_PhoneHeading: UILabel!
    @IBOutlet var lbl_AboutUSHeading: UILabel!
    @IBOutlet var lbl_Services: UILabel!
    @IBOutlet var lbl_Address: UILabel!
    @IBOutlet var lbl_Review: UILabel!
    @IBOutlet var btnBook: UIButton!
    @IBOutlet var lbl_perhour: UILabel!
    
    var latMain = 0.0
    var longMain = 0.0
    var isSetTableViewHeight : Bool = false
    var label_height : Int = 0
    var review_count : Int  = 0
    @IBOutlet weak var TBL_Reviews_hight: NSLayoutConstraint!
    @IBOutlet weak var TBL_Review: UITableView!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblserviceCount : UILabel!
    @IBOutlet var lblRate : UILabel!
    @IBOutlet var lblWorkhour : UILabel!
    @IBOutlet var lblRating : UILabel!
    @IBOutlet var lblPhone : UILabel!
    @IBOutlet var lblURL : UILabel!
    @IBOutlet var lblAboutUS : UILabel!
    
    var selectedServices = [Int]()
    
    @IBOutlet var imgViewMain : UIImageView!
    @IBOutlet var imgViewRating : UIImageView!
    
    var arrayServices = [[String : Any]]()
    var arrayReview = [[String : Any]]()
    var dataCompany = [String : Any]()
    var mainData = [String : Any]()
    var translation = [String : Any]()
    
    @IBOutlet weak var Constraint_services_collection_view_height: NSLayoutConstraint!
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var Map: MKMapView!
    @IBOutlet weak var Services_Collection_view: UICollectionView!
    
    
    var currency : String {
        get {
            return DataManager.sharedInstance.getSelectedCurrency()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
        }
        
        self.btnBook.setTitle("BOOK NOW".localized, for: .normal)
        self.lbl_Heading.text = "Company Detail".localized
        self.lbl_Company.text = "Step 2: Select Company".localized
        self.lbl_Services.text = "Services".localized
        self.lbl_Review.text = "Reviews".localized
        self.lbl_Address.text = "Address".localized
        self.lbl_URLHeading.text = "Company URL".localized
        self.lbl_PhoneHeading.text = "Phone Number".localized
        self.lbl_AboutUSHeading.text = "About Us".localized
        self.lbl_perhour.text = "Per Hour".localized
        
        self.TBL_Review.register(UINib.init(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
        self.TBL_Review.register(UINib.init(nibName: "NoREviewCell", bundle: nil), forCellReuseIdentifier: "NoREviewCell")
        
        
        
        self.Services_Collection_view.register(UINib.init(nibName: "ServicesCell", bundle: nil), forCellWithReuseIdentifier: "ServicesCell")

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width:self.Services_Collection_view.frame.width/3, height: self.Services_Collection_view.frame.width/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        self.Services_Collection_view!.collectionViewLayout = layout
        
        
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        self.Map.delegate = self
        self.Map.mapType = .standard
        self.Map.isZoomEnabled = true
        self.Map.isScrollEnabled = true
        
        if let coor = self.Map.userLocation.location?.coordinate{
            self.Map.setCenter(coor, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.translation = self.dataCompany["translation"] as! [String : Any]
        
        
        
        
        
        if self.selectedServices.count > 0 {
            
            if DataManager.sharedInstance.user != nil {
                if DataManager.sharedInstance.user!.userid.count > 0  {
                        self.GoNextView()
                }
            }
        }else {
            self.APICAll()
        }
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
                self.arrayReview = self.mainData["reviews"] as! [[String : AnyObject]]
                
                let companyURL = self.mainData["company_url"] as? String
                
                if companyURL == nil || companyURL == "" {
                    
                    self.lblURL.text = "No URL".localized
                }else{
                    
                     self.lblURL.text = self.mainData["company_url"] as? String
                }
               
                
                self.review_count = self.arrayReview.count
            }else {
                self.hideLoading()
                self.ShowErrorAlert(message: (mainResponse?["message"] as! String))
            }
            
            
            self.TBL_Review.reloadData()
            self.Services_Collection_view.reloadData()
        }
        
        self.lblName.text = self.translation["title"] as? String
        self.lblAboutUS.text = self.translation["about"] as? String
        //        self.lblAboutUS.text = "No About me"
        if let averageRatting = self.dataCompany["average_rating"] as? Double {
//            cell.lblRating.text = String(format: "%.2f", averageRatting)
            self.lblRating.text =  String(format: "%.1f", averageRatting)
        }
//        self.lblRating.text =  String(describing: self.dataCompany["average_rating"] as! Double)
        self.lblPhone.text = self.dataCompany["phone"] as? String
        
        
        
        
        let newRate = self.dataCompany["rate_per_hour"] as? [String : AnyObject]
        print(newRate!["aed"]!)
        
        let rateDict = newRate!["usd"] as! [String : AnyObject]
        let priceHourOMR = newRate?["usd"]
        let priceHourAED = newRate?["aed"]
        
        
        //UserDefaults.standard.value(forKey: "Currency") as? String ==
        //(priceHourAED["formatted"] as! String)
        if  currency == "2" {
            self.lblRate.text = "AED" + String(priceHourAED!["amount"] as! Double)
        }else {
            self.lblRate.text = "OMR"  + String(priceHourOMR!["amount"] as! Double)
        }
        self.lblserviceCount.text = "Company type:".localized + " : " +  (self.dataCompany["company_type"] as! String).localized
        
        self.lblWorkhour.text = "Work Hour: ".localized + self.getTime(milisecond:self.dataCompany["time_starts"] as! Int) + "-" +  self.getTime(milisecond:self.dataCompany["time_ends"] as! Int)
        
        self.imgViewMain.sd_setImage(with: URL.init(string: self.dataCompany["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
        
        
        self.latMain = self.dataCompany["latitude"] as! Double
        self.longMain = self.dataCompany["longitude"] as! Double
        
        let location = CLLocation.init(latitude: latMain, longitude: longMain)
        
        let center = CLLocationCoordinate2D(latitude: latMain, longitude: longMain)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        let annotation = MKPointAnnotation()
        annotation.coordinate = (location.coordinate)
        annotation.title = self.lblName.text
        annotation.subtitle = self.dataCompany["company_type"] as! String
        self.Map.addAnnotation(annotation)
        self.Map.setRegion(region, animated: true)
        
        
        
        if Double(self.lblRating.text!)! < 1.0 {
            self.imgViewRating.image = #imageLiteral(resourceName: "starts")
        }else if Double(self.lblRating.text!)! < 2.0 {
            self.imgViewRating.image = #imageLiteral(resourceName: "starts1")
        }else if Double(self.lblRating.text!)! < 3.0 {
            self.imgViewRating.image = #imageLiteral(resourceName: "starts2")
        }else if Double(self.lblRating.text!)! < 4.0 {
            self.imgViewRating.image = #imageLiteral(resourceName: "starts3")
        }else if Double(self.lblRating.text!)! < 5.0 {
            self.imgViewRating.image = #imageLiteral(resourceName: "starts4")
        }else {
            self.imgViewRating.image = #imageLiteral(resourceName: "starts5")
        }
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnClickBack(_ sender: Any) {
        self.Back()
        self.Dismiss()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations.last
//        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        latMain = (location?.coordinate.latitude)!
//        longMain = (location?.coordinate.longitude)!
//
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = (location?.coordinate)!
//        annotation.title = "Cleaning & Maintenence"
//        annotation.subtitle = "current location"
//        self.Map.addAnnotation(annotation)
//        self.Map.setRegion(region, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        switch newState {
        case .starting:
            view.dragState = .dragging
        case .ending, .canceling:
            view.dragState = .none
        default: break
        }
    }
    
    @IBAction func OnClickBookNow(_ sender: Any) {
        
        print(self.selectedServices.count)
        if self.selectedServices.count > 0 {
            
            print(DataManager.sharedInstance.user?.userid)
            
            
            
            if DataManager.sharedInstance.user?.userid.count == 0  || DataManager.sharedInstance.user?.userid == nil {
                
                let alert = UIAlertController(title: "" , message: "Please login to continue.".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel".localized, style: .default) { action in
                    alert.dismiss(animated: true, completion: nil)
                    
                })
                
                alert.addAction(UIAlertAction(title: "Login".localized, style: .default) { action in
                    alert.dismiss(animated: true, completion: nil)
                    
                    let loginVc = self.GetView(nameViewController: "LoginVC", nameStoryBoard: "Main") as! LoginVC
                    loginVc.isBookingPush = true
                    self.navigationController?.pushViewController(loginVc, animated: true)
                    
                })
                
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            
            self.GoNextView()
            
           
        }else {
            self.ShowErrorAlert(message: "Select Service".localized)
        }
    }
    
    func GoNextView(){
        let mainVC = self.GetView(nameViewController: "BookingMainVC", nameStoryBoard: "Booking") as! BookingMainVC
        
        mainVC.companyData = self.mainData
        
        
        var selectd = [[String : Any]]()
        
        
        
        for index in self.selectedServices {
            selectd.append(self.arrayServices[index])
        }
        
        var mainHour = [String]()
        var mainHourArray = [String]()
        
        let calendar = Calendar.current
        
        for index in 0...self.GetHours() {
            
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
        
        mainVC.count = showHour.count
        mainVC.tbleArray = showHour
        mainVC.tbleArrayMAin = showHour
        mainVC.servicesSelected = selectd
        mainVC.HoursArray = mainHourArray
        self.selectedServices.removeAll()
        self.navigationController?.pushViewController(mainVC, animated: true)
    }
    
    func GetHours()-> Int{
        
        let dateRangeEnd = self.getDateObject(milisecond:self.dataCompany["time_starts"] as! Int)
        
        
        let dateRangeStart = self.getDateObject(milisecond:self.dataCompany["time_ends"] as! Int)
        
        let components = Calendar.current.dateComponents([.hour ], from: dateRangeEnd, to: dateRangeStart)
        
        
        print(components.hour!)
        return components.hour!
    }
    
    //MARK : Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let item_count : Int  = self.arrayServices.count
        
        
        let sizeHeight : Int = (Int(self.Services_Collection_view.bounds.size.width/3))
        if item_count % 3 == 0 {
            self.Constraint_services_collection_view_height.constant = CGFloat( (item_count/3) * sizeHeight)
        }else{
             self.Constraint_services_collection_view_height.constant =
                CGFloat((item_count/3) * sizeHeight ) + CGFloat(sizeHeight)
        }
        return item_count
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
        cell.check_box_img.image = UIImage.init(named: "uncheckselectedcheckbox")// #imageLiteral(resourceName: "check_box")
        
        if selectedServices.contains(indexPath.row) { //uncheckselectedcheckbox
            cell.check_box_img.image = UIImage.init(named: "selectedcheckbox") //#imageLiteral(resourceName: "check_box_checked")
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.Services_Collection_view.cellForItem(at: indexPath) as! ServicesCell
        
        
        if selectedServices.contains(indexPath.row) {
            if let index = selectedServices.index(of: indexPath.row) {
                selectedServices.remove(at: index)
            }
        }else {
            selectedServices.append(indexPath.row)
        }
        
        if(cell.check_box_img.image == UIImage.init(named: "uncheckselectedcheckbox")// #imageLiteral(resourceName: "check_box")
            ){
            cell.check_box_img.image = UIImage.init(named: "selectedcheckbox")// #imageLiteral(resourceName: "check_box_checked")
        }else{
            cell.check_box_img.image = UIImage.init(named: "uncheckselectedcheckbox")// #imageLiteral(resourceName: "check_box")
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(textField.tag)
    }
    
}

extension ComponyDetailVC : UITableViewDataSource , UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.review_count > 0 {
            self.TBL_Reviews_hight.constant = CGFloat(self.review_count * 139)

            return self.review_count
        }else {
            self.TBL_Reviews_hight.constant = 50.0
            return 1
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.arrayReview.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoREviewCell", for: indexPath) as! NoREviewCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        let mainData = self.arrayReview[indexPath.row] as [String : Any]
        if let mainUser = mainData["user"] as? [String : Any]
        {
        
            cell.LBL_Username.text = mainUser["full_name"] as? String
        cell.IMG_userimg.sd_setImage(with: URL.init(string: mainUser["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
        }
        else{
            cell.LBL_Username.text = "Unknown".localized
            cell.IMG_userimg.image =  #imageLiteral(resourceName: "profile_placeholder")
        }

//        cell.LBL_Rating_Count.text = String(mainData["rating"] as! Double)
        cell.LBL_date.text = self.getDate(milisecond: mainData["updated_at"] as! Int)
        cell.LBL_Review_detail.text = mainData["review_text"] as! String
        
        if let ratting = mainData["rating"] as? Double {
            cell.cv_rating.rating = ratting
            cell.cv_rating.settings.updateOnTouch = false
//            cell.cv_rating.settings.updateOnTouch = false
            cell.LBL_Rating_Count.text = String(format: "%.1f", ratting)
        }
        
        
        
//        if mainData["rating"] !=  nil {
//            if (mainData["rating"] as! Double) < 1.0 {
//                cell.IMG_Starts.image = #imageLiteral(resourceName: "starts")
//            }else if (mainData["rating"] as! Double) < 2.0 {
//                cell.IMG_Starts.image = #imageLiteral(resourceName: "starts1")
//            }else if (mainData["rating"] as! Double) < 3.0 {
//                cell.IMG_Starts.image = #imageLiteral(resourceName: "starts2")
//            }else if (mainData["rating"] as! Double) < 4.0 {
//                cell.IMG_Starts.image = #imageLiteral(resourceName: "starts3")
//            }else if (mainData["rating"] as! Double) < 5.0 {
//                cell.IMG_Starts.image = #imageLiteral(resourceName: "starts4")
//            }else {
//                cell.IMG_Starts.image = #imageLiteral(resourceName: "starts5")
//            }
//        }
      
        
        
        
        
        cell.selectionStyle = .none
        label_height = label_height +   (((cell.LBL_Review_detail.text?.count)! % 80 ) * 20 )
        if indexPath.row == self.review_count-1 && !isSetTableViewHeight{
            isSetTableViewHeight = true
            self.TBL_Review.reloadData()
        }
        return cell
    }
    
    @IBAction func OpenPhone(sender : UIButton){
        self.DialNumber(PhoneNumber: self.lblPhone.text!)
    }
    
    @IBAction func OpenUrl(sender : UIButton){
        if self.lblURL.text == "No URL".localized {
            
        }else {
            self.OpenLink(webUrl: self.lblURL.text!)
        }
        
    }
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.review_count == 0 {
            return 50
        }
        return UITableView.automaticDimension
    }
}

class NoREviewCell : UITableViewCell {
    @IBOutlet weak var lbl_txt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lbl_txt.text = "No Reviews".localized
    }
    
}
