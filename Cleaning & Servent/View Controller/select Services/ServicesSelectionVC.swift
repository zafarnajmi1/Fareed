//
//  ServicesSelectionVC.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 3/15/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit
import SDWebImage
import  AlamofireImage
import Alamofire
class ServicesSelectionVC: BaseViewController,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var imgViewBack: UIImageView!
    var isSelect = false
    
    var isType = ""

    
    @IBOutlet var lblHEading : UILabel!
    @IBOutlet var lblTextOne : UILabel!
    @IBOutlet var lblTextTwo : UILabel!
    
    @IBOutlet var btnSearch : UIButton!
    
    
    var onlyCompayServices : Bool = false
    
    weak var delegate: SelectedServices?
    
    @IBOutlet weak var viewUpper: UIView!
    var arrayService = [[String : Any]]()
    
    @IBOutlet weak var collection_view: UICollectionView!
    override func viewDidLoad() {
        
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
        }
        
        
        self.lblHEading.text = "Select Services".localized
        self.lblTextOne.text = "Step 1: Select services".localized
        self.lblTextTwo.text = "Select Services".localized
        
        super.viewDidLoad()
        self.collection_view.register(UINib.init(nibName: "ServicesCell", bundle: nil), forCellWithReuseIdentifier: "ServicesCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.isSelect {
            self.btnSearch.setTitle("UPDATE".localized, for: .normal)
//            self.heightUpperView.constant = 0.0
            self.viewUpper.isHidden = true
        }else {
            self.btnSearch.setTitle("SEARCH".localized, for: .normal)
//            self.heightUpperView.constant = 150.0
            self.viewUpper.isHidden = false
        }
        
        if self.arrayService.count == 0 {
            if onlyCompayServices {
                self.CompanyServices()
                
            }
            else{
                self.GetAllServices()
            }
//
            
        }
        
        
    }
    
    
    func GetAllServices(){
        
        self.arrayService.removeAll()
        self.showLoading()
        NetworkManager.get("services", isLoading: true, onView: self) { (mainResponse) in
            self.hideLoading()
            print("GET Service Response :\(String(describing: mainResponse))")
            if (mainResponse?["status_code"] as! Int)  == 200 {
                
                if self.isType.count == 0 {
                    self.arrayService = mainResponse?["data"] as! [[String : Any]]
                }else {
                    let newarrayService = mainResponse?["data"] as! [[String : Any]]
                    
                    for indexObj in newarrayService {
                        if (indexObj["service_type"] as! String) == self.isType {
                            self.arrayService.append(indexObj)
                        }
                    }
                }
                
            }else {
                self.hideLoading()
                self.ShowErrorAlert(message: (mainResponse?["message"] as! String))
            }
            
            self.collection_view.reloadData()
        }
    }
    func CompanyServices(){
        
        self.arrayService.removeAll()
        self.showLoading()
        NetworkManager.get("company/services", isLoading: true, onView: self) { (mainResponse) in
            self.hideLoading()
            print("GET Service Response :\(String(describing: mainResponse))")
            if (mainResponse?["status_code"] as! Int)  == 200 {
                
                if self.isType.count == 0 {
                    self.arrayService = mainResponse?["data"] as! [[String : Any]]
                }else {
                    let newarrayService = mainResponse?["data"] as! [[String : Any]]
                    
                    for indexObj in newarrayService {
                        if (indexObj["service_type"] as! String) == self.isType {
                            self.arrayService.append(indexObj)
                        }
                    }
                }
                
            }else {
                self.hideLoading()
                self.ShowErrorAlert(message: (mainResponse?["message"] as! String))
            }
            
            self.collection_view.reloadData()
        }
    }
    @IBAction func OnClicBack(_ sender: Any) {
        
        self.Back()
    }
    
    @IBAction func OnClickSearch(_ sender: Any) {
        
        if self.isSelect {
            
            var arrayServices = [[String : Any]]()
            
            var indexMain = 0
            for indexobj in self.arrayService {
                
                let cell = collection_view.cellForItem(at: IndexPath.init(row: indexMain, section: 0)) as! ServicesCell
                
                if(cell.check_box_img.image != UIImage.init(named: "uncheckselectedcheckbox")){
                    arrayServices.append(indexobj)
                }
                indexMain = indexMain + 1
            }
            delegate?.SelectedServices(services: arrayServices)
            
            
            self.navigationController?.popViewController(animated: true)
        }else {
            
            var newServices = [[String : Any]]()
            
            
            
            for indexcount in 0..<self.arrayService.count {
                let cell = collection_view.cellForItem(at: IndexPath.init(row: indexcount, section: 0)) as! ServicesCell
                if(cell.check_box_img.image != UIImage.init(named: "uncheckselectedcheckbox")// #imageLiteral(resourceName: "check_box")
                    ){
                    newServices.append(self.arrayService[indexcount])
                }
            }
            
            
            
            
            if newServices.count == 0 {
                self.ShowErrorAlert(message: "Select services".localized)
                return
            }
            
            let step2VC = self.storyboard?.instantiateViewController(withIdentifier: "SelectServiceStep2VC") as! SelectServiceStep2VC
            step2VC.serviceType = self.isType
            
            
            
            
            step2VC.servicesSelected = newServices
            self.navigationController?.pushViewController(step2VC, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayService.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: (collection_view.frame.size.width/3)  , height: (collection_view.frame.size.width/3) )
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "ServicesCell", for: indexPath) as! ServicesCell
         cell.check_box_img.image = UIImage.init(named: "uncheckselectedcheckbox")
        let translation = self.arrayService[indexPath.row]["translation"] as! [String : Any]
        
        print(self.arrayService[indexPath.row]["image"] )
        cell.service_name.text = translation["title"] as? String
        
//        let url = URL( string:  (self.arrayService[indexPath.row]["image"] as! String)) 
//        cell.img.af_setImage(withURL: url!, placeholderImage: UIImage(named : "profile_placeholder"), filter: nil, imageTransition:.curlDown(0.0), runImageTransitionIfCached: true, completion: nil)
        
        
        cell.img.sd_setImage(with: URL(string: self.arrayService[indexPath.row]["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
        
        
        print(self.arrayService.count % 3)
        cell.bottomView.isHidden = false
        if indexPath.row >= (self.arrayService.count - (self.arrayService.count % 3) ) {
            cell.bottomView.isHidden = true
            
        }
        
        cell.rightView.isHidden = false
        if ((indexPath.row + 1)  % 3) == 0  {
            cell.rightView.isHidden = true
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collection_view.cellForItem(at: indexPath) as! ServicesCell
        if(cell.check_box_img.image == UIImage.init(named: "uncheckselectedcheckbox")// #imageLiteral(resourceName: "check_box")
            ){
            cell.check_box_img.image = UIImage.init(named: "selectedcheckbox") // #imageLiteral(resourceName: "check_box_checked")
        }else{
             cell.check_box_img.image = UIImage.init(named: "uncheckselectedcheckbox") // #imageLiteral(resourceName: "check_box")
        }
    }
    
}
