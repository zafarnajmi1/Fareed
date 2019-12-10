//
//  AboutUsVC.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 3/17/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class AboutUsVC: BaseViewController {

    @IBOutlet weak var TV_data: UITextView!
    
    @IBOutlet weak var imgViewBack: UIImageView!
    @IBOutlet weak var lbl_Heading: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
            self.TV_data.textAlignment = .right
        }
        self.lbl_Heading.text = "About Us".localized
        self.showLoading()
        NetworkManager.get("settings", isLoading: true, onView: self) { (response) in
            print(response)
            self.hideLoading()
            if let data = response?["data"] as? [String:Any] {
                if let pages = data["pages"] as? [String:Any] {
                    if let about_us = pages["about_us"] as? [String : Any],  let about_us_2 = pages["about_2_paragraph"] as? [String : Any]{
                        if let about_us_content = about_us["content"] as? String , let about_us_2_content =  about_us_2["content"] as? String{
                            
                            let result = NSMutableAttributedString()
                            result.append(about_us_content.html2AttributedString1!)
                            result.append(about_us_2_content.html2AttributedString1!)
//                            self.TV_data.attributedText = result
                            
                            self.TV_data.text = result.string
                            
//                            var result = ""
//                            result = about_us_content.removeHTMLTAG()
//                            result += about_us_2_content.removeHTMLTAG()
////                            self.TV_data.attributedText = result
//                            self.TV_data.text = result
                            
                            
                            
                            //about_us_content.html2AttributedString1! + about_us_2_content.html2AttributedString1!
//                            let content = about_us_content + about_us_2_content
//                            let data = Data(content.utf8)
//                            if let contents = String(data: data, encoding: .ascii){
//                                let attributedString = try! NSAttributedString(data: contents.data(using: .utf8
//                                    )!, options: [NSAttributedString.DocumentReadingOptionKey.documentType :NSAttributedString.DocumentType.html], documentAttributes: nil)
//                                //                    self?.txt_tnc.attributedText = attributedString
//                                self.TV_data.attributedText = attributedString
//                            }
                            
                            
//                            self.TV_data.text = about_us_content.removeHTMLTAG() + about_us_2_content.removeHTMLTAG()
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
