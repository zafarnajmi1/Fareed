//
//  CleanerReviewsVC.swift
//  Fareed
//
//  Created by Asif Habib on 27/09/2019.
//  Copyright © 2019 Jaidee. All rights reserved.
//

import UIKit

class CleanerReviewsVC: BaseViewController {
    
    @IBOutlet weak var lbl_HEading: UILabel!
    @IBOutlet weak var imgViewBAck: UIImageView!
    @IBOutlet weak var tbl_reviews : UITableView!
    
    var reviews : [[String : Any]] = []
    var screenTitle : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isArabic() {
            self.imgViewBAck.image = #imageLiteral(resourceName: "backArabic")
        }
        tbl_reviews.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
        tbl_reviews.register(UINib(nibName: "NoREviewCell", bundle: nil), forCellReuseIdentifier: "NoREviewCell")
        
        
        setupTexts()
        
        // Do any additional setup after loading the view.
    }
    func setupTexts(){
        lbl_HEading.text = screenTitle
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onClick_back(_ sender : Any){
        navigationController?.popViewController(animated: true)
    }

}
extension CleanerReviewsVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count == 0 ? 1 : reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if reviews.count == 0{
            return tableView.dequeueReusableCell(withIdentifier: "NoREviewCell")!
            
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewCell
            
            let data = reviews[indexPath.row]
            
            let user = data["user"] as! [String : Any]
            
            cell.IMG_userimg.sd_setImage(with: URL.init(string: (user["image"] as? String)!), completed: nil)
            cell.LBL_Username.text = user["full_name"] as? String
            cell.LBL_date.text =  (data["updated_at"] as? String )?.ConvertTODate()
            cell.LBL_Review_detail.text =  data["review_text"] as? String
            if let averageRatting = data["rating"] as? Double {
                //            cell.lblRating.text = String(format: "%.2f", averageRatting)
                cell.LBL_Rating_Count.text =  String(format: "%.1f", averageRatting)
                cell.cv_rating.rating = averageRatting
                //                cell.cv.text =  String(format: "%.2f", averageRatting)
            }
            return cell
        }
        
        
    }
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
   
    
    
}
