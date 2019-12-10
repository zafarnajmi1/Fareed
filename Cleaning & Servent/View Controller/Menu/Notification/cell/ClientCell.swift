//
//  ClientCell.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 4/3/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class ClientCell: UITableViewCell {

    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblPhone : UILabel!
    @IBOutlet var imgViewMain : UIImageView!
    
    //for localization:
    @IBOutlet weak var lbl_PhoneHeading: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lbl_PhoneHeading.text = "Phone:".localized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


class ClientReviewCell: UITableViewCell {
    
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblPhone : UILabel!
    @IBOutlet var imgViewMain : UIImageView!
    
    @IBOutlet weak var lbl_PhoneHeading: UILabel!
    @IBOutlet weak var lbl_RateThisCleanerHeading: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lbl_PhoneHeading.text = "Phone:".localized
        lbl_RateThisCleanerHeading.text = "Rate This Cleaner".localized
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

