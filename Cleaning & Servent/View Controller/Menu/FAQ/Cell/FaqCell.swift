//
//  FaqCell.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 3/18/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class FaqCell: UITableViewCell {
    @IBOutlet weak var LBL_Title: UILabel!
    @IBOutlet weak var Img_arrow: UIImageView!
    @IBOutlet weak var TV_detail: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
