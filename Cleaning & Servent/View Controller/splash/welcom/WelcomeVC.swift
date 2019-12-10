//
//  WelcomeVC.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 4/8/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class WelcomeVC: BaseViewController ,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    var count : Int = 0
    var data  = [["title" : "Welcome to \n Fareed",
                  "text" : "",
                  "image" : #imageLiteral(resourceName: "appLogo")],
                 ["title" : "Step 1 \n Select Services",
                  "text" : "",
                  "image" : #imageLiteral(resourceName: "welcome_3")],
                 ["title" : "Step 2 \n Select Company",
                  "text" : "",
                  "image" : #imageLiteral(resourceName: "welcome_2")],
                 ["title" : "Step 3 \n Make Booking",
                  "text" : "",
                  "image" : #imageLiteral(resourceName: "welcom_1")]
                 ]
    @IBOutlet weak var collection_view: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width:self.collection_view.frame.width, height: self.collection_view.frame.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        self.collection_view!.collectionViewLayout = layout
         self.collection_view.register(UINib.init(nibName: "WelcomCell", bundle: nil), forCellWithReuseIdentifier: "WelcomCell")
    }
    @IBOutlet weak var Indicator: UIPageControl!
    @IBOutlet weak var Btn_start: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func OnClickLetsSrart(_ sender: Any) {
        if DataManager.sharedInstance.getPermanentlySavedUser()?.user_type == "company"{
            (UIApplication.shared.delegate as! AppDelegate).isRefreshAfterCancel = true
            self.PushView(nameViewController: "HistoryViewController", nameStoryBoard: "Main")
        }else {
            self.PushView(nameViewController: "HomeVC", nameStoryBoard: "Main")
        }
    }
    
    @IBAction func OnClickSkip(_ sender: Any) {
        if DataManager.sharedInstance.getPermanentlySavedUser()?.user_type == "company"{
            (UIApplication.shared.delegate as! AppDelegate).isRefreshAfterCancel = true
            self.PushView(nameViewController: "HistoryViewController", nameStoryBoard: "Main")
        }else {
             self.PushView(nameViewController: "HomeVC", nameStoryBoard: "Main")
        }
    }
    
    @IBAction func OnClickNext(_ sender: Any) {
        if Indicator.currentPage != 3 {
            self.collection_view.scrollToItem(at: IndexPath.init(row: Indicator.currentPage+1, section: 0), at: .left, animated: true)
        }
    }
    
    
    //MARK : Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.Indicator.numberOfPages = 4
        return self.Indicator.numberOfPages
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.collection_view.bounds.size.width, height:   self.collection_view.bounds.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "WelcomCell", for: indexPath) as! WelcomCell
        var data = self.data[indexPath.row]
        cell.LBL_text.text = data["text"] as? String
        cell.LBL_title.text = data["title"] as? String
        cell.IMG_logo.image = data["image"] as? UIImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.Indicator.currentPage = indexPath.row
        switch indexPath.row {
        case 0:
            self.Btn_start.isHidden = true
            break
        case 1:
            self.Btn_start.isHidden = true
            break
        case 2:
            self.Btn_start.isHidden = true
            break
        case 3:
            self.Btn_start.isHidden = false
            break
        default:
            break
        }
    }
    
    
    
}
