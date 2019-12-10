//
//  HistoryCell.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 3/17/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet var imgvieWMain : UIImageView!
    
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblDate : UILabel!
    @IBOutlet var lblStartTime : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
