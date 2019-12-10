//
//  BorderImageview.swift
//  BaseProject
//
//  Created by MAC MINI on .
//  Copyright © 2018. All rights reserved.
//

import UIKit

@IBDesignable
class BorderImageView: UIImageView {
	
	
	@IBInspectable var borderWidth: CGFloat = 2.0 {
		didSet {
			layer.borderWidth = borderWidth
		}
	}
	
	@IBInspectable var borderColor: UIColor = UIColor.white {
		didSet {
			layer.borderColor = borderColor.cgColor
			updateView()
		}
	}
	
	@IBInspectable var borderRadious: CGFloat = 5.0 {
		didSet {
			layer.cornerRadius = borderRadious
		}
	}
	
	func updateView() {
	
		self.layer.borderWidth = borderWidth;
		self.layer.cornerRadius = borderRadious
		self.layer.borderColor = borderColor.cgColor
		self.clipsToBounds = true
		self.layer.masksToBounds = true
		
	}
		
	
}

@IBDesignable
class Border_ButtonView: UIButton {
    
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
            updateView()
        }
    }
    
    @IBInspectable var borderRadious: CGFloat = 5.0 {
        didSet {
            layer.cornerRadius = borderRadious
        }
    }
    
    func updateView() {
        
        self.layer.borderWidth = borderWidth;
        self.layer.cornerRadius = borderRadious
        self.layer.borderColor = borderColor.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        
    }
    
    
}

@IBDesignable
class Border_View: UIView {
    
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
            updateView()
        }
    }
    
    @IBInspectable var borderRadious: CGFloat = 5.0 {
        didSet {
            layer.cornerRadius = borderRadious
        }
    }
    
    func updateView() {
        
        self.layer.borderWidth = borderWidth;
        self.layer.cornerRadius = borderRadious
        self.layer.borderColor = borderColor.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        
    }
}

extension UIImage{
    func toBase64() -> String{
        let imageData = self.pngData()
        return (imageData?.base64EncodedString(options: .lineLength64Characters))!
    }
}

