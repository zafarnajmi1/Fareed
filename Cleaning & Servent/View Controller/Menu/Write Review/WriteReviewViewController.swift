//
//  WriteReviewViewController.swift
//  Cleaning & Servent
//
//  Created by waseem on 28/04/2018.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit
import Cosmos

class WriteReviewViewController: BaseViewController, UITextViewDelegate {

    @IBOutlet var ratingView : CosmosView!
    @IBOutlet var txtViewMain : UITextView!
    
    @IBOutlet weak var imgViewBack: UIImageView!
    var isEmployeRating = false
    var mainData = [String : Any]()
    
    let PlaceHolderText = "Write something..."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
        }
        
        self.txtViewMain.text = PlaceHolderText
        self.txtViewMain.textColor = UIColor.lightGray
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func BackButton(){
        self.navigationController?.popViewController(animated: true)
    }

    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == PlaceHolderText {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = PlaceHolderText
            textView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func AddComment(sender : UIButton){
        self.txtViewMain.resignFirstResponder()
        
        if self.txtViewMain.text.count == 0 || self.txtViewMain.text == PlaceHolderText {
            self.ShowErrorAlert(message: "Please enter review")
            return
        }
        
        
        if self.ratingView.rating < 1.0 {
            self.ShowErrorAlert(message: "Give rating")
            return
        }
        
        
        var paramNew = [String : AnyObject]()
        paramNew["rating"] = String(self.ratingView.rating) as AnyObject
        paramNew["review_text"] = self.txtViewMain.text as AnyObject
        var urlMain = "user/reviews/store"
        if self.isEmployeRating {
            urlMain = "user/reviews/add-employee-reviews"
            paramNew["booking_id"] = String(self.mainData["booking_id"] as! Int) as AnyObject
            paramNew["employee_id"] = String(self.mainData["employee_id"] as! Int) as AnyObject
            paramNew["service_id"] = String(self.mainData["service_id"] as! Int) as AnyObject
        }else {
            paramNew["booking_id"] = String(self.mainData["id"] as! Int) as AnyObject
        }
        
        
        
        self.showLoading()
        NetworkManager.post(urlMain, isLoading: true, withParams: paramNew, onView: self) { (mainData) in
            print(mainData)
            self.hideLoading()
            
            if (mainData?["status_code"] as! Int)  == 200 {
                self.ShowSuccessAlert(message: (mainData?["message"] as! String))
                
            }else {
                self.hideLoading()
                self.ShowErrorAlert(message: (mainData?["message"] as! String))
            }
        }
    }
}
