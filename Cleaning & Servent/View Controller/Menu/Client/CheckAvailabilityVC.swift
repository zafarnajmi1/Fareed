//
//  CheckAvailabilityVC.swift
//  Fareed
//
//  Created by Asif Habib on 04/09/2019.
//  Copyright © 2019 Jaidee. All rights reserved.
//

import UIKit

class CheckAvailabilityVC: BaseViewController {
    
    @IBOutlet weak var lbl_pageTitle: UILabel!
    @IBOutlet weak var tbl_cleaners: UITableView!
    @IBOutlet weak var btn_confirm: UIButton!
    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_service: UILabel!
    @IBOutlet weak var imgViewBack: UIImageView!
    
    var dataArray : [[String : Any]]?
    var emloyessArray : [String : Any]?
    
    var bookingData : [String : Any]?
    var bookingID : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_pageTitle.text = "Check Employee Availability".localized
        btn_confirm.setTitle("Confirm Booking".localized, for: .normal)
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
        }
        self.tbl_cleaners.register(UINib(nibName: "ClientCell", bundle: nil), forCellReuseIdentifier: "ClientCell")
        getCleaners()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - Network
    func getCleaners(){
        
        let url = "user/booking/available-employees?booking_id=\(bookingID ?? 0)"
        self.showLoading()
        NetworkManager.get(url, isLoading: true, onView: self) { [weak self] (mainResponse) in
            print(mainResponse)
            self!.hideLoading()
            if (mainResponse?["status_code"] as! Int) == 200 {
                
                self?.dataArray = mainResponse?["data"] as? [[String : Any]]
               //employees

               
 ////////////////////////////////////////////
//                if self?.dataArray?.count == 0{
//                    self?.ShowErrorAlert(message: "Employees are not Available. Give booking note or cancel booking".localized, AlertTitle: "Alert".localized)
//                }else{
//                    print("Has Employees")
//                }
                /////////////////////////////////////////////////////////
//                if (data1?.count ?? 0) > 0 {
//                    let data = data1?[0]
//                    self?.cleaners = data?["employees"] as? [[String : Any]]
//                    self?.bookingData = data?["translation"] as? [String : Any]
                    self?.loaddataOnUI()
//                }
//                else {
//                    self?.ShowErrorAlert(message: mainResponse?["message"] as! String)
//                }
               
            }else {
                self!.hideLoading()
                self?.ShowErrorAlert(message: mainResponse?["message"] as! String)
            }


        }
    }
    func loaddataOnUI(){
//        lbl_service.text = bookingData?["title"] as? String
        tbl_cleaners.reloadData()
    }
    func confirmBooking(){
        let url = "user/booking/confirm?booking_id=\(bookingID ?? 0)"
        
        self.showLoading()
        NetworkManager.get(url, isLoading: true, onView: self) { [weak self] (mainResponse) in
            print(mainResponse)
            self!.hideLoading()
            if (mainResponse?["status_code"] as! Int) == 200 {
                
                self?.ShowSuccessAlert(message: mainResponse?["message"] as! String)
                
//                let data = mainResponse?["data"] as? [String : Any]
//                self?.cleaners = data?["employees"] as? [[String : Any]]
//                self?.bookingData = data?["translation"] as? [String : Any]
//                self?.loaddataOnUI()
            }else {
                self!.hideLoading()
                self?.ShowErrorAlert(message: mainResponse?["message"] as! String)
            }
            
            
        }
    }
    
    // MARK: - Navigation
    
    @IBAction func onClick_confirm(_ sender : Any){
        let alert = UIAlertController(title: "Please confirm".localized, message: "Do you really want to Confirm the booking?".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction(title: "OK".localized, style: .destructive, handler: { [weak self] (action) in
            self?.confirmBooking()
        }))
        present(alert, animated: true, completion: nil)
        
        
//        confirmBooking()
    }
    @IBAction func onClick_back(_ sender : Any){
        navigationController?.popViewController(animated: true)
    }

}
extension CheckAvailabilityVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let dataArray = dataArray{
            return dataArray.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .white
        view.backgroundColor = .white
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let cleanerData = dataArray?[section]
        let translation = cleanerData?["translation"] as? [String : Any]
        return translation?["title"] as? String
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataArray = dataArray {
            let cleanerData = dataArray[section]
            let cleaners = cleanerData["employees"] as? [[String : Any]]
            
            if cleaners?.count == 0{

                
                let alert = UIAlertController(title: "Alert".localized, message: "Employees are not Available. Give booking note or cancel booking".localized, preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK".localized, style: .destructive, handler: { [weak self] (action) in
                    self?.navigationController?.popViewController(animated: true)
                }))
                present(alert, animated: true, completion: nil)

            }else{
                
            }
            return cleaners?.count ?? 0
        }
        else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "ClientCell") as! ClientCell
        let cleanerData = dataArray?[indexPath.section]
        let cleaners = cleanerData?["employees"] as? [[String : Any]]
//        let cleaner = cleaners?[indexPath.row]
        let cleaner = cleaners?[indexPath.row]
        cell.lblName.text = cleaner?["full_name"] as? String
        cell.lblPhone.text = cleaner?["phone"] as? String
        let url = URL(string: cleaner?["image"] as? String ?? "")
        cell.imgViewMain.sd_setImage(with: url, placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
        
        return cell
    }
    
    
}
