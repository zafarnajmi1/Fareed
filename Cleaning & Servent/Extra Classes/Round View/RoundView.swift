//
//  SaveMeView.swift
//  SaveMe
//
//  Created by MAC MINI on .
//  Copyright © 2018. All rights reserved.
//

import UIKit

class RoundView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.cornerRadious()
    }
    
	func cornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.clear.cgColor
		self.clipsToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 2
//        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
		self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class GreenRoundView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.cornerRadious()
    }
    
     func cornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = self.frame.size.width/2
        self.layer.borderColor = UIColor.clear.cgColor
        self.clipsToBounds = true
        self.layer.shadowColor = UIColor.init(red: (105/255), green: (175/255), blue: (74/255), alpha: 1.0).cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 2
        //        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class BorderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.cornerRadious()
    }
    
     func cornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 1
        self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
class WhiteBoderButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.cornerRadious()
    }
    
    func cornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 2
        self.layer.borderColor = UIColor.white.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class TFLightGrayBorder: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.cornerRadious()
    }
    
     func cornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.clipsToBounds = true
        let paddingView = UIView(frame: CGRect.init(x: 0, y: 0, width: 10, height: 30))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
class RoundViewMessageUserCell: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.cornerRadious()
    }
    
   func cornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 0
        self.layer.borderColor = UIColor.clear.cgColor
        self.clipsToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: -0, height: 1)
        self.layer.shadowRadius = 1
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
class RoundViewAppointmentCell: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.cornerRadious()
    }
    
     func cornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 0
        self.layer.borderColor = UIColor.clear.cgColor
        self.clipsToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 2
        //        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
class RoundViewSimple: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.cornerRadious()
    }
    
     func cornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 3
        self.layer.borderColor = UIColor.clear.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
class RoundViewNotification: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.cornerRadious()
    }
    
     func cornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 3
        self.layer.borderColor = UIColor.clear.cgColor
        self.clipsToBounds = true
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        //        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
class RoundViewWithShadow: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cornerRadious()
    }
    
    
    func cornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 1
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 2
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
class RoundViewWithNoBorder: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cornerRadious()
    }
    
     func cornerRadious()  {
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
        self.layer.shadowRadius = 2
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
class RoundViewTopCornor: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.cornerRadious()
    }
    
     func cornerRadious()  {
        self.roundCorners(corners: [.topLeft, .topRight], radius: 5)
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
class RoundViewBottomCornor: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.cornerRadious()
    }
    
     func cornerRadious()  {
        self.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 5)
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class RoundWhiteCornerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.cornerRadious()
    }
    
     func cornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.gray.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//class StrainRoundView: UIView {
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        //custom logic goes here
//        self.CornerRadious()
//    }
//
//    override func CornerRadious()  {
//        self.layer.borderWidth = 1;
//        self.layer.cornerRadius = self.frame.size.height/2
//        self.layer.borderColor = UIColor.clear.cgColor
//        self.clipsToBounds = true
//        self.layer.masksToBounds = false
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//}


class RoundViewGrayBorder: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.cornerRadious()
    }
    
     func cornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 1
        self.layer.borderColor = UIColor.init(red: 207/255, green: 208/255, blue: 209/255, alpha: 1.0).cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
class RoundViewLightGrayBorder: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.cornerRadious()
    }
    
     func cornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//class Strainroundview: UIView {
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        //custom logic goes here
//        self.CornerRadious()
//    }
//
//    override func CornerRadious()  {
//        self.layer.borderWidth = 1;
//        self.layer.cornerRadius = 5
//        self.layer.borderColor = UIColor.init(red: (246/255), green: (195/255), blue: (80/255), alpha: 1.0).cgColor
//        self.clipsToBounds = true
//        self.layer.masksToBounds = false
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//}



class CircleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.cornerRadious()
    }
    
     func cornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.borderColor = UIColor.clear.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}



class RoundViewWithGrayBorder: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cornerRadious()
    }
    
     func cornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 1
        self.layer.borderColor = UIColor.init(red: (240/255), green: (240/255), blue: (240/255), alpha: 1.0).cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class LightGrayBorderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cornerRadious()
    }
    
     func cornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class GrayBorderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cornerRadious()
    }
    
     func cornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 1
        self.layer.borderColor = UIColor.gray.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
class HistoryView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cornerRadious()
    }
    
     func cornerRadious()  {
        self.layer.borderWidth = 0;
        self.layer.cornerRadius = 1
        self.layer.borderColor = UIColor.init(red: (170/255), green: (170/255), blue: (170/255), alpha: 0.5).cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.init(red: (170/255), green: (170/255), blue: (170/255), alpha: 0.5).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class GrayBorder: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.cornerRadious()
    }
    
     func cornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 0
        self.layer.borderColor = UIColor.init(red: (203/255), green: (204/255), blue: (205/255), alpha: 1.0).cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class GreenBorderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.cornerRadious()
    }
    
     func cornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = self.frame.size.width/2
        
        print(self.frame)
        self.layer.borderColor = UIColor.init(red: (105/255), green: (175/255), blue: (74/255), alpha: 1.0).cgColor
//        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class GrayRoundBorderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.cornerRadious()
    }
    
     func cornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.init(red: (203/255), green: (204/255), blue: (205/255), alpha: 1.0).cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


//extension UIView {
//    func DashBorder(){
//        
//        let color = UIColor.lightGray.cgColor
//        
//        let shapeLayer:CAShapeLayer = CAShapeLayer()
//        var frameSize = self.frame.size
////        frameSize.width = UIScreen.main.bounds.size.width - 20
//        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
//        
//        shapeLayer.bounds = shapeRect
//        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        shapeLayer.strokeColor = color
//        shapeLayer.lineWidth = 2
//        shapeLayer.lineJoin = kCALineJoinRound
//        shapeLayer.lineDashPattern = [6,3]
//        
//        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
//        
//        self.layer.addSublayer(shapeLayer)
//        
////        let viewBorder = CAShapeLayer()
////        print(self.frame)
////        viewBorder.strokeColor = UIColor.white.cgColor
////        viewBorder.lineDashPattern = [2, 2]
////        viewBorder.frame = self.frame
////        viewBorder.fillColor = nil
////        viewBorder.path = UIBezierPath(rect: self.frame).cgPath
////        self.layer.addSublayer(viewBorder)
//    }
//}


class DashedBorderView: UIView {
    
    let _border = CAShapeLayer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    func setup() {
        _border.strokeColor = UIColor.white.cgColor
        _border.fillColor = nil
        _border.lineDashPattern = [4, 4]
        self.layer.addSublayer(_border)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius:8).cgPath
        _border.frame = self.bounds
    }
}


class CircleLabelWhite: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.cornerRadious()
    }
    
     func cornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.borderColor = UIColor.white.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class ShadowImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.cornerRadious()
    }
    
     func cornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.clear.cgColor
        self.clipsToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 2
        //        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

