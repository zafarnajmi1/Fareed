//
//  BaseBlackCornerTextField.swift
//  BaseProject
//
//  Created by MAC MINI on .
//  Copyright © 2018. All rights reserved.
//

import UIKit
import ADEmailAndPassword
class BaseBlackCornerTextField: UITextField {

	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		//custom logic goes here
		self.cornerRadious()
	}
	
	func cornerRadious()  {
		self.backgroundColor = UIColor.white
		self.layer.cornerRadius = Constants.kCornerRaious
		self.layer.borderColor = UIColor.black.cgColor
		self.layer.borderWidth = 1
		self.layer.masksToBounds = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

}
