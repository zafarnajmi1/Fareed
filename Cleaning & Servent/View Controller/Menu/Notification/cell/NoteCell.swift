//
//  NoteCell.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 4/5/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {

    @IBOutlet weak var Img_user: CircularImageView!
    @IBOutlet weak var Lbl_text: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
