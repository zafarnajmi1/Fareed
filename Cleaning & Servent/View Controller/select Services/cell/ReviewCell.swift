//
//  ReviewCell.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 4/5/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit
import Cosmos
class ReviewCell: UITableViewCell {

    @IBOutlet weak var IMG_userimg: UIImageView!
    @IBOutlet weak var LBL_Review_detail: UILabel!
    @IBOutlet weak var LBL_Rating_Count: UILabel!
//    @IBOutlet weak var IMG_Starts: UIImageView!
    @IBOutlet weak var cv_rating: CosmosView!
    @IBOutlet weak var LBL_date: UILabel!
    @IBOutlet weak var LBL_Username: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
