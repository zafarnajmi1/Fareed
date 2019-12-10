//
//  CompanyPofileVC.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 4/5/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class CompanyPofileVC: BaseViewController, UICollectionViewDataSource, GMSAutocompleteFetcherDelegate, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        print("Auto Completd")
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        print("Did Failed")
    }
    

    @IBOutlet weak var imgViewBack: UIImageView!
    var selectedServices  = [[String : AnyObject]]()
    
    var companyInfo  = [String : AnyObject]()
    
    @IBOutlet weak var imgViewMain: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblRegNumber: UILabel!
     @IBOutlet weak var lblOrigin: UILabel!
    @IBOutlet weak var lblWebsite: UILabel!
    
    
    
    @IBOutlet weak var lblName1: UILabel!
    @IBOutlet weak var lblEmail1: UILabel!
    @IBOutlet weak var lblRegNumber1: UILabel!
    @IBOutlet weak var lblOrigin1: UILabel!
    @IBOutlet weak var lblWebsite1: UILabel!
    @IBOutlet weak var lbllogout: UIButton!

    @IBOutlet var lbl_SpecialInfoHeading : UILabel!

    @IBOutlet weak var lblservices: UILabel!

    @IBOutlet weak var uv_MapView: GMSMapView!
    var locationManager = CLLocationManager()
    var gmsFetcher: GMSAutocompleteFetcher!
    
    var company_Latitude = 0.0
    var company_Longitude = 0.0
    var companyName = ""
    
    @IBOutlet weak var collection_view_hight: NSLayoutConstraint!
    @IBOutlet weak var Colleciton_view: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
        }
        
        self.lblName1.text = "Company Name:".localized
        self.lbllogout.setTitle("LOGOUT".localized, for: .normal)
        self.lblWebsite1.text = "Website:".localized
        self.lblRegNumber1.text = "Registration Number:".localized
        self.lblOrigin1.text = "Origin:".localized
        
        self.lblEmail1.text = "Email:".localized
        self.lblservices.text = "Services:".localized
        self.lbl_SpecialInfoHeading.text = "Company".localized
        
        self.lblWebsite.text = "No Website".localized
        self.lblRegNumber.text = "No Registration Number".localized
        self.lblOrigin.text = "No Origin".localized
        
        
         self.Colleciton_view.register(UINib.init(nibName: "ServicesCell", bundle: nil), forCellWithReuseIdentifier: "ServicesCell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width:self.Colleciton_view.frame.width, height: self.Colleciton_view.frame.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        self.Colleciton_view!.collectionViewLayout = layout
        
        
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestAlwaysAuthorization()
//        locationManager.startUpdatingLocation()
        
        self.uv_MapView.settings.compassButton = true
        self.uv_MapView.isMyLocationEnabled = true
        self.uv_MapView.settings.myLocationButton = true

        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
        
        if CLLocationManager.locationServicesEnabled(){
            switch (CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            default: break
            }
        }else {
            print("Location services are not enabled")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.GetCompanInfo()
    }
    
    func GetCompanInfo(){
        self.showLoading()
        NetworkManager.get("company", isLoading: true, onView: self) { (mainResponse) in
            print(mainResponse)
            self.hideLoading()
            if(mainResponse?["message"] as! String == "User Company".localized)
            {
                self.companyInfo = (mainResponse?["data"] as? [String : AnyObject])!
                
                self.selectedServices = self.companyInfo["services"] as? [[String : AnyObject]] ?? []
                
                let companyData = self.companyInfo["languages"] as! [String : AnyObject]
                let companyNameData = companyData["en"] as! [String : AnyObject]
  
                
                self.imgViewMain.sd_setImage(with: URL.init(string: self.companyInfo["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
                self.lblName.text = companyNameData["title"] as? String
                self.companyName = companyNameData["title"] as? String ?? ""
                self.company_Latitude = self.companyInfo["latitude"] as? Double ?? 0.0
                self.company_Longitude = self.companyInfo["longitude"] as? Double ?? 0.0
                self.lblWebsite.text = "No Website".localized
                self.lblRegNumber.text = "No Registration Number".localized
                self.lblOrigin.text = "No Origin".localized
                
                
                 self.lblEmail.text = DataManager.sharedInstance.getPermanentlySavedUser()?.email
                
                if let urlMain = self.companyInfo["company_url"] as? String {
                        self.lblWebsite.text = urlMain
                }
                
                
                // func showCurrentLocation() {
                
                /************/
                self.uv_MapView.settings.myLocationButton = true
                let locationObj = self.locationManager.location
                let coord = locationObj?.coordinate
                let lattitude = coord?.latitude
                let longitude = coord?.longitude
                
                print(" lat in  updating \(String(describing: lattitude)) ")
                print(" long in  updating \(String(describing: longitude))")
                
                //let center = CLLocationCoordinate2D(latitude: locationObj?.coordinate.latitude ?? 0.0, longitude: locationObj?.coordinate.longitude ?? 0.0)
                let center = CLLocationCoordinate2D(latitude: self.company_Latitude, longitude: self.company_Longitude)
                let marker = GMSMarker()
                marker.position = center
                print("company Longitude = \(self.company_Longitude)")
                print("company Latitude = \(self.company_Latitude)")
                print("Company Name  = \(self.companyName)")
                marker.title = self.companyName
                marker.map = self.uv_MapView
                let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: self.company_Latitude, longitude: self.company_Longitude, zoom: Float(10.0))
                self.uv_MapView.animate(to: camera)
                self.uv_MapView.settings.scrollGestures = false
                /************/
                
                
                
                
//                self.uv_MapView.settings.myLocationButton = true
//                let locationObj = self.locationManager.location
//                let coord = locationObj?.coordinate
//                let lattitude = coord?.latitude
//                let longitude = coord?.longitude
//
//                print(" lat in  updating \(String(describing: lattitude)) ")
//                print(" long in  updating \(String(describing: longitude))")
//
//                //let center = CLLocationCoordinate2D(latitude: locationObj?.coordinate.latitude ?? 0.0, longitude: locationObj?.coordinate.longitude ?? 0.0)
//               let center = CLLocationCoordinate2D(latitude: locationObj?.coordinate.latitude ?? 0.0 , longitude: locationObj?.coordinate.longitude ?? 0.0)
//                let marker = GMSMarker()
//                marker.position = center
//
//                marker.title = self.companyName
//                marker.map = self.uv_MapView
//                let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: locationObj?.coordinate.latitude ?? 0.0, longitude: locationObj?.coordinate.latitude ?? 0.0, zoom: Float(10.0))
//                self.uv_MapView.animate(to: camera)
//
//                self.uv_MapView.settings.scrollGestures = false
                
                // }

            }
            else{
                self.hideLoading()
                self.ShowErrorAlert(message:  mainResponse?["message"] as! String)
            }
            
            self.Colleciton_view.reloadData()
        }
    }
    
    @IBAction func Back_Action(){
        
//        for controller in self.navigationController!.viewControllers as Array {
//            if controller.isKind(of: HomeVC.self) {
//                self.navigationController!.popToViewController(controller, animated: false)
//                break
//            }
//        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Logout_Action(sender : UIButton){
        self.showLoading()
        NetworkManager.get(WebServiceName.Logout.rawValue, isLoading: true, onView: self, hnadler: { (response) in
            print(response)
            self.hideLoading()
            DataManager.sharedInstance.logoutUser()
////            self.PushViewWithIdentifierAndStoryboard(view_name: "LoginVC", storyboard_name: "Main")
//            self.Back()
            let homeVC = self.GetView(nameViewController: "HomeVC", nameStoryBoard: "Main") as! HomeVC
            self.navigationController?.setViewControllers([homeVC], animated: true)
//            self.PushViewWithIdentifier(name: "HomeVC")
        })
    }
    
    
    @IBAction func EditAction(){
        let companyInfo = self.GetView(nameViewController: "CompanyInfoViewController", nameStoryBoard: "Main") as! CompanyInfoViewController
        companyInfo.companyInfo = self.companyInfo
        self.navigationController?.pushViewController(companyInfo, animated: true)
    }
    
    //MARK : Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let item_count : Int  = self.selectedServices.count
        if item_count % 3 == 0 {
            self.collection_view_hight.constant = CGFloat( (item_count/3) * Int(self.Colleciton_view.bounds.size.width/3))
        }else{
            self.collection_view_hight.constant =
                CGFloat((item_count/3) * Int(self.Colleciton_view.bounds.size.width/3)) +  (self.Colleciton_view.bounds.size.width/3)
        }
        return item_count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (self.Colleciton_view.bounds.size.width/3) , height: (self.Colleciton_view.bounds.size.width/3))
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "ServicesCell", for: indexPath) as! ServicesCell
        let translation = self.selectedServices[indexPath.row]["translation"] as! [String : Any]
        
        cell.service_name.text = translation["title"] as? String
        
        cell.img.sd_setImage(with: URL.init(string: self.selectedServices[indexPath.row]["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)

        
         cell.check_box_img.isHidden = true  
        return cell
    }
    
}
