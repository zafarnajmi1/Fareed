//
//  TermsConditionVC.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 3/17/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit
import WebKit

class TermsConditionVC: BaseViewController {
  @IBOutlet weak var TV_data: UITextView!
    @IBOutlet weak var wk_web : WKWebView!
    @IBOutlet weak var lbl_Heading: UILabel!
    
    @IBOutlet weak var imgViewBack: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
        }
        self.lbl_Heading.text = "Terms & Conditions".localized
        self.showLoading()
        NetworkManager.get("settings", isLoading: true, onView: self) { (response) in
            print(response)
            self.hideLoading()
            if let data = response?["data"] as? [String:Any] {
                if let pages = data["pages"] as? [String:Any] {
                    if let about_us = pages["terms_and_conditions"] as? [String : Any]{
                        if let about_us_content = about_us["content"] as? String {
//                            let data = Data("terms_and_conditions".utf8)
//                            if let contents = String(data: data, encoding: .ascii){
//                                do {
//                                    let attributedString = try NSAttributedString(data: contents.data(using: .utf8
//                                    )!, options: [NSAttributedString.DocumentReadingOptionKey.documentType :NSAttributedString.DocumentType.html], documentAttributes: nil)
                            
                            
                                    self.TV_data.attributedText = about_us_content.html2AttributedString1
//                                }
//                                catch let error {
//                                    print("Parsing Error :\(error)")
//                                }
//                                //                    self?.txt_tnc.attributedText = attributedString
////                                self.TV_data.attributedText = attributedString
//                            }
                            
                            
                            
//                            let attrString = NSAttributedString (
//                                string: about_us_content,
//                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
//                            self.TV_data.text = about_us_content.removeHTMLTAG()
                        }
                    }
                }
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Back_Action(){
        self.navigationController?.popViewController(animated: true)
    }

}

