//
//  TestimonialVC.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 3/17/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class TestimonialVC: BaseViewController ,UITableViewDelegate , UITableViewDataSource {
    @IBOutlet weak var tabel_view: UITableView!
    @IBOutlet weak var imgViewBAck: UIImageView!
    
    @IBOutlet weak var lbl_Heading: UILabel!
    
    var arrayMain = [[String : Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isArabic() {
            self.imgViewBAck.image = #imageLiteral(resourceName: "backArabic")
        }
        self.lbl_Heading.text = "Testimonial".localized
         self.tabel_view.register(UINib(nibName: "TestimonialCell", bundle: nil), forCellReuseIdentifier: "TestimonialCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.APICAllforTestimonial()
    }
    
    func APICAllforTestimonial(){
        self.arrayMain.removeAll()
        self.showLoading()
        NetworkManager.get("testimonials", isLoading: true, onView: self) { (mainData) in
            print(mainData)
            self.hideLoading()
            if (mainData?["status_code"] as! Int) == 200 {
                self.arrayMain = mainData?["data"] as! [[String : Any]]
            } else {
                self.hideLoading()
            }
            
            self.tabel_view.reloadData()
        }
    }
    @IBAction func Back(_ sender: Any) {
        self.Back()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.arrayMain.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "TestimonialCell") as! TestimonialCell
        let mainData = self.arrayMain[indexPath.row]["translation"] as! [String : Any]
        cell.lblNAme.text = mainData["name"] as? String
        cell.lblText.text = mainData["detail"] as? String
        let date = self.arrayMain[indexPath.row]["updated_at"] as! Double
        cell.lblTime.text = ("\(date)").ConvertTODate()
        cell.userImage.sd_setImage(with: URL.init(string: self.arrayMain[indexPath.row]["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)

        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
