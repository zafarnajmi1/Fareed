//
//  EmployeeCell.swift
//  Fareed
//
//  Created by Asif Habib on 01/10/2019.
//  Copyright © 2019 Jaidee. All rights reserved.
//

import UIKit

class EmployeeCell: UITableViewCell {
    
    @IBOutlet weak var img_check: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
