//
//  Extensions.swift
//  SaveMe
//
//  Created by MAC MINI on .
//  Copyright © 2018. All rights reserved.
//

import Foundation
import MBProgressHUD
import UIKit

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        return controller
    }
}


extension UIImage {
    
    func imageResize (sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
    
    
    func FindSize() -> Int{
       let imgData =  self.jpegData(compressionQuality: 1.0)
        //let imgData: NSData = NSData(data: UIImageJPEGRepresentation((self), 1)!)
        return Int(imgData!.count)

    }
}

extension UITextField {
    
    enum Direction {
        case Left
        case Right
    }
    
    
    
    func withImage(direction: Direction, image: UIImage, colorSeparator: UIColor, colorBorder: UIColor){
        
        
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        mainView.layer.cornerRadius = 5
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.layer.borderWidth = CGFloat(0)
        view.layer.borderColor = colorBorder.cgColor
        mainView.addSubview(view)
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 19.0, y: 10.0, width: 16, height: 16)
        view.addSubview(imageView)
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = colorSeparator
        // mainView.addSubview(seperatorView)
        
        if(Direction.Left == direction){ // image left
            seperatorView.frame = CGRect(x: 45, y: 0, width: 0, height: 40)
            self.leftViewMode = .always
            self.leftView = mainView
        } else { // image right
            seperatorView.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
            self.rightViewMode = .always
            self.rightView = mainView
        }
        
        self.layer.borderColor = colorBorder.cgColor
        self.layer.borderWidth = CGFloat(0.5)
        self.layer.cornerRadius = 3
    }
    
    func setPadding(left: CGFloat? = nil, right: CGFloat? = nil){
        if let left = left {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
            self.layer.cornerRadius = 3
            self.layer.borderWidth = 0.5
            self.layer.borderColor = UIColor.lightGray.cgColor
            self.clipsToBounds = true
        }
        
    }
    
}

//MARK:- UIView
extension UIView
{
    func roundCorners(corners:UIRectCorner, radius: CGFloat)
    {

        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    
    func CornerRadiousView()  {
        self.layer.cornerRadius = Constants.kCornerRaious
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
    }
    
    
    func DrawCorner()  {
//        self.layer.cornerRadius = Constants.kCornerRaious
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
    }
    
    
    func showLoading() {
        DispatchQueue.main.async {
           let hud = MBProgressHUD.showAdded(to: self, animated: true)
            hud.label.text = "Please wait".localized
        }
    }
    func hideLoading() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self, animated: true)
        }
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }
    func drawBorderWithColor(color:UIColor){
        self.layer.borderWidth = 2.0
        self.layer.borderColor = color.cgColor
    }
    func removeBorder() {
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
}

extension Date {
    func GetString(dateFormate : String) -> String{
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = dateFormate
        
        
//        let convertedDate = formatter.date(from: dateToConvert)
//        dateFormatterGet.timeZone = TimeZone(identifier: "UTC")
        
        return dateFormatterGet.string(from: self)
        
        
    }
	

    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: self)
    }
}

extension String {
    
    func removeHTMLTAG() -> String {
        let str = self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return str
    }
    
    func GetDateFormate() -> String {
        
        if self.count > 0 {
           
            
            if UInt64(self)! > 0 {
                let endIndex = self.index(self.endIndex, offsetBy: -3)
                let truncated = self.substring(to: endIndex)
                let date = Date(timeIntervalSince1970: Double(truncated)!)
                return date.GetString(dateFormate: "YYYY-MM-dd")
            }else {
               return "" 
            }
            
        }else {
            return ""
        }
    }
    
    static func timeFromDate(formate : String, date : Double) -> String {
        
//        print(self)
        let d = Date(timeIntervalSince1970: date)
        
        let dateFormatterGet = DateFormatter()
//        let tempFormate = formate + " Z"
        
        dateFormatterGet.dateFormat = formate
        
        
        //        let convertedDate = formatter.date(from: dateToConvert)
//        dateFormatterGet.timeZone = TimeZone(identifier: "UTC")
        
        return dateFormatterGet.string(from: d)
        
        
//        if self.count > 0 {
//
//
//            if Int(self)! > 0 {
//                //                let endIndex = self.index(self.endIndex, offsetBy: -3)
//                //                let truncated = self.substring(to: endIndex)
//                let date = Date(timeIntervalSince1970: Double(self)!)
//                return date.GetString(dateFormate: value)
//            }else {
//                return ""
//            }
//
//        }else {
//            return ""
//        }
    }
    func GetTimeFormDate(value : String) -> String {
        
//        print(self)
        if self.count > 0 {
            
            
            if Int(self)! > 0 {
//                let endIndex = self.index(self.endIndex, offsetBy: -3)
//                let truncated = self.substring(to: endIndex)
                let date = Date(timeIntervalSince1970: Double(self)!)
                return date.GetString(dateFormate: value)
            }else {
                return ""
            }
            
        }else {
            return ""
        }
    }
        func setUnderline()->NSAttributedString{
            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
            let underlineAttributedString = NSAttributedString(string: self, attributes: underlineAttribute)
            
            return underlineAttributedString
        }
        func setUnderLineForSpecific(str:String)->NSAttributedString{
            //        let string              = "A great link : Google"
            let range               = (self as NSString).range(of: str)
            let attributedString    = NSMutableAttributedString(string: self)
            
            
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSNumber(value: 1), range: range)
            return attributedString
            
        }
    

}
extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
extension Dictionary {
    
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func printJson() {
        print(json)
    }
    
}
extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}


//extension Double {
//    var roundTo2f: Double {
//        return self(round(100 * self)/100)
//    }
//    var roundTo3f: Double {
//        return self(round(1000 * self)/1000)
//    }
//}

//Usage:
//
//let regularPie:  Double = 3.14159
//var smallerPie:  Double = regularPie.roundTo3f  // results 3.142
//var smallestPie: Double = regularPie.roundTo2f  // results 3.14
