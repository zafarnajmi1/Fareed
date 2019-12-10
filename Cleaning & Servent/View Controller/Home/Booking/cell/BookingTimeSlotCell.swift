//
//  BookingTimeSlotCell.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 4/1/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class BookingTimeSlotCell: UITableViewCell {

    @IBOutlet weak var LBL_Avail: UILabel!
    @IBOutlet weak var Lbl_Time: UILabel!
    @IBOutlet weak var main_view: GrayBorder!
    override func awakeFromNib() {
        super.awakeFromNib()
        LBL_Avail.text = "Available".localized
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
