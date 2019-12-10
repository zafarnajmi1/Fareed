//
//  CleanerDetailCell.swift
//  Fareed
//
//  Created by Asif Habib on 25/09/2019.
//  Copyright © 2019 Jaidee. All rights reserved.
//

import UIKit

protocol CleanerDetailCellDelegate {
    func updateItem(object : CleanerInfoObj?)
}

class CleanerDetailCell: UITableViewCell {

    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    var obj : CleanerInfoObj?
    var delegate : CleanerDetailCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onClick_edit(_ sender: Any) {
        delegate?.updateItem(object: obj)
    }
    
    func loadCell(object : CleanerInfoObj ){
        obj = object
        lbl_title.text = object.title
        img_logo.image = UIImage(named: object.image!)
    }
    
}
