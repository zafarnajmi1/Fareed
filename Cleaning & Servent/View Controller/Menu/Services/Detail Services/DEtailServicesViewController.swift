//
//  DEtailServicesViewController.swift
//  Cleaning & Servent
//
//  Created by waseem on 23/04/2018.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class DEtailServicesViewController: BaseViewController , UITableViewDelegate , UITableViewDataSource {

//    @IBOutlet var lblNAme : UILabel!
//    @IBOutlet var txtViewMain : UITextView!
//    @IBOutlet var txtViewInclude : UITextView!
//    @IBOutlet var txtViewNotInclude : UITextView!
//    @IBOutlet var imgviewMain : UIImageView!
    
    @IBOutlet weak var lblservices: UILabel!
    @IBOutlet weak var imgViewBack: UIImageView!
    @IBOutlet var tbleviewMain : UITableView!
    
    var chooseService = [String : Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
        }
        lblservices.text = "Services".localized
        self.tbleviewMain.register(UINib(nibName: "ServicesImageCell", bundle: nil), forCellReuseIdentifier: "ServicesImageCell")
        self.tbleviewMain.register(UINib(nibName: "ServicesHeadingCell", bundle: nil), forCellReuseIdentifier: "ServicesHeadingCell")

        self.tbleviewMain.register(UINib(nibName: "ServicesDiscCell", bundle: nil), forCellReuseIdentifier: "ServicesDiscCell")


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func OnClicBack(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(self.chooseService)
        
//        let translation = self.chooseService["translation"] as! [String : Any]
        
//        self.lblNAme.text = translation["title"] as? String
//        self.txtViewMain.text = translation["description"] as? String
//        self.txtViewInclude.text = translation["included"] as? String
//        self.txtViewNotInclude.text = translation["not_included"] as? String
//        self.imgviewMain.sd_setImage(with: URL.init(string: self.chooseService["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let translation = self.chooseService["translation"] as! [String : Any]
        
        
        if indexPath.row == 0 {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "ServicesImageCell") as! ServicesImageCell
            
            cell.imgViewMain.sd_setImage(with: URL.init(string: self.chooseService["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 1  { //|| indexPath.row == 3 || indexPath.row == 5
//            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "ServicesHeadingCell") as! ServicesHeadingCell

            let cell  = tableView.dequeueReusableCell(withIdentifier: "ServicesHeadingCell") as! ServicesHeadingCell

            if indexPath.row == 1 {
                cell.lblHEading.text = translation["title"] as? String
            }
//            else if indexPath.row == 3 {
//                cell.lblHEading.text = "This Services Includes".localized
//            }else if indexPath.row == 5 {
//                cell.lblHEading.text = "What Does This Services Not Include".localized
//            }
            
            cell.selectionStyle = .none
            return cell
            
        }else {
//            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "ServicesDiscCell") as! ServicesDiscCell
            
            let cell  = tableView.dequeueReusableCell(withIdentifier: "ServicesDiscCell") as! ServicesDiscCell

            
            if indexPath.row == 2 {
                //cell.lblTextMain.text = translation["description"] as? String
                cell.lblTextMain.text = (translation["description"] as! String).replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
            }
//            else if indexPath.row == 4 {
//                cell.lblTextMain.text = (translation["included"] as! String).replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
//
////                cell.lblTextMain.text = (translation["included"] as! String).stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
//            }else {
//                cell.lblTextMain.text = (translation["not_included"] as! String).replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
//            }
            
            cell.selectionStyle = .none
            return cell
            
        }
        
//            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "EmployeeCell")
//            let myItem = self.mainEmployee[indexPath.row]
        
//            cell.textLabel?.text = myItem["full_name"] as? String
        
            
        
//            cell.selectionStyle = .none
//            return cell
        }
        
        
    
}


class ServicesImageCell : UITableViewCell {
    @IBOutlet var imgViewMain : UIImageView!
}


class ServicesHeadingCell : UITableViewCell {
    @IBOutlet var lblHEading : UILabel!
}


class ServicesDiscCell : UITableViewCell {
    @IBOutlet var lblTextMain : UILabel!
}

