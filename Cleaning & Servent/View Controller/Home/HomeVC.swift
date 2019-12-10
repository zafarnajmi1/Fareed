//
//  HomeVC.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 3/14/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire

class HomeVC: BaseViewController, UITableViewDelegate , UITableViewDataSource,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,moveonLogin  {
   
    @IBOutlet weak var pagger: UIPageControl!
    
    var notificaitonCount = 0
        
    
    @IBOutlet weak var lbl_SelectService: UILabel!
    @IBOutlet weak var lbl_Cleaning: UILabel!
    @IBOutlet weak var lbl_Maintenance: UILabel!
    @IBOutlet weak var lbl_HEading: UILabel!
    
    @IBOutlet weak var Collection_view: UICollectionView!
    @IBOutlet weak var TBL_menu: UITableView!
    @IBOutlet weak var MenuView_detail: UIView!
    @IBOutlet weak var MenuView: UIView!
    @IBOutlet weak var Constraint_Menu_Left: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
          self.lbl_HEading.text = "Fareed".localized//"Cleaning & Maintenance".localized
        self.lbl_Cleaning.text = "Cleaning".localized
        self.lbl_Maintenance.text = "Maintenance".localized
        self.lbl_SelectService.text = "Select your service".localized
        
         self.Constraint_Menu_Left.constant = -250
        self.MenuView.isHidden = true
         self.Collection_view.register(UINib.init(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        self.TBL_menu.register(UINib.init(nibName: "MenuHeaderCell", bundle: nil), forCellReuseIdentifier: "MenuHeaderCell")
         self.TBL_menu.register(UINib.init(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width:self.Collection_view.frame.width, height: self.Collection_view.frame.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        self.Collection_view!.collectionViewLayout = layout
          Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
        
        self.TBL_menu.contentInset.top = -20
    }

    
    func GetNotificationCount(){
        print("URL :notifications/unread")
        //self.showLoading()
        NetworkManager.get("notifications/unread", isLoading: false,handleFailure: false, onView: self) { (mainResponse) in
            self.hideLoading()
            print("Unreed Notifications: \(mainResponse ?? [:])")
            if let data = mainResponse?["data"] as? [String : Any]{
                if let cont : Int =  data["unread_count"] as? Int{
                    if cont > 0 {
                        self.notificaitonCount = cont
                        self.TBL_menu.reloadData()
                    }else{
                        self.notificaitonCount = 0
                    }
                }
            }
            
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    override func viewWillAppear(_ animated: Bool) {
//        if DataManager.sharedInstance.getPermanentlySavedUser()?.session_token != nil {
//            DataManager.sharedInstance.user = DataManager.sharedInstance.getPermanentlySavedUser()
//        }
        
        
        self.GetNotificationCount()
        
        self.TBL_menu.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    @objc func scrollAutomatically(_ timer: Timer) {
        
        if let coll  = self.Collection_view {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)

                if ((indexPath?.row)!  < (appdelegate.sliderArray.count - 1) /*4 - 1*/){

                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }
                
            }
        } 
    }
    @IBAction func OnClickCloseMenu(_ sender: Any) {
      self.CloseMenu()
    }
    
    func CloseMenu() {
        self.MenuView.fadeOut()
        DispatchQueue.main.async {
            self.Constraint_Menu_Left.constant = -280
            UIView.animate(withDuration: 0.25, animations: {
                self.MenuView.layoutIfNeeded()
                self.MenuView_detail.layoutIfNeeded()
                self.view.layoutIfNeeded()
                
            })
        }
    }
    @IBAction func OnClickMenu(_ sender: Any) {
        
        self.MenuView.isHidden = false
        self.MenuView.fadeIn()
        self.GetNotificationCount()
        self.TBL_menu.reloadData()
        self.TBL_menu.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .bottom, animated: false)
        DispatchQueue.main.async {
            print(self.Constraint_Menu_Left.constant)
            self.Constraint_Menu_Left.constant = 280
            UIView.animate(withDuration: 0.25, animations: {
                self.MenuView.layoutIfNeeded()
                self.MenuView_detail.layoutIfNeeded()
                self.view.layoutIfNeeded()
                
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return getMenuData().count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuHeaderCell") as! MenuHeaderCell
            cell.delegate = self
            cell.setUI()
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
            cell.IMG_icon.image = self.getMenuData()[indexPath.row-1]["image"] as? UIImage
            cell.LBL_title.text =  self.getMenuData()[indexPath.row-1]["title"] as? String
            
            cell.LBL_notificationCount.isHidden = true
            cell.LBL_notificationCount.RoundView()
            if "Notifications".localized == cell.LBL_title.text {
                cell.LBL_notificationCount.isHidden = false
                cell.LBL_notificationCount.text = String(notificaitonCount)
                
                if notificaitonCount == 0 {
                    cell.LBL_notificationCount.isHidden = true
                }
            }
            if self.isCompony(){
              if(indexPath.row == 4 || indexPath.row == 6){
                   cell.View_line.isHidden = false
              }else{
                 cell.View_line.isHidden = true
              }
            }else{
                if(indexPath.row == 6){
                    cell.View_line.isHidden = false
                }else{
                    cell.View_line.isHidden = true
                }
            }
            cell.selectionStyle = .none
            return cell
        }
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath)
        self.CloseMenu()
        if indexPath.row == 0 {
//            self.CloseMenu()
            return
        }
        if indexPath.row != 1 && indexPath.row != 6 && indexPath.row != 7 && indexPath.row != 8 && indexPath.row != 9 && indexPath.row != 10 && indexPath.row != 11 && indexPath.row != 12 && indexPath.row != 13
            && indexPath.row != 14  {
            self.appdelegate.viewMove = 0
//            self.appdelegate.viewMove = indexPath.row
            if !self.CheckLogin(){
                self.appdelegate.viewMove = indexPath.row
                return
            }
            
        }
        self.CloseMenu()
        switch indexPath.row {
        case 1:
             self.CloseMenu()
            break
            
        case 2:
            if self.isCompony() {
                // Open Client
                self.PushView(nameViewController: "ClientVC", nameStoryBoard: "Booking")
            }else{
                (UIApplication.shared.delegate as! AppDelegate).isRefreshAfterCancel = true
                 self.PushViewWithIdentifier(name: "HistoryViewController")
            }
            self.CloseMenu()
           
            break
        case 3:
            self.CloseMenu()
            if self.isCompony() {
                // Open Reviews
            }else{
                self.PushViewWithIdentifier(name: "AddressBookVC")
            }
            break
        case 4:
            self.CloseMenu()
            if self.isCompony() {
                // Open Usr Profile
                self.PushViewWithIdentifier(name: "EditProfileViewController")
            }else{
                self.PushViewWithIdentifier(name: "NotificationVC")
            }
           
            break
        case 5:
             self.CloseMenu()
             if self.isCompony() {
                // Open Company Profile
             }else{
                  self.PushViewWithIdentifier(name: "EditProfileViewController")
             }
          
            break
            
//        case 6:
//            self.CloseMenu()
//            if self.isCompony() {
//                // Open Manage Cleaners
//            }else{
//               // self.PushViewWithIdentifier(name: "CompanyInfoViewController")
//            }
//
//            break
            
        case 6:
            self.CloseMenu()
            self.PushViewWithIdentifier(name: "SelectLanguageVC")
            break
            
        case 7:
            self.CloseMenu()
            self.PushViewWithIdentifier(name: "SelectCurencyVC")
            break
            
            
        case 8:
            self.CloseMenu()
            self.PushViewWithIdentifier(name: "TestimonialVC")
            break
        case 9:
            self.CloseMenu()
            self.PushViewWithIdentifier(name: "AllServicesViewController")
//            self.PushViewWithIdentifier(name: "FaqVC")
            break

        case 10:
            self.CloseMenu()
            self.PushViewWithIdentifier(name: "FaqVC")
            break
        case 11:
            self.CloseMenu()
            self.PushViewWithIdentifier(name: "TermsConditionVC")
            break
        case 12:
            self.CloseMenu()
            self.PushViewWithIdentifier(name: "PrivacyPolicyVC")
            break
        case 13:
            self.CloseMenu()
            self.PushViewWithIdentifier(name: "AboutUsVC")
            break
        case 14:
            self.CloseMenu()
            self.PushViewWithIdentifier(name: "ConactUs")
            break
//        case 14:
//            self.CloseMenu()
//            NetworkManager.get(WebServiceName.Logout.rawValue, isLoading: true, onView: self, hnadler: { (response) in
//                print(response)
//                DataManager.sharedInstance.logoutUser()
//                //            self.PushViewWithIdentifier(name: "LoginVC")
//                //            self.Back()
//                self.PushViewWithIdentifier(name: "HomeVC")
//            })
//
////            self.PushViewWithIdentifier(name: "ConactUs")
//            break
       
        default:
            break
            
        }
    }
    
    @IBAction func OnClickMaintinence(_ sender: Any) {
        let newService = self.storyboard?.instantiateViewController(withIdentifier: "ServicesSelectionVC") as! ServicesSelectionVC
        newService.isType = "maintenance"
        self.navigationController?.pushViewController(newService, animated: true)
    }
    
    @IBAction func OnClickCleaning(_ sender: Any) {
        let newService = self.storyboard?.instantiateViewController(withIdentifier: "ServicesSelectionVC") as! ServicesSelectionVC
        newService.isType = "cleaning"
        self.navigationController?.pushViewController(newService, animated: true)
    }
    
    @IBAction func OnClickSearch(_ sender: Any) {
        self.PushViewWithIdentifier(name: "SearchVC")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func getMenuData() -> [[String : Any]] {
        if DataManager.sharedInstance.getPermanentlySavedUser()?.user_type == "company"{
            var data = [[String : Any]] ()
            data.append(["image" : #imageLiteral(resourceName: "home") , "title" : "Home".localized])
            data.append(["image" : #imageLiteral(resourceName: "proffesional") , "title" : "Client".localized])
            data.append(["image" : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8470588235) , "title" : "Reviews".localized])
            data.append(["image" : #imageLiteral(resourceName: "profile") , "title" : "User Profile".localized])
            data.append(["image" : #imageLiteral(resourceName: "profile") , "title" : "Company Profile".localized])
            data.append(["image" : #imageLiteral(resourceName: "cleaners") , "title" : "Manage Employment".localized])
            data.append(["image" : #imageLiteral(resourceName: "language") , "title" : "Change Language".localized])
            data.append(["image" : #imageLiteral(resourceName: "currency") , "title" : "Currency".localized])
            data.append(["image" : #imageLiteral(resourceName: "testimonials") , "title" : "Testimonials".localized])
            data.append(["image" : #imageLiteral(resourceName: "welcome_3") , "title" : "Services".localized])
            data.append(["image" : #imageLiteral(resourceName: "FAQ") , "title" : "FAQ".localized])
            data.append(["image" : #imageLiteral(resourceName: "terms&condition") , "title" : "Terms & Conditions".localized])
            data.append(["image" : #imageLiteral(resourceName: "password") , "title" : "Privacy Policy".localized])
            data.append(["image" : #imageLiteral(resourceName: "about") , "title" : "About".localized])
            data.append(["image" : #imageLiteral(resourceName: "Contact") , "title" : "Contact Us".localized])
            //data.append(["image" : #imageLiteral(resourceName: "Logout ") , "title" : "Logout".localized])
            return data
        }else{
            var data = [[String : Any]] ()
            data.append(["image" : #imageLiteral(resourceName: "home") , "title" : "Home".localized])
            data.append(["image" : #imageLiteral(resourceName: "history") , "title" : "History".localized])
            data.append(["image" : #imageLiteral(resourceName: "addressbook") , "title" : "Address Book".localized])
            data.append(["image" : #imageLiteral(resourceName: "notification") , "title" : "Notifications".localized])
            data.append(["image" : #imageLiteral(resourceName: "profile") , "title" : "Profile".localized])
            //data.append(["image" : #imageLiteral(resourceName: "home") , "title" : "Create Company".localized])
            data.append(["image" : #imageLiteral(resourceName: "language") , "title" : "Change Language".localized])
            data.append(["image" : #imageLiteral(resourceName: "currency") , "title" : "Currency".localized])
            data.append(["image" : #imageLiteral(resourceName: "testimonials") , "title" : "Testimonials".localized])
            data.append(["image" : #imageLiteral(resourceName: "welcome_3") , "title" : "Services".localized])
            data.append(["image" : #imageLiteral(resourceName: "FAQ") , "title" : "FAQ".localized])
            data.append(["image" : #imageLiteral(resourceName: "terms&condition") , "title" : "Terms & Conditions".localized])
            data.append(["image" : #imageLiteral(resourceName: "password") , "title" : "Privacy Policy".localized])
            data.append(["image" : #imageLiteral(resourceName: "about") , "title" : "About".localized])
            data.append(["image" : #imageLiteral(resourceName: "Contact") , "title" : "Contact Us".localized])
            //data.append(["image" : #imageLiteral(resourceName: "Logout ") , "title" : "Logout".localized])
            return data
        }
      
    }
    func loginAction(cell: MenuHeaderCell) {
        
        CloseMenu()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    //MARK : Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.pagger.numberOfPages = appdelegate.sliderArray.count
        return self.pagger.numberOfPages
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.Collection_view.bounds.size.width, height:   self.Collection_view.bounds.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        
        cell.imgViewMain.sd_setImage(with: URL.init(string: appdelegate.sliderArray[indexPath.row]["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
        let translation = appdelegate.sliderArray[indexPath.row]["translation"] as! [String : Any]
        cell.lblHeading.text = translation["title"] as? String
        cell.lblBottom.text = translation["detail"] as? String
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pagger.currentPage = indexPath.row
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? SelectDateCell {
                cell.contentView.transform = .init(scaleX: 0.95, y: 0.95)
                cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? SelectDateCell {
                cell.contentView.transform = .identity
                cell.contentView.backgroundColor = .clear
            }
        }
    }
    
    
    
}
