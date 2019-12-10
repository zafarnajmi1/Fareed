//
//  TestimonialCell.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 3/17/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class TestimonialCell: UITableViewCell {

    @IBOutlet var userImage : UIImageView!
    @IBOutlet var lblNAme : UILabel!
    @IBOutlet var lblText : UILabel!
    @IBOutlet var lblTime : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
