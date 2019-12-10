//
//  FaqVC.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 3/18/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class FaqVC: BaseViewController ,UITableViewDelegate , UITableViewDataSource {
    @IBOutlet weak var tabel_view: UITableView!
    @IBOutlet weak var lbl_Heading: UILabel!
    
    @IBOutlet weak var imgViewBack: UIImageView!
    var isExpanable  = false
    var expanded_cell : [Int] = []
    var data : [[String : String]] = [[String : String]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
            self.lbl_Heading.textAlignment = .right
        }else{
            self.lbl_Heading.textAlignment = .left
        }
        
        self.lbl_Heading.text = "FAQ".localized
        self.tabel_view.register(UINib(nibName: "FaqCell", bundle: nil), forCellReuseIdentifier: "FaqCell")
        self.showLoading()
        NetworkManager.get("settings", isLoading: true, onView: self) { (response) in
            print(response)
            self.hideLoading()
            if let data = response?["data"] as? [String:Any] {
                if let faqs = data["faqs"] as? [[String:Any]]{
                    for faq in faqs{
                        if let data_faq = faq["translation"] as? [String : Any] {
                            self.data.append(["heading" : data_faq["title"] as! String ,
                                              "details" : data_faq["detail"] as! String ])
                        }
                    }
                    self.tabel_view.reloadData()
                }
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Back(_ sender: Any) {
        self.Back()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.expanded_cell.contains(indexPath.row){
            return UITableView.automaticDimension
        }else{
           return 54
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "FaqCell") as! FaqCell
        cell.selectionStyle = .none
        cell.TV_detail.attributedText = (self.data[indexPath.row]["details"] as! String).html2AttributedString
         cell.LBL_Title.text = self.data[indexPath.row]["heading"]
        if self.isArabic() {
           cell.LBL_Title.textAlignment = .right
           cell.TV_detail.textAlignment = .right
        }else{
           cell.LBL_Title.textAlignment = .left
           cell.TV_detail.textAlignment = .left
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FaqCell
        if self.expanded_cell.contains(indexPath.row){
            self.expanded_cell.remove(at: self.expanded_cell.index(of: indexPath.row)!)
            cell.Img_arrow.image = #imageLiteral(resourceName: "dropdown")
        }else{
            self.expanded_cell.append(indexPath.row)
              cell.Img_arrow.image = #imageLiteral(resourceName: "dropUp")
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    
}


extension String {
    var html2AttributedString: NSAttributedString? {
        do {
            let str = try NSAttributedString(data: self.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
            
            return str
        } catch {
            print(error)
            return NSAttributedString.init(string: "")
        }
    }
    var html2AttributedString1: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8),
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    var html2String: String {
        return html2AttributedString1?.string ?? ""
    }
//    var html2String: String {
//        return html2AttributedString?.string ?? ""
//    }
}

//extension String {
//    var htmlToAttributedString: NSAttributedString? {
//        guard let data = data(using: .utf8) else { return NSAttributedString() }
//        do {
//            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
//        } catch {
//            return NSAttributedString()
//        }
//    }
//    var htmlToString: String {
//        return htmlToAttributedString?.string ?? ""
//    }
//}

