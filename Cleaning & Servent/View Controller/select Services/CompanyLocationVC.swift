//
//  CompanyLocationVC.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 3/28/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces
import GoogleMaps

class CompanyLocationVC: BaseViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    @IBOutlet weak var Map: MKMapView!
    @IBOutlet weak var collection_view: UICollectionView!
    
    @IBOutlet weak var imgViewBack: UIImageView!
    @IBOutlet weak var txtFeildMain: UITextField!
    var selectedLocation : (latitude : String, longitued : String)?
    var latMain = 0.0
    var longMain = 0.0
    var serviceType = ""
    var servicesSelected = [[String : Any]]()
    var companyArray = [[String : Any]]()
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
        }
        
        self.txtFeildMain.delegate = self
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
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width:self.collection_view.frame.width, height: self.collection_view.frame.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        self.collection_view!.collectionViewLayout = layout
        self.collection_view.register(UINib.init(nibName: "CompaniesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "CompaniesCollectionCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                self.OpenPopup()
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                self.ContinueWithPermission()
            }
        } else {
            print("Location services are not enabled")
            self.ContinueWithPermission()
        }
        
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func APICallforCompany(){
        
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
        if let location = selectedLocation{
            urlMain = urlMain + "&lat=" + location.latitude + "&lng=" + location.longitued
        }
        
//        if self.latchoose.count > 0 {
//            urlMain = urlMain + "&lat=" + self.latchoose
//        }
//        if self.longchoose.count > 0 {
//            urlMain = urlMain + "&lng=" + self.longchoose
//        }
        
        print(urlMain)
        self.companyArray.removeAll()
        self.showLoading()
        NetworkManager.get("companies?services=[" + urlMain , isLoading: true, onView: self) { (Mainresponse) in
            print(Mainresponse)
            self.hideLoading()
            if (Mainresponse?["status_code"] as! Int)  == 200 {
                self.companyArray = Mainresponse?["data"] as! [[String : Any]]
                
                if self.companyArray.count == 0 {
                    self.collection_view.isHidden = true
                    
                    let alert = UIAlertController(title: "Alert".localized , message: "No Companies for this search".localized, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: kOKBtnTitle, style: .default) { action in
//                        alert.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                    })
                    self.present(alert, animated: true, completion: nil)
                    
                    
//                    self.ShowErrorAlert(message: )
                    
                }
                else{
                    self.collection_view.isHidden = false
                    self.collection_view.reloadData()
                }
                
            }else {
                self.hideLoading()
                self.ShowErrorAlert(message: (Mainresponse?["message"] as! String))
            }
            
//            for indexObj in self.companyArray
//            {
////                var translation = indexObj["translation"] as! [String : Any]
////                var aboutMain = translation["about"] as? String
////                self.cellHeights.append(120)
////                self.OpencellHeights.append(self.estimatedHeightOfLabel(text: aboutMain!) + 200)
//            }
//
//            self.TBL_Componies.reloadData()
        }
    }

    
    func ContinueWithPermission(){
        self.txtFeildMain.text = "Search...".localized
        let annotation = MKPointAnnotation()
        let location = CLLocation.init(latitude: latMain, longitude: longMain)
        
        let center = CLLocationCoordinate2D(latitude: latMain, longitude: longMain)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        annotation.coordinate = (location.coordinate)
        annotation.title = "Cleaning & Servent"
        annotation.subtitle = "current location"
        self.Map.addAnnotation(annotation)
        self.Map.setRegion(region, animated: true)
        
    }
    
    func OpenPopup(){
        
        let controller = UIAlertController(title: "", message: "Turn On Location Services to Allow \"Maps\" to Determine Your Location", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment:"" ), style: .cancel, handler: { action in
            self.navigationController?.popViewController(animated: true)
        })
        let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment:"" ), style: .default, handler: { action in
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
            self.navigationController?.popViewController(animated: true)
        })
        controller.addAction(cancelAction)
        controller.addAction(settingsAction)
        
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func OnClickBack(_ sender: Any) {
        self.Back()
        self.Dismiss()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            latMain = (location?.coordinate.latitude)!
            longMain = (location?.coordinate.longitude)!
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = (location?.coordinate)!
            annotation.title = "Cleaning & Maintenence"
            annotation.subtitle = "current location"
            self.Map.addAnnotation(annotation)
            self.Map.setRegion(region, animated: true)

    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        switch newState {
        case .ending, .canceling:
            break
            
        default: break
        }
    }
}
extension CompanyLocationVC : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let placePickerController = GMSAutocompleteViewController()
        placePickerController.delegate = self as GMSAutocompleteViewControllerDelegate
        self.present(placePickerController, animated: true) {
        }
        return false
    }
}
extension CompanyLocationVC : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
  
    func addAnotaion(lat : Double , lng : Double , title : String) {
        
        print("lat =\(lat) , lng =\(lng) , title = \(title)")
        for ann in self.Map.annotations{
            self.Map.removeAnnotation(ann)
        }
        let annotation = MKPointAnnotation()
        let location = CLLocation.init(latitude: lat, longitude: lng)
        
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        annotation.coordinate = (location.coordinate)
        annotation.title = title
        self.Map.addAnnotation(annotation)
        self.Map.setRegion(region, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.companyArray.count)
        return self.companyArray.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize.init(width: (self.collection_view.bounds.size.width) , height: (self.collection_view.bounds.size.height))
        
        return CGSize.init(width: (self.collection_view.bounds.size.width) , height: 150)

    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "CompaniesCollectionCell", for: indexPath) as! CompaniesCollectionCell
        cell.imgviewMain.sd_setImage(with: URL.init(string: self.companyArray[indexPath.row]["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
        cell.lblRating.text = String((self.companyArray[indexPath.row]["average_rating"] as! Double)).FloatValueTwo()
        
        if (self.companyArray[indexPath.row]["average_rating"] as! Double) < 1 {
        
            
            if (self.companyArray[indexPath.row]["average_rating"] as! Double) > 0.5 {
                
                cell.imgviewStar.image = #imageLiteral(resourceName: "starts1Half")
            }else {
                cell.imgviewStar.image = #imageLiteral(resourceName: "starts")
            }
            
            
        }else if (self.companyArray[indexPath.row]["average_rating"] as! Double) < 1.5 {
            cell.imgviewStar.image  = #imageLiteral(resourceName: "starts1")
            
        }else if (self.companyArray[indexPath.row]["average_rating"] as! Double) < 2 {
            cell.imgviewStar.image = #imageLiteral(resourceName: "starts1Half")
            
            
        }else if (self.companyArray[indexPath.row]["average_rating"] as! Double) < 2.5 {
            
            cell.imgviewStar.image = #imageLiteral(resourceName: "starts2")
            
        }else if (self.companyArray[indexPath.row]["average_rating"] as! Double) < 3 {
            cell.imgviewStar.image = #imageLiteral(resourceName: "starts2Half")
            
        }else if (self.companyArray[indexPath.row]["average_rating"] as! Double) < 3.5 {
            
            cell.imgviewStar.image  = #imageLiteral(resourceName: "starts3")
            
        }else if (self.companyArray[indexPath.row]["average_rating"] as! Double) < 4 {
            
            cell.imgviewStar.image  = #imageLiteral(resourceName: "starts3Half")
            
            
        }else if (self.companyArray[indexPath.row]["average_rating"] as! Double) < 4.5 {
            
            cell.imgviewStar.image = #imageLiteral(resourceName: "starts4")
            
        }else if (self.companyArray[indexPath.row]["average_rating"] as! Double) < 5 {
            
            cell.imgviewStar.image = #imageLiteral(resourceName: "starts4Half")
            
        }else {
            
            cell.imgviewStar.image = #imageLiteral(resourceName: "starts5")
            
        }
        
        
//        if (self.companyArray[indexPath.row]["average_rating"] as! Double) < 1 {
//            cell.imgviewStar.image = #imageLiteral(resourceName: "starts")
//        }else if (self.companyArray[indexPath.row]["average_rating"] as! Double) < 2 {
//            cell.imgviewStar.image = #imageLiteral(resourceName: "starts1")
//        }else if (self.companyArray[indexPath.row]["average_rating"] as! Double) < 3 {
//            cell.imgviewStar.image = #imageLiteral(resourceName: "starts2")
//        }else if (self.companyArray[indexPath.row]["average_rating"] as! Double) < 4 {
//            cell.imgviewStar.image = #imageLiteral(resourceName: "starts3")
//        }else if (self.companyArray[indexPath.row]["average_rating"] as! Double) < 5 {
//            cell.imgviewStar.image = #imageLiteral(resourceName: "starts4")
//        }else {
//            cell.imgviewStar.image = #imageLiteral(resourceName: "starts5")
//        }
        
        var currency : String {
            get {
                return DataManager.sharedInstance.getSelectedCurrency()
            }
        }
        var translation = self.companyArray[indexPath.row]["translation"] as! [String : Any]
        let ratePrice = self.companyArray[indexPath.row]["rate_per_hour"] as! [String : Any]
        
        let priceMAin = ratePrice["usd"] as! [String : Any]
        let priceHourOMR = ratePrice["usd"] as! [String : Any]
        let priceHourAED = ratePrice["aed"] as! [String : Any]
        
        cell.lblName.text = translation["title"] as? String
        
        
        
        if currency == "2" {
            cell.lblRate.text = "AED" + String(priceHourAED["amount"] as! Double)
        }else {
            cell.lblRate.text = "OMR" + String(priceHourOMR["amount"] as! Double)
        }
        cell.lblServicecount.text = translation["about"] as? String
        cell.lblServicecount.text = "We Provide ".localized +  String(self.companyArray[indexPath.row]["services_count"] as! Int) + " Services".localized
        cell.lblWorkHour.text = "Work Hour: ".localized + self.getTime(milisecond:self.companyArray[indexPath.row]["time_starts"] as! Int) + "-" +  self.getTime(milisecond:self.companyArray[indexPath.row]["time_ends"] as! Int)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        var data = self.companyArray[indexPath.row]
        var translation = self.companyArray[indexPath.row]["translation"] as! [String : Any]
        self.addAnotaion(lat: data["latitude"] as! Double, lng: data["longitude"] as! Double, title: translation["title"] as! String)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.PushCompanyDetail(name: "ComponyDetailVC", dataMain: self.companyArray[indexPath.row])
    }
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        let placePickerController = GMSAutocompleteViewController()
//        placePickerController.delegate = self as GMSAutocompleteViewControllerDelegate
//        self.present(placePickerController, animated: true) {
//        }
//        return false
//    }
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        let placePickerController = GMSAutocompleteViewController()
//        placePickerController.delegate = self as GMSAutocompleteViewControllerDelegate
//        self.present(placePickerController, animated: true) {
//        }
//    }
}
extension CompanyLocationVC :  GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        print("Place name: \(place.name)")
//        print("Place address: \(String(describing: place.formattedAddress))")
//        print("Place attributions: \(String(describing: place.attributions))")
//        print("Place coordinate: \(place.coordinate)")
        dismiss(animated: true, completion: nil)
        self.txtFeildMain.text = place.formattedAddress
        
//        let center = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        let region = MKCoordinateRegion(center: place.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
//        MKCoordinateRegion()
        let annotation = MKPointAnnotation()
//        let location = CLLocation.init(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        annotation.coordinate = place.coordinate//(location.coordinate)
        annotation.title = "Cleaning & Servent"
        annotation.subtitle = "current location"
        for annotation in self.Map.annotations{
            self.Map.removeAnnotation(annotation)
        }
        
        DispatchQueue.main.async {
            self.Map.addAnnotation(annotation)
            self.Map.setRegion(region, animated: true)
        }
        
        selectedLocation = ("\(place.coordinate.latitude)", "\(place.coordinate.longitude)")
//        self.Map.setCenter(place.coordinate, animated: true)
        APICallforCompany()
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

