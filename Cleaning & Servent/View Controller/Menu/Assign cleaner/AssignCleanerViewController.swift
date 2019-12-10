//
//  AssignCleanerViewController.swift
//  Cleaning & Servent
//
//  Created by waseem on 30/04/2018.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class AssignCleanerViewController: BaseViewController , UITableViewDelegate , UITableViewDataSource
{

    @IBOutlet weak var imgViewBack: UIImageView!
    var arrayrow = [[String : Any]]()
    var maindata = [[String : Any]]()
//    var mainEmployee = [[String : Any]]()
    var selected = [Int]()
    var selectRow = -1
    var bookingID = ""
    var dataEmployee : [[String : Any]]? = [[:]]
    var selectedService : [String : Any]? = [:]
    
    @IBOutlet var tbleviewCleaner : UITableView!
    @IBOutlet var viewCleaner : UIView!
    
    @IBOutlet var tbleviewMain : UITableView!
    
    
    @IBOutlet var lbl_SelectCleaner : UILabel!
    @IBOutlet var lbl_PageTitle : UILabel!
    @IBOutlet var btn_Cancel : UIButton!
    @IBOutlet var btn_Ok : UIButton!
    @IBOutlet var btn_Submit : UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_PageTitle.text = "Assign Cleaner".localized
        lbl_SelectCleaner.text = "Select Cleaner".localized
        btn_Ok.setTitle("OK".localized, for: .normal)
        btn_Cancel.setTitle("Cancel".localized, for: .normal)
        btn_Submit.setTitle("Submit".localized, for: .normal)
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
        }
        
        self.tbleviewMain.register(UINib(nibName: "AssignCell", bundle: nil), forCellReuseIdentifier: "AssignCell")
        self.tbleviewCleaner.register(UINib(nibName: "EmployeeCell", bundle: nil), forCellReuseIdentifier: "EmployeeCell")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        viewCleaner.isHidden = true
        self.GetAllEmployee()
    }
    
    
    func GetAllEmployee(){
        var newPAram  = [String : AnyObject]()
        newPAram["booking_id"] = self.bookingID as AnyObject
        self.showLoading()
        NetworkManager.getWithPArams("user/booking/available-employees", isLoading: true, withParams: newPAram, onView: self) { (mainDAta) in
            print(mainDAta)
            self.hideLoading()
            if(mainDAta?["status_code"] as! Int  == 200){
                self.dataEmployee = mainDAta?["data"] as! [[String : AnyObject]]
                
//                self.mainEmployee = dataEmployee[0]["employees"] as! [[String : AnyObject]]
                
            }else{
                self.hideLoading()
                self.ShowErrorAlert(message: mainDAta?["message"] as! String )
            }
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection _: Int) -> Int {
        if tableView.tag == 100 {
            let cleaners = selectedService?["employees"] as? [[String : Any]]
            return cleaners?.count ?? 0
        }
        return self.maindata.count
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 100 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell") as! EmployeeCell
//            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "EmployeeCell")
            
            let cleaners = selectedService?["employees"] as? [[String : Any]]
            let cleaner = cleaners?[indexPath.row]
            
//            let myItem = self.mainEmployee[indexPath.row]
            
            cell.lbl_name?.text = cleaner?["full_name"] as? String
        
//            cell.imageView
            
            if self.selected.contains(indexPath.row) {
                cell.img_check.image = UIImage(named: "check-2")
//                cell.imageView?.image = UIImage(named: "check-2")
//                cell.accessoryType = .checkmark
            }else {
                cell.img_check.image = UIImage(named: "Check")
//                cell.imageView?.image = UIImage(named: "Check")
//                cell.accessoryType = .none
            }
            cell.selectionStyle = .none
            return cell
        }
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignCell", for: indexPath) as! AssignCell
        
        if let title  = (self.maindata[indexPath.row]["translation"] as! [String :Any])["title"] as? String{
            cell.lblMain.text = title
            
        }
        cell.txtFieldMain.tag = indexPath.row
        cell.txtFieldMain.delegate = self
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 100 {
            if self.selected.contains(indexPath.row) {
                if let index = selected.firstIndex(of: indexPath.row) {
                    selected.remove(at: index)
                }
            }else {
                selected.append(indexPath.row)
            }
        }
        self.tbleviewCleaner.reloadData()
    }

    @IBAction func OkActionCleaner(sender : UIButton){
        
        
        
        
        self.viewCleaner.isHidden = true
        var allemployee : [String] = []
        
//        var employeAdd = [[String : AnyObject]]()
        
        
        var cleaners = selectedService?["employees"] as? [[String : Any]]
        var selectedCleanerIDs : [Int] = []
        selected.sort()
        

        for index in self.selected {
            let cleaner = cleaners?[index]
            allemployee.append(cleaner?["full_name"] as? String ?? "")
            selectedCleanerIDs.append(cleaner?["id"] as! Int)
            
            
//            allemployee = allemployee + ((self.mainEmployee[indexObj])["full_name"] as? String)! + " "
//            employeAdd.append(self.mainEmployee[indexObj] as [String : AnyObject])
        }
        
        let employiesList = allemployee.joined(separator: " ")
        
        dataEmployee?[selectRow].updateValue(selectedCleanerIDs, forKey: "SelectedOnes")

//        print(self.maindata[self.selectRow])
//
//        self.maindata[self.selectRow]["Emp"] = employeAdd
//        print(self.maindata[self.selectRow])
        let cellmain = self.tbleviewMain.cellForRow(at: IndexPath.init(row: self.selectRow, section: 0)) as! AssignCell
        cellmain.txtFieldMain.text = employiesList
    }
    
    @IBAction func CancelActionCleaner(sender : UIButton){
        self.viewCleaner.isHidden = true
    }
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        self.viewCleaner.isHidden = false
//        self.selected.removeAll()
//
//        selectedService = dataEmployee?[textField.tag]
//        self.tbleviewCleaner.reloadData()
//        self.selectRow = textField.tag
//        return false
//    }
    
    @IBAction func BackActionCleaner(sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SubmitActionCleaner(sender : UIButton){
//        for indexObj in
        
        
        
        
        var newparam = [String : AnyObject]()
//        var newArray = [[String : AnyObject]]()
        newparam["id"] = self.bookingID as AnyObject
        for (index,serviceData) in dataEmployee!.enumerated() {
//            var employee : [String : AnyObject] = [:]
            guard let  employeeIDs = serviceData["SelectedOnes"] as? [Int]else {
                let translation = serviceData["translation"] as? [String : Any]
                let service = translation?["title"] as! String
                let message = "Please select cleaner for \"\(service)\""
                ShowErrorAlert(message: message)
                return
            }
            
            
            
            let serviceID = serviceData["id"] as! Int
            
            
//            employee.updateValue(employeeIDs as AnyObject, forKey: "employee_id")
//            employee.updateValue([serviceID] as AnyObject, forKey: "service_id")
//            newArray.append(employee)
            for (idIndex, value) in employeeIDs.enumerated(){
                newparam.updateValue(value as AnyObject, forKey: "employees[\(index)][employee_id][\(idIndex)]")
            }
            newparam.updateValue(serviceID as AnyObject, forKey: "employees[\(index)][service_id]")
            
        }
//        newparam.updateValue(newArray as AnyObject, forKey: "employees")
//        for(int i = 0 ; i < assignCleaners.size() ; i++){
//            params.add("employees[" + i + "][service_id]", assignCleaners.get(i).service_id + "");
//            for(int k = 0 ; k < assignCleaners.get(i).employee_id.size() ; k++){
//                params.add("employees[" + i + "][employee_id][" + k + "]", assignCleaners.get(i).employee_id.get(k) + "");
//            }
//        }
        
        
        
//        let tableSubviews =       self.tbleviewMain.subviews
//        for indexObj in tableSubviews{
//            if let cellMain = indexObj as? AssignCell {
//                var newValue = [String : AnyObject]()
//                var arrayEmplyeeID = [String]()
//
//                if cellMain.txtFieldMain.hasText {
//                    newValue["service_id"] = String(self.maindata[cellMain.txtFieldMain.tag]["id"] as! Int) as AnyObject
//                    let newValue = self.maindata[cellMain.txtFieldMain.tag]["Emp"] as! [[String : AnyObject]]
//                    for indexObj in newValue {
//                        arrayEmplyeeID.append(String(indexObj["id"] as! Int))
//                    }
//                }
//
//                if arrayEmplyeeID.count > 0 {
//                    newValue["employee_id"] = arrayEmplyeeID as AnyObject
//                    newArray.append(newValue)
//                }
//            }
//        }
//
//
//        newparam["employee"] = newArray as AnyObject
        print(newparam)
        self.showLoading()
        NetworkManager.post("user/bookings/assign-employees", isLoading: true, withParams: newparam, onView: self) { (mainData) in
            self.hideLoading()
            print(mainData)
            if(mainData?["status_code"] as! Int  == 200){
                
                
                self.ShowSuccessAlert(message: mainData?["message"] as! String)
//                self.dataEmployee = mainDAta?["data"] as! [[String : AnyObject]]
                
                //                self.mainEmployee = dataEmployee[0]["employees"] as! [[String : AnyObject]]
                
            }else{
                self.hideLoading()
                self.ShowErrorAlert(message: mainData?["message"] as! String )
            }
            
            
        }
    }
    
}

extension AssignCleanerViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.viewCleaner.isHidden = false
        self.selected.removeAll()
        
        selectedService = dataEmployee?[textField.tag]
        self.tbleviewCleaner.reloadData()
        self.selectRow = textField.tag
        return false
    }
}
class AssignCell : UITableViewCell {
    
    
    
    @IBOutlet var lblMain : UILabel!
    @IBOutlet var txtFieldMain : UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        txtFieldMain.placeholder = "Select Cleaner".localized
    }
    
    
    
}
//extension AssignCell : UITextFieldDelegate{
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        return false
//    }
//}
