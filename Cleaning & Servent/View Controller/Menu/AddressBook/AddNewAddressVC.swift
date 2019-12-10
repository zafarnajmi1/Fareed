//
//  AddNewAddressVC.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 3/17/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces
import GoogleMaps
import  GooglePlacePicker
class AddNewAddressVC: BaseViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    @IBOutlet weak var Map: MKMapView!
    
    @IBOutlet weak var txtFeildMain: UITextField!
    @IBOutlet weak var btnAddaddress : UIButton!
    
    @IBOutlet weak var imgViewBack: UIImageView!
    @IBOutlet weak var lblHeading : UILabel!
    
    @IBOutlet weak var lblText : UILabel!
    
    var objmain = [String : AnyObject]()
    var latMain = -500.0
    var longMain = -500.0
    var latMain1 = -500.0
    var longMain1 = -500.0
    
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
        }
        
        self.lblText.text = "Address ".localized
        self.lblHeading.text = "Address Book".localized
        self.txtFeildMain.placeholder = "Enter Address".localized
        self.btnAddaddress.setTitle("ADD ADDRESS".localized, for: .normal)
        
        self.locationManager.requestWhenInUseAuthorization()
           CLLocationManager.locationServicesEnabled()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        
        self.txtFeildMain.delegate = self
        self.Map.delegate = self
        self.Map.mapType = .standard
        self.Map.isZoomEnabled = true
        self.Map.isScrollEnabled = true
        
        if let coor = self.Map.userLocation.location?.coordinate{
            self.Map.setCenter(coor, animated: true)
        }
        
        if objmain["id"] != nil {
            print(objmain)
            self.btnAddaddress.setTitle("Update Address".localized, for: .normal)
            self.txtFeildMain.text = (objmain["address"] as! String)
            latMain1 = objmain["latitude"] as! Double
            longMain1 = objmain["longitude"] as! Double
            
            print(objmain)
            let annotation = MKPointAnnotation()
            let location = CLLocation.init(latitude: latMain1, longitude: longMain1)
            
            let center = CLLocationCoordinate2D(latitude: latMain1, longitude: longMain1)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            annotation.coordinate = (location.coordinate)
            annotation.title = "Cleaning & Servent"
            annotation.subtitle = "current location"
            self.Map.addAnnotation(annotation)
            self.Map.setRegion(region, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func OnClickBack(_ sender: Any) {
        self.Back()
        self.Dismiss()
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
                
            }
        } else {
            print("Location services are not enabled")
            
        }
    }
    
    
    func OpenPopup(){
        
        let controller = UIAlertController(title: "", message: "Turn On Location Services to Allow \"Maps\" to Determine Your Location".localized, preferredStyle: .alert)
        
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
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        if objmain["id"] != nil {
 
        }else {
            
            if latMain ==  -500.0 && longMain == -500.0
            {
                latMain = (location?.coordinate.latitude)!
                longMain = (location?.coordinate.longitude)!
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = (location?.coordinate)!
                annotation.title = "Cleaning & Servent"
                annotation.subtitle = "current location"
                
                self.Map.addAnnotation(annotation)
                self.Map.setRegion(region, animated: true)
            }
            
            locationManager.stopUpdatingLocation()
            
        }
        

    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        
        print(newState.hashValue)
        let droppedAt = view.annotation?.coordinate
        print(droppedAt)
        
        switch newState {
        case  .canceling:
            break
            
        
        case .none:
            print("None")
            self.showLoading()
            let geo: CLGeocoder = CLGeocoder()
            let loc: CLLocation = CLLocation(latitude:(droppedAt?.latitude)!, longitude: (droppedAt?.longitude)!)
            geo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    self.hideLoading()
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]
                    
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! 
                        }
                        print(addressString)
                        self.latMain = (droppedAt?.latitude)!
                        self.longMain = (droppedAt?.longitude)!
                        self.txtFeildMain.text = addressString
                    }
            })
            
            
            break
        default: break
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.isDraggable = true
        }
        else {
            pinView?.annotation = annotation
        }
        
        pinView?.isDraggable = true
        return pinView
    }
    
    
    @IBAction func AddNewAddress(){
        if (self.txtFeildMain.text?.isEmpty)!{
            self.ShowErrorAlert(message: "Enter Address".localized , AlertTitle: "Alert".localized)
            return
        }
        
        var newPAram = [String : AnyObject]()
        newPAram["latitude"] = String(self.latMain) as AnyObject
        newPAram["longitude"] = String(self.longMain) as AnyObject
        newPAram["address"] = self.txtFeildMain.text! as AnyObject
        
        var UrlMain = "user/address/store"
        if objmain["id"] != nil {
            newPAram["address_id"] = objmain["id"]
            UrlMain = "user/address/update"
        }
        
        print(newPAram)
        self.showLoading()
        NetworkManager.post(UrlMain, isLoading: true, withParams: newPAram, onView: self) { (mainResponse) in
            print(mainResponse)
            self.hideLoading()
            if mainResponse?["status_code"] != nil {
                if (mainResponse?["status_code"] as! Int ) == 200 {
                    self.navigationController?.popViewController(animated: true)
                }else {
                    
                }
            }else {
                
            }
            
            
        }
        
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
////        let placePickerController = GMSAutocompleteViewController()
////        placePickerController.delegate = self as! GMSAutocompleteViewControllerDelegate
////        self.present(placePickerController, animated: true) {
////        }
//
//
////        let config = GMSPlacePickerConfig(viewport: nil)
////        let placePicker = GMSPlacePickerViewController(config: config)
////         placePicker.delegate = self
////        present(placePicker, animated: true, completion: nil)
//        let placePickerController = GMSAutocompleteViewController()
//        placePickerController.delegate = self as GMSAutocompleteViewControllerDelegate
//        self.present(placePickerController, animated: true) {
//        }
//    }
}
extension AddNewAddressVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        let placePickerController = GMSAutocompleteViewController()
        //        placePickerController.delegate = self as! GMSAutocompleteViewControllerDelegate
        //        self.present(placePickerController, animated: true) {
        //        }
        
        
        //        let config = GMSPlacePickerConfig(viewport: nil)
        //        let placePicker = GMSPlacePickerViewController(config: config)
        //         placePicker.delegate = self
        //        present(placePicker, animated: true, completion: nil)
        let placePickerController = GMSAutocompleteViewController()
        placePickerController.delegate = self as GMSAutocompleteViewControllerDelegate
        self.present(placePickerController, animated: true) {
        }
    }
}
extension AddNewAddressVC :  GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        
//    }
//    
//    
//    // Handle the user's selection.
//    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        print("Place coordinate: \(place.coordinate)")
        self.latMain = place.coordinate.latitude
        self.longMain = place.coordinate.longitude
        dismiss(animated: true, completion: nil)
        if(place.formattedAddress == "" || place.formattedAddress == nil){
            self.txtFeildMain.text = "Unknown place Cordinates Selected  ".localized + "  " +  "\(place.coordinate.latitude)" + "  " + "\(place.coordinate.longitude)"
        }else{
            self.txtFeildMain.text = place.formattedAddress
        }
        self.Map.setCenter(place.coordinate, animated: true)
        let center = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        let annotation = MKPointAnnotation()
        let location = CLLocation.init(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        annotation.coordinate = (location.coordinate)
        annotation.title = "Cleaning & Servent"
        annotation.subtitle = "current location"
        for annotation in self.Map.annotations{
            self.Map.removeAnnotation(annotation)
        }
        self.Map.addAnnotation(annotation)
        self.Map.setRegion(region, animated: true)
        
        
        
        
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


//extension AddNewAddressVC : GMSPlacePickerViewControllerDelegate {
//
//
//    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
//
//        print("Place name: \(place.name)")
//        print("Place address: \(String(describing: place.formattedAddress))")
//        print("Place attributions: \(String(describing: place.attributions))")
//        print("Place coordinate: \(place.coordinate)")
//        self.latMain = place.coordinate.latitude
//        self.longMain = place.coordinate.longitude
//        dismiss(animated: true, completion: nil)
//        if(place.formattedAddress == "" || place.formattedAddress == nil){
//            self.txtFeildMain.text = "Unknown place Cordinates Selected  ".localized + "  " +  "\(place.coordinate.latitude)" + "  " + "\(place.coordinate.longitude)"
//        }else{
//        self.txtFeildMain.text = place.formattedAddress
//        }
//        self.Map.setCenter(place.coordinate, animated: true)
//        let center = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        let annotation = MKPointAnnotation()
//        let location = CLLocation.init(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
//        annotation.coordinate = (location.coordinate)
//        annotation.title = "Cleaning & Servent"
//        annotation.subtitle = "current location"
//        for annotation in self.Map.annotations{
//            self.Map.removeAnnotation(annotation)
//        }
//        self.Map.addAnnotation(annotation)
//        self.Map.setRegion(region, animated: true)
//
//
//
//
//    }
//
//    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
//
//        viewController.dismiss(animated: true, completion: nil)
//
//        print("No place selected")
//    }
//    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
//        // TODO: handle the error.
////        nvMessage.showError(body: "didFailAutocompleteWithError" )
//    }
//    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//    }
//    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//    }
////    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
////        print("Place name: \(place.name)")
////        print("Place address: \(String(describing: place.formattedAddress))")
////        print("Place attributions: \(String(describing: place.attributions))")
////        print("Place coordinate: \(place.coordinate)")
////        self.latMain = place.coordinate.latitude
////        self.longMain = place.coordinate.longitude
////        dismiss(animated: true, completion: nil)
////        self.txtFeildMain.text = place.formattedAddress
////        self.Map.setCenter(place.coordinate, animated: true)
////         let center = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
////         let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
////        let annotation = MKPointAnnotation()
////        let location = CLLocation.init(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
////        annotation.coordinate = (location.coordinate)
////        annotation.title = "Cleaning & Servent"
////        annotation.subtitle = "current location"
////        for annotation in self.Map.annotations{
////            self.Map.removeAnnotation(annotation)
////        }
////        self.Map.addAnnotation(annotation)
////        self.Map.setRegion(region, animated: true)
////    }
////
////    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
////        // TODO: handle the error.
////        print("Error: ", error.localizedDescription)
////    }
////
////
////    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
////        dismiss(animated: true, completion: nil)
////    }
////
////    // Turn the network activity indicator on and off again.
////    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
////        UIApplication.shared.isNetworkActivityIndicatorVisible = true
////    }
////
////    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
////        UIApplication.shared.isNetworkActivityIndicatorVisible = false
////   }
//}

