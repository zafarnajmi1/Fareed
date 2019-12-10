//
//  ServicesCell.swift
//  Fareed
//
//  Created by Asif Habib on 26/09/2019.
//  Copyright © 2019 Jaidee. All rights reserved.
//

import UIKit

class ServiceTableCell: UITableViewCell {

    @IBOutlet weak var main_view: RoundView!
    

    
    @IBOutlet weak var btn_check: UIButton!
    @IBOutlet weak var service_name: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func onClick_check(_ sender : Any){
    
    }
    
    func loadCell(){
        
    }
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
