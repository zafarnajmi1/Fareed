//
//  MenuHeaderCell.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 3/14/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit
import SDWebImage
protocol moveonLogin {
    func loginAction(cell:MenuHeaderCell)
}
class MenuHeaderCell: UITableViewCell {
    @IBOutlet weak var lbl_phone: UILabel!
    @IBOutlet weak var Lbl_name: UILabel!
    @IBOutlet weak var IMG_user: UIImageView!
    var delegate:moveonLogin?
    @IBOutlet weak var btnloginheaderaction: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUI() {
        //self.lbl_phone.text = "Please login for detail".localized
        
        if DataManager.sharedInstance.getPermanentlySavedUser() != nil {
            
            self.btnloginheaderaction.isHidden = true
            self.lbl_phone.text = DataManager.sharedInstance.getPermanentlySavedUser()?.mobile
            self.Lbl_name.text = DataManager.sharedInstance.getPermanentlySavedUser()?.full_name
            let url = URL.init(string: (DataManager.sharedInstance.getPermanentlySavedUser()?.image)!)
//            self.imgViewMain.sd_setImage(with: URL.init(string: self.companyInfo["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
            if DataManager.sharedInstance.getPermanentlySavedUser()?.user_type == "client" {
                self.IMG_user.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "greylogo"), completed: nil)
            }
            else{
                let url = URL(string: DataManager.sharedInstance.user?.CompanyProfileImage ?? "")
//                let company = DataManager.sharedInstance.user?.CompanyType
                self.IMG_user.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "greylogo"), completed: nil)
            }
            
            
        }else{
            self.btnloginheaderaction.isHidden = false
            self.btnloginheaderaction.setTitle("Please login for details".localized, for: .normal)
        }
    }
    @IBAction func LoginActionHeader(_ sender: UIButton) {
        self.delegate?.loginAction(cell: self)
//        let s = UIStoryboard(name: "Main", bundle: nil)
//        let vc = s.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true)
        
    }
    
}
