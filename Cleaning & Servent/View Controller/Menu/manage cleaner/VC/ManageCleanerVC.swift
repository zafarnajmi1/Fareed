//
//  ManageCleanerVC.swift
//  Cleaning & Servent
//
//  Created by Hassan Mumtaz on 5/4/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class ManageCleanerVC:  BaseViewController {
    
    @IBOutlet weak var manageCleanerTableView: UITableView!
    @IBOutlet weak var imgViewBack: UIImageView!
    
    var arrayEmployee = [[String : Any]]()
    @IBOutlet weak var lbl_HEading: UILabel!
    @IBOutlet weak var lbl_addCleaner: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
      // self.title = "Manage Cleaner".localized
         self.lbl_HEading.text = "Manage Cleaner".localized
        self.lbl_addCleaner.setTitle("Add New Cleaner".localized, for: .normal)
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
        }
        self.manageCleanerTableView.register(UINib(nibName: "ClientCell", bundle: nil), forCellReuseIdentifier: "ClientCell")
        
        manageCleanerTableView.delegate = self
        manageCleanerTableView.dataSource = self
    }
    @IBAction func Back_Action(){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnAddNewCleaner(_ sender: Any) {
        
        self.PushViewWithIdentifier(name: "AddNewCleanerVC")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.showLoading()
        NetworkManager.get("company/employees", isLoading: true, onView: self) { (mainResponse) in
            print(mainResponse)
            self.hideLoading()
            if (mainResponse?["status_code"] as! Int) == 200 {
                self.arrayEmployee = mainResponse?["data"] as! [[String : Any]]
            }else {
                self.hideLoading()
                self.ShowErrorAlert(message: mainResponse?["message"] as! String)
            }
            
            self.manageCleanerTableView.reloadData()
        }
//
    }
    
    
}
extension ManageCleanerVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayEmployee.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "ClientCell") as! ClientCell
        let newData = self.arrayEmployee[indexPath.row] as! [String : Any]
        cell.lblName.text = newData["full_name"] as? String
        cell.lblPhone.text = newData["phone"] as? String
        
        cell.imgViewMain.sd_setImage(with: URL.init(string: newData["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)

        cell.selectionStyle = .none
        return cell
    }
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Indexpath Selected \(indexPath.row)")
        if let newData = self.arrayEmployee[indexPath.row] as? [String : Any]{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CleanerDetailVC") as! CleanerDetailVC
//            vc.employeeDetails = newData
            vc.employee_ID = "\(newData["id"] as! Int)"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

