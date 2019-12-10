//
//  BookingDetailCell.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 4/4/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class BookingDetailCell: UITableViewCell {

    @IBOutlet var lblIDTop : UILabel!
    @IBOutlet var lblDate : UILabel!
    @IBOutlet var lblStarttime : UILabel!
    @IBOutlet var lblPrice : UILabel!
    
    //for localization...
//    @IBOutlet weak var lbl_startTime: UILabel!
    @IBOutlet weak var lbl_Booking: UILabel!
    @IBOutlet weak var lbl_BookingTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lbl_Booking.text = "Booking :".localized
        lbl_BookingTime.text = "Booking Time :".localized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
