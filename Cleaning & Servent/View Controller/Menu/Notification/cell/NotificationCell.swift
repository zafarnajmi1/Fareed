//
//  NotificationCell.swift
//  Servent
//
//  Created by Jawad ali on 2/11/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var LBLTime: UILabel!
    @IBOutlet var imgViewMain : UIImageView!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblDescription : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
