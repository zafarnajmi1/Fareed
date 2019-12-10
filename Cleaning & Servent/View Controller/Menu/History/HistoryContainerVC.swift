//
//  HistoryContainerVC.swift
//  Fareed
//
//  Created by Asif Habib on 18/10/2019.
//  Copyright © 2019 Jaidee. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HistoryContainerVC: ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var clv_buttons: UICollectionView!
    @IBOutlet weak var sv_views: UIScrollView!


    var FareedGreen : UIColor = #colorLiteral(red: 0.3529411765, green: 0.6470588235, blue: 0.3137254902, alpha: 1)
    var isCompany : Bool = false
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        

        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "HistoryListContainerVC") as! HistoryListContainerVC
        vc1.isType = 1
        let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "HistoryListContainerVC") as! HistoryListContainerVC
        vc2.isType = 5
        let vc3 = self.storyboard?.instantiateViewController(withIdentifier: "HistoryListContainerVC") as! HistoryListContainerVC
        vc3.isType = 3
        let vc4 = self.storyboard?.instantiateViewController(withIdentifier: "HistoryListContainerVC") as! HistoryListContainerVC
        vc4.isType = 4
        let vc5 = self.storyboard?.instantiateViewController(withIdentifier: "HistoryListContainerVC") as! HistoryListContainerVC
        vc5.isType = 2
        let vc6 = self.storyboard?.instantiateViewController(withIdentifier: "HistoryListContainerVC") as! HistoryListContainerVC
        vc6.isType = 6
        
        var vcs : [HistoryListContainerVC] = []
        if isCompany {
            let user = DataManager.sharedInstance.user
            if user?.CompanyType == "cleaning" {
                vcs = [vc1, vc2, vc3, vc4, vc5, vc6]
            }else{
                vcs =  [vc1, vc2, vc4, vc5, vc6]
            }
        }
        else{
            vcs =  [vc1, vc2, vc3, vc4, vc5, vc6]
        }
        
//        if isArabic(){
//            vcs.reverse()
//        }
        
        return vcs
        //        return [child_1, child_2]
    }
    func isArabic() -> Bool{
        let userDefaults = UserDefaults.standard
        if (userDefaults.value(forKey: "L") != nil) {
            if (userDefaults.value(forKey: "L") as! String) == "1" {
                return true
            }
        }
        
        return false
    }
    override func viewDidLoad() {
        if DataManager.sharedInstance.getPermanentlySavedUser()?.user_type == "company"{
            isCompany = true
        }
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemBackgroundColor = .clear
//        settings.style.buttonBarItemTitleColor = .green//self.btnTapSelectColor
        if ScreenSize.SCREEN_WIDTH <  376.0{
            settings.style.buttonBarItemFont =  UIFont.systemFont(ofSize: 10.0)
        }
        else{
            settings.style.buttonBarItemFont =  UIFont.systemFont(ofSize: 12.0)
        }
//        settings.style.buttonBarItemFont =  UIFont.systemFont(ofSize: 10.0)//UIFont(name: "Poppins", size: 15)! //.boldSystemFont(ofSize: 16)
        
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarMinimumInteritemSpacing = 0
//        settings.style.buttonBarItemTitleColor = .blue// UIColor.darkGray
//        settings.style.buttonBarBackgroundColor
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.selectedBarBackgroundColor = FareedGreen
        settings.style.selectedBarHeight = 3
        
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            
            oldCell?.label.textColor = .black
            oldCell?.backgroundColor = .white
            
            newCell?.label.textColor = self?.FareedGreen
            newCell?.backgroundColor = .white //self?.btnTapSelectColor
            
        }
        
        super.viewDidLoad()
        
        
//        func moveToViewController(at index: Int, animated: Bool)
        
//        if isArabic(){
//            clv_buttons.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
//            sv_views.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
//        }
//        else{
//
//        }

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dateUpdated),
            name: NSNotification.Name(rawValue: "Booking_Filter_Date_upated"),
            object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "Booking_Filter_Date_upated"), object: nil)
    }
    @objc func dateUpdated(){
        

        
        let a = currentIndex
        let b = viewControllers[a] as? HistoryListContainerVC
        
        b?.pageInfo = nil
        b?.APICAllHistoryList()
        
        
//        let b =
//        viewControllers(for: PagerTabStripViewController)
//        viewcontro
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
