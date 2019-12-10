//
//  AddressBookVC.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 3/17/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

protocol SelectedAddress:class {
    func SelectedAddress(address: [String : AnyObject])
}


class AddressBookVC: BaseViewController, UITableViewDelegate , UITableViewDataSource {
    @IBOutlet weak var TBL_Address_Book: UITableView!
    
    @IBOutlet weak var lblHEading: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var imgViewBack: UIImageView!
    var arrayMain = [[String : AnyObject]]()
    
    weak var delegate: SelectedAddress?
    
    var isChoose = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
        }
        
        self.lblHEading.text = "Address Book".localized
        self.btnAdd.setTitle("ADD ADDRESS".localized, for: .normal)
        self.TBL_Address_Book.register(UINib.init(nibName: "AddressBookCell", bundle: nil), forCellReuseIdentifier: "AddressBookCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.GetAddress()
    }
    
    func GetAddress(){
        self.arrayMain.removeAll()
        self.showLoading()
        NetworkManager.get("user/addresses", isLoading: true, onView: self) { (MainData) in
            print(MainData)
            self.hideLoading()
            if MainData?["status_code"] != nil {
                if (MainData?["status_code"] as! Int ) == 200 {
                    self.arrayMain = MainData?["data"] as! [[String : AnyObject]]
                }else {
                    self.hideLoading()
                }
            }else {
                
            }
            
            self.TBL_Address_Book.reloadData()
        }
    }

    @IBAction func OnClickAddNewAddress(_ sender: Any) {
        self.PushViewWithIdentifier(name: "AddNewAddressVC")
    }
    @IBAction func OnClickBack(_ sender: Any) {
        
        self.Back()
        self.Dismiss()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayMain.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressBookCell") as! AddressBookCell
            cell.lblAddress.text = self.arrayMain[indexPath.row]["address"] as! String
        cell.lblHeading.text = "Address ".localized + String(indexPath.row + 1)
        cell.btnEdit.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        
        cell.btnEdit.addTarget(self, action: #selector(self.EditAction), for: .touchUpInside)
        cell.btnDelete.addTarget(self, action: #selector(self.DeleteAction), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
    }
    
    @objc func EditAction(sender : UIButton){
//        self.PushViewWithIdentifier(name: "AddNewAddressVC")
        
        let addNewAddress = self.storyboard?.instantiateViewController(withIdentifier: "AddNewAddressVC") as! AddNewAddressVC
        print(self.arrayMain[sender.tag])
        addNewAddress.objmain = self.arrayMain[sender.tag]
        
        self.navigationController?.pushViewController(addNewAddress, animated: true)
    }
    
    @objc func DeleteAction(sender : UIButton){
        let alert = UIAlertController(title: "" , message: "Are you sure you want to delete it?".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: kOKBtnTitle, style: .default) { action in
            var newparam = [String : AnyObject]()
            newparam["id"] = self.arrayMain[sender.tag]["id"]
            self.showLoading()
            NetworkManager.post("user/address/destroy", isLoading: true, withParams: newparam, onView: self) { (MainData) in
                self.hideLoading()
                self.ShowSuccessAlertWithNoAction(message: "Address deleted successfully!".localized)
                self.arrayMain.remove(at: sender.tag)
                self.TBL_Address_Book.reloadData()
            }
        })
        alert.addAction(UIAlertAction(title: kCancelBtnTitle, style: .cancel) { action in
             alert.dismiss(animated: true, completion: nil)
        })
        
        self.present(alert, animated: true, completion: nil)
       
    }
    
    func tableView(_ tableView: UITableView , heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isChoose {
            delegate?.SelectedAddress(address: self.arrayMain[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }else {
            
        }
    }
}
