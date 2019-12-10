//
//  BookingListViewController.swift
//  Servent
//
//  Created by waseem on 12/02/2018.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class BookingListViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var tbleViewBooking : UITableView!
    
    var arrayAddress = [AddressModel]()

    weak var delegate: SelectedAddress?
    
    var isChoose = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbleViewBooking.register(UINib(nibName: "BookingMainCell", bundle: nil), forCellReuseIdentifier: "BookingMainCell")
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewWillAppear(_ animated: Bool) {
        self.AddressAPI()
    }
    
    func AddressAPI(){
        self.arrayAddress.removeAll()
        self.showLoading()
        NetworkManager.get("user/addresses", isLoading: true, onView: self) { (mainResponse) in
            print(mainResponse)
            self.hideLoading()
            if(mainResponse?["status_code"] as! Int == 200 ){
                let servicesMain = mainResponse?["data"] as? [[String : AnyObject]]
                
                
                for IndexMain in servicesMain!{
                    self.arrayAddress.append(AddressModel.init(json: IndexMain))
                }
                
            }else{
                self.hideLoading()
                self.ShowErrorAlert(message:  mainResponse?["message"] as! String)
            }
            self.tbleViewBooking.reloadData()
        }
    }

    @IBAction func Back_Action(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.arrayAddress.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "BookingMainCell") as! BookingMainCell
        cell.lblBookingHEading.text = "Address " + String(indexPath.row + 1)
        cell.lblBookingText.text = self.arrayAddress[indexPath.row].address
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(self.RemoveAddress), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        
//        if isChoose {
//            delegate?.SelectedAddress(address: self.arrayAddress[indexPath.row])
//            self.navigationController?.popViewController(animated: true)
//        }else {
//            
//            let storyboard = UIStoryboard(name: "Booking", bundle: nil)
//            let viewObj = (storyboard.instantiateViewController(withIdentifier: "AddNewAddressVC")) as! AddNewAddressVC
//            self.navigationController?.pushViewController(viewObj, animated: true)
//        }
        

    }
    
    @IBAction func AddNew(sender : UIButton){
        
        self.PushView(nameViewController: "NewAddressViewController", nameStoryBoard: "Booking", isAnimated: true)
    }
    
    @objc func RemoveAddress(sender : UIButton){
        print(sender.tag)
        
        
        var newPAram = [String : AnyObject]()
        newPAram["id"] = self.arrayAddress[sender.tag].addressID as AnyObject
        
        self.showLoading()
        NetworkManager.post("user/address/destroy", isLoading: true, withParams: newPAram, onView: self) { (MainResponse) in
            print(MainResponse)
            self.hideLoading()
            self.AddressAPI()
            
        }
        
    }
    
}


class BookingMainCell : UITableViewCell{
    @IBOutlet var lblBookingHEading : UILabel!
    @IBOutlet var lblBookingText : UILabel!
    @IBOutlet var btnDelete : UIButton!
}
