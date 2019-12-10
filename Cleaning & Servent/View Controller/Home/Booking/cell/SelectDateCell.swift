//
//  SelectDateCell.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 3/29/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class SelectDateCell: UICollectionViewCell {
    @IBOutlet weak var selected_view: UIView!
    
    @IBOutlet weak var lbl_day_name: UILabel!
    @IBOutlet weak var lbl_mnth: UILabel!
    @IBOutlet weak var lbl_day_number: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func Select() {
        self.selected_view.isHidden = false
        let color = UIColor.init(red: 96/255, green: 175/255, blue: 85/255, alpha: 1.0)
        self.lbl_day_number.textColor = color
         self.lbl_mnth.textColor = color
         self.lbl_day_name.textColor = color
    }
    
    func UnSelect() {
        self.selected_view.isHidden = true
        let color = UIColor.darkGray
        self.lbl_day_number.textColor = color
        self.lbl_mnth.textColor = color
        self.lbl_day_name.textColor = color
        self.lbl_mnth.text = ""
    }

}
