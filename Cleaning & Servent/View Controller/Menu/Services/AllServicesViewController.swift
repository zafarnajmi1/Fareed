//
//  AllServicesViewController.swift
//  Cleaning & Servent
//
//  Created by waseem on 23/04/2018.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class AllServicesViewController: BaseViewController,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var imgViewBack: UIImageView!
    @IBOutlet var lbl_SpecialInfoHeading : UILabel!

    @IBOutlet weak var heightUpperView: NSLayoutConstraint!
    
    
    @IBOutlet weak var viewUpper: UIView!
    var arrayService = [[String : Any]]()
    
    @IBOutlet weak var collection_view: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isArabic() {
            self.imgViewBack.image = #imageLiteral(resourceName: "backArabic")
        }else{
            
        }
        self.lbl_SpecialInfoHeading.text = "Services".localized

        self.collection_view.register(UINib.init(nibName: "ServicesCell", bundle: nil), forCellWithReuseIdentifier: "ServicesCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        if self.arrayService.count == 0 {
            self.GetAllServices()
        }
        
        
    }
    
    
    func GetAllServices(){
        
        self.arrayService.removeAll()
        self.showLoading()
        NetworkManager.get("services", isLoading: true, onView: self) { (mainResponse) in
            self.hideLoading()
            print(mainResponse)
            if (mainResponse?["status_code"] as! Int)  == 200 {
                
                self.arrayService = mainResponse?["data"] as! [[String : Any]]
                
                
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
        
        let translation = self.arrayService[indexPath.row]["translation"] as! [String : Any]
        
        cell.service_name.text = translation["title"] as? String
        cell.img.sd_setImage(with: URL.init(string: self.arrayService[indexPath.row]["image"] as! String), placeholderImage  : #imageLiteral(resourceName: "profile_placeholder") ,completed: nil)
        
        
        print(self.arrayService.count % 3)
        cell.bottomView.isHidden = false
        if indexPath.row >= (self.arrayService.count - (self.arrayService.count % 3) ) {
            cell.bottomView.isHidden = true
            
        }
        
        cell.check_box_img.isHidden = true
        
        cell.rightView.isHidden = false
        if ((indexPath.row + 1)  % 3) == 0  {
            cell.rightView.isHidden = true
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let getView = self.GetView(nameViewController: "DEtailServicesViewController", nameStoryBoard: "Main") as! DEtailServicesViewController
        getView.chooseService = self.arrayService[indexPath.row]
        self.navigationController?.pushViewController(getView, animated: true)
//        let cell = collection_view.cellForItem(at: indexPath) as! ServicesCell
//        if(cell.check_box_img.image == #imageLiteral(resourceName: "check_box")){
//            cell.check_box_img.image = #imageLiteral(resourceName: "check_box_checked")
//        }else{
//            cell.check_box_img.image = #imageLiteral(resourceName: "check_box")
//        }
    }
    
}

