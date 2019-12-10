//
//  ImageExtension.swift
//  Wave
//
//  Created by MAC MINI on .
//  Copyright © 2018. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
	
	func dropShadow(scale: Bool = true) {

		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowOpacity = 0.5
		self.layer.shadowOffset = CGSize.zero
		self.layer.shadowRadius = 2
		
		
	}
    
    
    func DropRightShadow(){
        self.layer.shadowColor = UIColor.black.cgColor;
        self.layer.shadowOffset = CGSize.init(width: 10, height: 10)
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 2.0;
    }
    
    
    func CellDropShadow(scale: Bool = true) {
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 3
        
        
    }
	
	
	func CornerRadious()  {
		self.layer.borderWidth = 1;
		self.layer.cornerRadius = self.frame.height / 2
		self.layer.borderColor = UIColor.clear.cgColor
		self.clipsToBounds = true
		self.layer.masksToBounds = false
	}
    
    
    func CornerRadiousWithRadious(radious : CGFloat)  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = radious
        self.layer.borderColor = UIColor.clear.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
}


