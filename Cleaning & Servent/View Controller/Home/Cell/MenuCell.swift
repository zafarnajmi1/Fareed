//
//  MenuCell.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 3/14/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    @IBOutlet weak var IMG_icon: UIImageView!
    
    @IBOutlet weak var View_line: UIImageView!
    @IBOutlet weak var LBL_title: UILabel!
    @IBOutlet weak var LBL_notificationCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
