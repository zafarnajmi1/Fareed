//
//  ComponiesFoldingCell.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 3/18/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class ComponiesFoldingCell:  FoldingCell {
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblServicecount: UILabel!
    @IBOutlet var lblRate: UILabel!
    @IBOutlet var lblWorkHour: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var lblPerHour: UILabel!
    @IBOutlet var lblAboutUs: UILabel!
    
    @IBOutlet var lblDescription: UILabel!
//    @IBOutlet weak var lblPerMeterRate: UILabel!
//    @IBOutlet weak var lblPerMeterText: UILabel!
//    @IBOutlet weak var lblPerMeterTopRate: UILabel!
//    @IBOutlet weak var lblPerMeterTopText: UILabel!
    
    
    @IBOutlet weak var workingHours: UILabel!
    
    var dataCompany = [String : Any]()
    
    
    @IBOutlet var imgviewMain: UIImageView!
    @IBOutlet var imgviewStar: UIImageView!
    
    @IBOutlet var lblPerHourTop: UILabel!
    @IBOutlet var lblNameTop: UILabel!
    @IBOutlet var lblRateTop: UILabel!
    @IBOutlet var lblWorkHourTop: UILabel!
    @IBOutlet var lblRatingTop: UILabel!
    @IBOutlet var btnDEtail: UIButton!
    
    
    @IBOutlet var imgviewMainTop: UIImageView!
    @IBOutlet var imgviewStarTop: UIImageView!
    
    override func awakeFromNib() {
        self.lblAboutUs.text = "About Us".localized
        self.btnDEtail.setTitle("VIEW DETAIL".localized, for: .normal)
        
        self.lblwork.text = "Working Hour".localized
        self.lblPerHourTop.text = "Per Hour".localized
        self.lblPerHour.text = "Per Hour".localized
        self.workingHours.text = "Working Hour".localized
        foregroundView.layer.cornerRadius = 1
        foregroundView.layer.shadowColor = UIColor.lightGray.cgColor
        foregroundView.layer.shadowOpacity = 0.1
        foregroundView.layer.borderWidth = 0.5
        foregroundView.layer.borderColor = UIColor.init(red: 140/255, green: 140/255, blue: 140/255, alpha: 0.1).cgColor
        foregroundView.layer.shadowRadius = 1
        foregroundView.layer.masksToBounds = false
        super.awakeFromNib()
    }
    
    @IBOutlet var lblwork: UILabel!
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    
    @IBAction func OnClickDetails(_ sender: Any) {
        baseVC?.PushCompanyDetail(name: "ComponyDetailVC", dataMain: self.dataCompany)        
    }
    
    
}

// MARK: - Actions ⚡️
extension ComponiesFoldingCell {
    
    
    
    @IBAction func buttonHandler(_: AnyObject) {
        print("tap")
    }
}

