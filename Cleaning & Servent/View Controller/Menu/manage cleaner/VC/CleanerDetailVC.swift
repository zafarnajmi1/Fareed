//
//  CleanerDetailVC.swift
//  Fareed
//
//  Created by Asif Habib on 25/09/2019.
//  Copyright © 2019 Jaidee. All rights reserved.
//

import UIKit
import DLRadioButton

protocol CleanerDetailAlertViewDelegate {
    func updateProfile(services : [[String : Any]]?)
}
class CleanerDetailAlertView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var uv_gender : UIView!
    @IBOutlet weak var txt_input: UITextField!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_update: UIButton!
    @IBOutlet weak var radioMale: DLRadioButton!
    @IBOutlet weak var radioFemale: DLRadioButton!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var uv_alertView : UIView!
    @IBOutlet weak var uv_servicesList : UIView!
    @IBOutlet weak var lbl_servicesTitle: UILabel!
    @IBOutlet weak var btn_Add: UIButton!
    @IBOutlet weak var tbl_services: UITableView!
    
    @IBOutlet weak var lc_tableViewHeight: NSLayoutConstraint!
    var delegate: CleanerDetailAlertViewDelegate!
    
    var arrayService = [[String : Any]]()
    var selectedServices = [Int]() {
        didSet {
//            for index, service in array
            for  serivce in arrayService.enumerated() {
                let serviceID = serivce.element["id"] as! Int
                if selectedServices.contains(serviceID){
                    arrayService[serivce.offset].updateValue("True", forKey: "selected")
                }
                else{
                    arrayService[serivce.offset].removeValue(forKey: "selected")
                }
                
            }
        }
    }

    
    
    
    @IBAction func onClick_update(_ sender : Any){
        delegate.updateProfile(services: nil)
//        self.isHidden = true
        hideView()
        
    }
    @IBAction func onClick_cancel(_ sender : Any){
        hideView()
    }
    @IBAction func onClick_bg(_ sender : Any){
        hideView()
    }
    @IBAction func onClick_Add(_ sender : Any){
        hideView()
        delegate.updateProfile(services: arrayService)
    }
    
    
    
    
    
    
    override func awakeFromNib() {
        tbl_services.register(UINib.init(nibName: "ServiceTableCell", bundle: nil), forCellReuseIdentifier: "ServiceTableCell")
        lbl_servicesTitle.text = "Select Services".localized
        btn_Add.setTitle("ADD NOW".localized, for: .normal)
        btn_update.setTitle("Update".localized, for: .normal)
        btn_cancel.setTitle("Cancel".localized, for: .normal)
        radioMale.setTitle("Male".localized, for: .normal)
        radioFemale.setTitle("Female".localized, for: .normal)
        txt_input.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
    }
    @objc func valueChanged(){
        if txt_input.text == "" {
            btn_update.isEnabled = false
            btn_update.alpha = 0.75
        }
        else{
            btn_update.isEnabled = true
            btn_update.alpha = 1
        }
    }
    func hideView(){
        btn_update.isEnabled = true
        btn_update.alpha = 1
        isHidden = true
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayService.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceTableCell") as! ServiceTableCell
        
//        cell.check_box_img.image = UIImage.init(named: "uncheckselectedcheckbox")
        let translation = self.arrayService[indexPath.row]["translation"] as! [String : Any]
        
        cell.service_name.text = translation["title"] as? String
        cell.img.sd_setImage(with: URL.init(string: self.arrayService[indexPath.row]["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "greylogo") ,completed: nil)
        
        if (self.arrayService[indexPath.row]["selected"] as? String) != nil {
            cell.btn_check.setImage(UIImage(named: "check-2"), for: .normal)
        }
        else{
            cell.btn_check.setImage(UIImage(named: "Check"), for: .normal)
            
        }
//        print(self.arrayService.count % 3)
//        cell.bottomView.isHidden = false
//        if indexPath.row >= (self.arrayService.count - (self.arrayService.count % 3) ) {
//            cell.bottomView.isHidden = true
//
//        }
//
//        cell.rightView.isHidden = false
//        if ((indexPath.row + 1)  % 3) == 0  {
//            cell.rightView.isHidden = true
//
//        }
    
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ServiceTableCell
        if (self.arrayService[indexPath.row]["selected"] as? String) != nil {
            self.arrayService[indexPath.row].removeValue(forKey: "selected")
            cell.btn_check.setImage(UIImage(named: "Check"), for: .normal)
            
        }
        else{
            self.arrayService[indexPath.row].updateValue("True", forKey: "selected")
            cell.btn_check.setImage(UIImage(named: "check-2"), for: .normal)
        }
        
    }
    func setTableViewHeight(){
        tbl_services.layoutIfNeeded()
        let size =  tbl_services.contentSize
        
        if size.height > (self.frame.size.height - 190){
            lc_tableViewHeight.constant = self.frame.size.height - 190
        }
        else{
            lc_tableViewHeight.constant = CGFloat(arrayService.count * 90)//size.height
        }
        tbl_services.layoutIfNeeded()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
class CleanerDetailVC: BaseViewController, CleanerDetailAlertViewDelegate {
    
    @IBOutlet weak var lbl_HEading: UILabel!
    
    @IBOutlet weak var clv_services : UICollectionView!
    @IBOutlet weak var lbl_title: UILabel!

    @IBOutlet weak var tbl_table : UITableView!
    @IBOutlet weak var img_userImage : UIImageView!
    @IBOutlet weak var btn_historyReviews: UIButton!
    var selectedImage : UIImage!
//    @IBOutlet weak var uv_servicesView : CleanerDetailServicesView!
    @IBOutlet weak var uv_alertView : CleanerDetailAlertView!
    @IBOutlet weak var imgViewBack: UIImageView!
    var selectedObject : CleanerInfoObj?
    var employesInfoArray : [CleanerInfoObj] = []
    var employeeDetails : [String : Any] = [:]
    var postParms : [String: AnyObject] = [:]
    var selectedServicesIDs = [Int]()
    var employee_ID : String = ""
    
    
    var servicesArray : [[String : Any]]{
        get {
            if let items = employeeDetails["services"] as? [[String : Any]]{
                return items
            }
            else{
                return []
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(employee_ID)
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
        }
        tbl_table.register(UINib(nibName: "CleanerDetailCell", bundle: nil), forCellReuseIdentifier: "CleanerDetailCell")
        clv_services.register(UINib.init(nibName: "ServicesCell", bundle: nil), forCellWithReuseIdentifier: "ServicesCell")
        
        tbl_table.estimatedRowHeight = 80
        tbl_table.rowHeight = UITableView.automaticDimension
        img_userImage.layer.cornerRadius = 5
        img_userImage.clipsToBounds = true
        uv_alertView.arrayService = DataManager.sharedInstance.user!.services
        getEmployeeDetails()
        setupTexts()
        view.bringSubviewToFront(uv_alertView)

        uv_alertView.delegate = self
        
        
        
        // Do any additional setup after loading the view.
    }
    func setupTexts(){
        self.lbl_HEading.text = "Cleaner Detail".localized
        lbl_title.text = "Services".localized
        btn_historyReviews.setTitle("HISTORY & REVIEWS".localized, for: .normal)
    }
    func getEmployeeDetails(){
        let url = "company/employee/detail?employee_id=" + employee_ID
        self.showLoading()
        NetworkManager.get(url, isLoading: true, onView: self) { [weak self] (mainResponse) in
            self!.hideLoading()
            print(mainResponse)
            if(mainResponse?["message"] as! String == "Employee Detail".localized)
            {
                self?.employeeDetails = mainResponse?["data"] as! [String : Any]
                self?.loadArray(object: mainResponse?["data"] as! [String : Any])
            }
            else{
                self!.hideLoading()
                self?.ShowErrorAlert(message:  mainResponse?["message"] as! String)
            }

            
        }
    }
    func updateEmployee(){
        
    }
    func loadArray(object : [String : Any]){
        
        let image = object["image"] as! String
        
        img_userImage.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "profile_placeholder"))
        
        let full_name = object["full_name"] as! String
        let cnic = object["cnic"] as! String
        let phone = object["phone"] as! String
//        let email = object["email"] as? String
        let about = object["about"] as! String
        let address = object["address"] as! String
        let gender = object["gender"] as! String
        
        
        
        
        postParms = ["full_name": full_name,
            "phone": phone,
            "cnic": cnic,
            "gender": gender,
            "address": address,
            "about": about,
            "company_id": "\(employeeDetails["company_id"] as! Int)",
            "employee_id": employee_ID] as [String : AnyObject]
        employesInfoArray = [CleanerInfoObj(title: full_name, image: "profile", type: .name),
        CleanerInfoObj(title: cnic, image: "cnic", type: .cnic),
        CleanerInfoObj(title: phone, image: "Phone-green", type: .phone),
//        CleanerInfoObj(title: email, image: "maile", type: .email),
        CleanerInfoObj(title: about, image: "About", type: .about),
        CleanerInfoObj(title: address, image: "book", type: .address),
        CleanerInfoObj(title: gender=="male" ? "Male".localized : "Female".localized, image: "gender", type: .gender),]
        tbl_table.reloadData()
        selectedServicesIDs = []
        for service in (employeeDetails["services"]  as! [[String : Any]]){
            selectedServicesIDs.append(service["id"] as! Int)
        }
        
//        uv_servicesView.servicesArray = object ["services"] as! [[String : Any]]
//        uv_servicesView.clv_services.reloadData()
        uv_alertView.selectedServices = selectedServicesIDs
        uv_alertView.setTableViewHeight()
        clv_services.reloadData()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func Back_Action(){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClick_addService(_ sender: Any){
        uv_alertView.isHidden = false
        uv_alertView.uv_servicesList.isHidden = false
        uv_alertView.uv_alertView.isHidden = true
        
        for service in (employeeDetails["services"]  as! [[String : Any]]){
            selectedServicesIDs.append(service["id"] as! Int)
        }
        uv_alertView.selectedServices = selectedServicesIDs
        uv_alertView.tbl_services.reloadData()
        
    }
    @IBAction func onClick_Delete(_ sender : Any){
        
        let alert = UIAlertController(title: "Alert".localized , message: "Do you want to remove?".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes".localized, style: .destructive) { [weak self] action in
//            alert.dismiss(animated: true, completion: nil)
            self?.deleteProfile()
        })
        alert.addAction(UIAlertAction(title: "No".localized, style: .cancel) { action in
//            alert.dismiss(animated: true, completion: nil)
        })
        present(alert, animated: true, completion: nil)
        
//        self.ShowSuccessAlertWithNoAction(message: MainResponse?["message"] as! String)
//        hideView()
//        delegate.updateProfile(services: arrayService)
    }
    @IBAction func onClick_editImage(_ sender: Any){
        showMediaChoosingOptions()
    }
    @IBAction func onClick_historyAndReview(_ sender: Any){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CleanerReviewsVC") as! CleanerReviewsVC
        vc.reviews = employeeDetails["reviews"] as! [[String : Any]]
        vc.screenTitle = employeeDetails["full_name"] as! String
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    override func selectedImage(image: UIImage) {
//        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                            self.selectedImage = image
                            self.img_userImage.image = image
                            let params = updateServicesParams(selectedServicesIDs)
                            updateEmployeeProfile(params: params, image: selectedImage)
//                        }
    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//                self.selectedImage = pickedImage
//                self.img_userImage.image = pickedImage
//                let params = updateServicesParams(selectedServicesIDs)
//                updateEmployeeProfile(params: params, image: selectedImage)
//            }
//
//            dismiss(animated: true, completion: nil)
//    }
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            dismiss(animated: true, completion: nil)
//    }
    
    
    func updateProfile(services: [[String : Any]]?) {
        if let services = services {
            var idsList : [Int] = []
            for object in services {
                if (object["selected"] as? String) != nil {
                    idsList.append(object["id"] as! Int)
                }
                
            }
            if idsList.count == 0 {
                ShowErrorAlert(message: "Employee at least have one service".localized)
            }
            else{
                let params = updateServicesParams(idsList)
                updateEmployeeProfile(params: params)
            }
            
        }
        else{
            let params = updateListParams()
            let updatedparams = updateServicesParams(params: params, selectedServicesIDs )
            
            updateEmployeeProfile(params: updatedparams)
            
        }
        
    }
    func postUpdateProfile(services: [String], image: UIImage?){
        self.updateListParams()
        
    }
    func removeServiceAndUpdate(_ value : Int){
    
        var idsList = selectedServicesIDs
        for tuple in idsList.enumerated() {
            if tuple.element == value{
                idsList.remove(at: tuple.offset)
                break
            }
        }
        let params = updateServicesParams(idsList)
        updateEmployeeProfile(params: params)
//        updateProfle(params: T##[String : Any], iamge: <#T##UIImage#>)
//        updateProfle(services: params, image: nil)
        
    }
    

    func updateServicesParams(params : [String : AnyObject]? = nil, _ list : [Int]) -> [String: Any]{
//        if list.count < 2 {
//            return
//        }
        
        if var params = params{
//            var params = postParms
            for (index,id) in list.enumerated(){
                params.updateValue("\(id)" as AnyObject, forKey: "service_id[\(index)]")
            }
            return params
        }
        else{
            var params = postParms
            for (index,id) in list.enumerated(){
                params.updateValue("\(id)" as AnyObject, forKey: "service_id[\(index)]")
            }
            return params
        }
        
        
    }
    func updateListParams() -> [String :AnyObject]{
        
        
        var params = postParms
        var value = ""//uv_alertView.txt_input.text
        
        if (selectedObject?.type)! == .gender{
            value = uv_alertView.radioMale.isSelected ? "male" : "female"
        }
        else{
            value = uv_alertView.txt_input.text!
        }
        
        switch (selectedObject?.type)! {
        case .name:
            params.updateValue(value as AnyObject, forKey: "full_name")
        case .phone:
            params.updateValue(value as AnyObject, forKey: "phone")
        case .email: break
        //            postParms.updateValue(value!, forKey: "full_name")
        case .gender:
            params.updateValue(value as AnyObject, forKey: "gender")
        case .cnic:
            params.updateValue(value as AnyObject, forKey: "cnic")
        case .about:
            params.updateValue(value as AnyObject, forKey: "about")
        case .address:
            params.updateValue(value as AnyObject, forKey: "address")
        }
        return params
    }
    func deleteProfile(){
        
        let params = ["id" : employee_ID]
        self.showLoading()
        NetworkManager.post("company/employees/destroy", isLoading: true, withParams: params as [String : AnyObject], onView: self) { (mainResponse) in
            print(mainResponse)
            self.hideLoading()
            if (mainResponse?["status_code"] as! Int)  == 200 {
                self.ShowSuccessAlert(message: (mainResponse?["message"] as! String))
                
            }else {
                self.hideLoading()
                self.ShowErrorAlert(message: (mainResponse?["message"] as! String))
            }
        }
    }
    func updateEmployeeProfile(params : [String : Any], image : UIImage? = nil){
        NetworkManager.UploadFiles("company/employees/update", image: image, imageName:"image", withParams: params as Dictionary<String, AnyObject>, onView: self, completion: { (MainResponse) in
            print(MainResponse)
            if (MainResponse?["status_code"] as! Int) == 200{
                self.ShowSuccessAlertWithNoAction(message: MainResponse?["message"] as! String)
                self.getEmployeeDetails()
//                self.ShowSuccessAlert(message: MainResponse?["message"] as! String)
            }else {
                self.ShowErrorAlert(message: MainResponse?["message"] as! String)
            }
        })
    }
    
}
extension CleanerDetailVC : UITableViewDelegate, UITableViewDataSource, CleanerDetailCellDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employesInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CleanerDetailCell") as! CleanerDetailCell
        let obj = employesInfoArray[indexPath.row]
        cell.loadCell(object: obj)
        cell.delegate = self
        
        return cell
    }
    
    func updateItem(object: CleanerInfoObj?) {
        selectedObject = object
        var title = ""
        switch (object?.type)! {
        case .name:
            title = "Name".localized
        case .phone:
            title = "Phone".localized
        case .email:
            title = "Email".localized
        case .gender:
            title = "Select Gender".localized
        case .cnic:
            title = "ID number".localized
        case .about:
            title = "About".localized
        case .address:
            title = "Address".localized
        }
        showAlert(title: title, value: object?.title, isGender: object?.type == .gender)
//        default:
//            print("Nothing")
//        }
    }
    func showAlert(title : String?, value : String?, isGender : Bool){
        uv_alertView.lbl_title.text = title
        
        if isGender{
            uv_alertView.uv_gender.isHidden = false
            if value?.lowercased() == "male" {
                uv_alertView.radioMale.isSelected = true
            }
            else{
                uv_alertView.radioFemale.isSelected = true
            }
        }
        else{
            uv_alertView.uv_gender.isHidden = true
            uv_alertView.txt_input.text = value
        }
        uv_alertView.uv_servicesList.isHidden = true
        
        uv_alertView.uv_alertView.isHidden = false
        uv_alertView.isHidden = false
    }
        
    
}
extension CleanerDetailVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.servicesArray.count
        
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: (view.frame.size.width/3)  , height: ((view.frame.size.width/3) - 10) )
        
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "ServicesCell", for: indexPath) as! ServicesCell
        cell.check_box_img.image = UIImage(named: "greencross")
        cell.img.sd_setImage(with: URL.init(string: self.servicesArray[indexPath.row]["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
        if let title  = (self.servicesArray[indexPath.row]["translation"] as! [String :Any])["title"] as? String{
            cell.service_name.text = title
        }
        
        //        cell.check_box_img.isHidden = true
        cell.check_box_img.isUserInteractionEnabled = true
        cell.check_box_img.tag = indexPath.row
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(onClick_cross(_:)))
        cell.check_box_img.addGestureRecognizer(tapgesture)
        
        print(self.servicesArray.count % 3)
        cell.bottomView.isHidden = true
        /*            if indexPath.row >= (self.servicesArray.count - (self.servicesArray.count % 3) ) {
         cell.bottomView.isHidden = true
         
         }*/
        
        cell.rightView.isHidden = false
        /* if ((indexPath.row + 1)  % 3) == 0  {
         cell.rightView.isHidden = true
         
         }*/
        
        return cell
        
    }
    @objc func onClick_cross(_ sender: UITapGestureRecognizer){
                print("Cross Clicked:\(sender.view?.tag ?? -1)")
        let index = sender.view?.tag
        if servicesArray.count < 2 {
            ShowErrorAlert(message: "Employee at least have one service".localized)
        }
        else{
            
            let id = servicesArray[index!]["id"] as! Int
            removeServiceAndUpdate(id)
        }
        
    }
        //    }
}
enum CleanerInfoType: Int {
    
    case name = 1
    case phone = 2
    case email = 3
    case gender = 4
    case cnic = 5
    case about = 6
    case address = 7
    
}
struct CleanerInfoObj {
    
    var title : String?
    var image : String?
    var type : CleanerInfoType?
    init(title : String?, image : String?, type : CleanerInfoType?){
        self.title = title
        self.image = image
        self.type = type
    }
}
