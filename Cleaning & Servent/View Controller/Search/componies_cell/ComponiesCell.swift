//
//  ComponiesCell.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 3/17/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class ComponiesCell: UITableViewCell {
    @IBOutlet weak var Detail_view: UIView!
    @IBOutlet weak var Constraint_Detail_view_height: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func ExpandDetailView() {
       self.Set_View(view: self.Detail_view, hidden: false)
    }
    
    func CloseDetailView() {
        self.Set_View(view: self.Detail_view, hidden: true)
    }
    
    func Set_View(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
}
