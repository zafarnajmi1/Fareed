//
//  AddressBookCell.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 3/17/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class AddressBookCell: UITableViewCell {

    @IBOutlet var lblHeading : UILabel!
    @IBOutlet var lblAddress : UILabel!
    
    @IBOutlet var btnDelete : UIButton!
    @IBOutlet var btnEdit : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
