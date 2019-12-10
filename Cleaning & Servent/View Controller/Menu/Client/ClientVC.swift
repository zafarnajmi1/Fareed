//
//  ClientVC.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 4/3/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class ClientVC: BaseViewController , UITableViewDelegate , UITableViewDataSource {
    @IBOutlet weak var Tbl_client: UITableView!
    @IBOutlet weak var lbl_Heading: UILabel!

    @IBOutlet weak var imgViewBack: UIImageView!
    var arrayclients = [[String : Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
        }
        
        self.lbl_Heading.text = "Client".localized

        self.Tbl_client.register(UINib(nibName: "ClientCell", bundle: nil), forCellReuseIdentifier: "ClientCell")
    }

    @IBAction func Back(_ sender: Any) {
        self.Back()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        if self.arrayclients.count == 0 {
            self.APICall()
        }
    }
    
    func APICall(){
        self.arrayclients.removeAll()
        self.showLoading()
        NetworkManager.get("user/clients", isLoading: true, onView: self) { (MainResponse) in
            print(MainResponse)
            self.hideLoading()
            if (MainResponse?["status_code"] as! Int) == 200 {
                self.arrayclients = (MainResponse?["data"] as? [[String : AnyObject]])!
                
            }else{
                self.hideLoading()
                self.ShowErrorAlert(message:  MainResponse?["message"] as! String)
            }
            
            self.Tbl_client.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.arrayclients.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "ClientCell") as! ClientCell
        cell.lblName.text = self.arrayclients[indexPath.row]["full_name"] as! String
        cell.lblPhone.text = self.arrayclients[indexPath.row]["mobile"] as! String
        
        cell.imgViewMain.sd_setImage(with: URL.init(string: self.arrayclients[indexPath.row]["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)

        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let clientVC = self.GetView(nameViewController: "ClientDetailVC", nameStoryBoard: "Booking") as! ClientDetailVC
        clientVC.clientdata = self.arrayclients[indexPath.row]
        self.navigationController?.pushViewController(clientVC, animated: true)
    }
}
