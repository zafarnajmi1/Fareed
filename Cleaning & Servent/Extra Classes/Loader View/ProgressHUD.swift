//
//  ProgressHUD.swift
//  Fareed
//
//  Created by Afrah Tayyab on 11/5/19.
//  Copyright © 2019 Jaidee. All rights reserved.
//
import Foundation

import UIKit
import MBProgressHUD

class ProgressHUD: MBProgressHUD {
    
    private static var sharedView: ProgressHUD!
    
    @discardableResult
    func mode(mode: MBProgressHUDMode) -> ProgressHUD {
        self.mode = mode
        return self
    }
    
    @discardableResult
    func animationType(animationType: MBProgressHUDAnimation) -> ProgressHUD {
        self.animationType = animationType
        return self
    }
    
   
    class func progress(text: String)  {
        ProgressHUD.sharedView.label.text = text
    }
    
    @discardableResult
    func backgroundViewStyle(style: MBProgressHUDBackgroundStyle) -> ProgressHUD {
        self.backgroundView.style = style
        return self
    }
    
    @discardableResult
    class func present(animated: Bool) -> ProgressHUD {
        if sharedView != nil {
            sharedView.hide(animated: false)
        }
        if let view = UIApplication.shared.keyWindow {
            sharedView = ProgressHUD.showAdded(to: view, animated: true)
        }
        return sharedView
    }
    
    
    class func dismiss(animated: Bool) {
        if sharedView != nil {
            sharedView.hide(animated: true)
        }
    }
    
}







//
//class Loader {
//    //static let shared = Loader()
//
//    private static let hud = MBProgressHUD
//
//    class func showLoader(view: UIView , blockUI: Bool = false) {
//        hud.interactionType = .blockNoTouches
//        hud.vibrancyEnabled = false
//        hud.indicatorView = JGProgressHUDRingIndicatorView()
//        hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.2)
//        hud.detailTextLabel.text = "Loading"
//        hud.textLabel.text = "Please wait"
//        hud.show(in: view)
//
//        if blockUI {
//            hud.interactionType = .blockAllTouches
//            hud.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
//        }
//
//    }
//
//    class func progress(count : Int) {
//
//        hud.progress = Float(count)/100.0
//        hud.detailTextLabel.text = "\(count)% Complete"
//    }
//
//    class func hideLoader() {
//        self.hud.dismiss()
//    }
//}
