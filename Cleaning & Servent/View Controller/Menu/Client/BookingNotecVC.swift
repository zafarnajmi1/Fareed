//
//  BookingNotecVC.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 4/5/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class BookingNotecVC: BaseViewController, UITableViewDelegate , UITableViewDataSource{

    @IBOutlet weak var txtwritesomething: UITextField!
    @IBOutlet weak var btnsend: UIButton!
    @IBOutlet weak var lblBookingNote: UILabel!
    @IBOutlet weak var imgViewBack: UIImageView!
    @IBOutlet weak var bottom_view: UIView!
    @IBOutlet weak var bottom_view_hight: NSLayoutConstraint!
    @IBOutlet weak var TF_Notes: UITextField!
    var bookign_id : String?
    var notes_Array = [[String : AnyObject]]()
    @IBOutlet weak var TBL_notes: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isArabic() {
            self.txtwritesomething.textAlignment = .right
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
        }
        txtwritesomething.placeholder = "Write Note".localized
        btnsend.setTitle("SEND".localized, for: .normal)
        lblBookingNote.text = "Booking Notes".localized
        
        self.TBL_notes.register(UINib(nibName: "NoteCell", bundle: nil), forCellReuseIdentifier: "NoteCell")
        
        if !self.isCompony(){
            self.bottom_view_hight.constant = 0
            self.bottom_view.isHidden = true
        }
        self.ApiCall()
    }

    func ApiCall() {
        var param = [String : AnyObject]()
        param["booking_id"] = self.bookign_id as AnyObject
        self.showLoading()
        NetworkManager.getWithPArams("user/booking/notes", isLoading: true, withParams: param, onView: self) { (response) in
            print(response)
            self.hideLoading()
            if let array = response?["data"] as? [[String : AnyObject]]{
                self.notes_Array = array
                self.TBL_notes.reloadData()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func OnClickSend(_ sender: Any) {
        if self.isCompony(){
            if !self.TF_Notes.text!.isEmpty {
                var param = [String : AnyObject]()
                param["booking_id"] = self.bookign_id as AnyObject
                param["note"] = self.TF_Notes.text as AnyObject
                self.showLoading()
                NetworkManager.post("user/booking/add-note", isLoading: true, withParams: param, onView: self, hnadler: { (Response) in
                    self.hideLoading()
                    if(Response?["status_code"] as! Int  == 200){
                        print(Response)
                        self.ApiCall()
                        self.TF_Notes.text = ""
                        self.TF_Notes.resignFirstResponder()
                        self.ShowSuccessAlert(message: Response?["message"] as! String )
                        
                    }else{
                        self.hideLoading()
                        self.ShowErrorAlert(message: Response?["message"] as! String )
                    }
                    
                    
//                    print(Response)
//                    self.ApiCall()
//                    self.TF_Notes.text = ""
//                    self.TF_Notes.resignFirstResponder()
                    
                })
            }
            else{
                
            }
        }else{
            self.ShowErrorAlert(message: "You are not able to Add Booking Notes!")
        }
      
    }
   
    @IBAction func Back_Action(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.notes_Array.count > 0 {
            return self.notes_Array.count
        }
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "NoteCell") as! NoteCell
        cell.selectionStyle = .none
        if self.notes_Array.count > 0 {
            cell.Lbl_text.text = self.notes_Array[indexPath.row]["note"] as? String ?? ""
            let url =  (self.notes_Array[indexPath.row]["company"] as! [String : Any])["image"] as? String ?? ""
            cell.Img_user.sd_setImage(with: URL.init(string: url), placeholderImage: #imageLiteral(resourceName: "profile_placeholder"))
        }
        return cell
    }

}
