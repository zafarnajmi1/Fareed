//
//  ServicesCell.swift
//  Servent
//
//  Created by MAC MINI on .
//  Copyright © 2018. All rights reserved.
//

import UIKit

class ServicesCell: UICollectionViewCell {

    
    
    
    @IBOutlet weak var main_view: RoundView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var rightView: UIView!
    
    @IBOutlet weak var check_box_img: UIImageView!
    @IBOutlet weak var service_name: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
