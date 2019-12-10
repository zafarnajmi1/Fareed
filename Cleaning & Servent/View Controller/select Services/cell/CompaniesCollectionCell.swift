//
//  CompaniesCollectionCell.swift
//  Cleaning & Servent
//
//  Created by Jawad on 4/23/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class CompaniesCollectionCell: UICollectionViewCell {
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblServicecount: UILabel!
    @IBOutlet var lblRate: UILabel!
    @IBOutlet var lblWorkHour: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var imgviewMain: UIImageView!
    @IBOutlet var imgviewStar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
