//
//  SplashVC.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 3/14/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class SplashVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        baseVC = self
        self.delayWithSeconds(1) {
            
            NetworkManager.get("settings", isLoading: false, onView: self, hnadler: { (mainData) in
                
                self.hideLoading()
                if(mainData!["status_code"] as! Int  == 200){
                    let dataMain = mainData!["data"] as! [String : Any]
                    self.appdelegate.sliderArray = dataMain["sliders"] as! [[String : Any]]
                    
                }
                else{
                    self.hideLoading()
                    self.ShowErrorAlert(message: mainData?["message"] as! String )
                }
                
                if DataManager.sharedInstance.isFirstLaunch()
                {
                    self.PushView(nameViewController: "WelcomeVC", nameStoryBoard: "Welcom")
                    
                }
                else
                {
                    
                    if DataManager.sharedInstance.getPermanentlySavedUser()?.google_id != nil && ( DataManager.sharedInstance.getPermanentlySavedUser()?.google_id as! String).count > 0
                    {
                        
                        self.socialLogin(type: 1, social_id:  DataManager.sharedInstance.getPermanentlySavedUser()?.google_id as! String)
                        
                    }
                    else if DataManager.sharedInstance.getPermanentlySavedUser()?.facebook_id != nil && ( DataManager.sharedInstance.getPermanentlySavedUser()?.facebook_id as! String).count > 0
                    {
                        self.socialLogin(type: 2, social_id: DataManager.sharedInstance.getPermanentlySavedUser()?.facebook_id as! String)
                        
                    }
                    else if DataManager.sharedInstance.getPermanentlySavedUser()?.instagram_id != nil && ( DataManager.sharedInstance.getPermanentlySavedUser()?.instagram_id as! String).count > 0
                    {
                        self.socialLogin(type: 3, social_id: DataManager.sharedInstance.getPermanentlySavedUser()?.instagram_id as! String)
                    }
                    else if (DataManager.sharedInstance.getPermanentlySavedUser()?.mobile != nil && DataManager.sharedInstance.getPermanentlySavedUser()?.password != nil )
                    {
                        
                        print(DataManager.sharedInstance.getPermanentlySavedUser()?.mobile as! String)
                        print(DataManager.sharedInstance.getPermanentlySavedUser()?.password as! String)
                        if (DataManager.sharedInstance.getPermanentlySavedUser()?.mobile as! String).count > 0
                            && (DataManager.sharedInstance.getPermanentlySavedUser()?.password as! String).count > 0
                            
                        {
                            var param = [String : AnyObject]()
                            param["mobile"] =  DataManager.sharedInstance.getPermanentlySavedUser()?.mobile as AnyObject
                            param["password"]  =  DataManager.sharedInstance.getPermanentlySavedUser()?.password as AnyObject
                            param["fcm_token"]  = (DataManager.sharedInstance.fcm_token ?? "") as AnyObject
                           
                            NetworkManager.post(WebServiceName.Login.rawValue, isLoading: false, withParams: param, onView: self, hnadler: { (response) in
                                self.hideLoading()
                                print(response)
                                if(response!["status_code"] as! Int == 200){
                                    let userMain = User.init(json: response!["data"] as? [String : AnyObject])
                                    userMain.session_token = response!["token"] as! String
                                    userMain.isLogin = true
                                    
                                    userMain.password = (DataManager.sharedInstance.getPermanentlySavedUser()?.password)!
                                    userMain.mobile = (DataManager.sharedInstance.getPermanentlySavedUser()?.mobile)!
                                    
                                    DataManager.sharedInstance.user = userMain
                                    DataManager.sharedInstance.saveUserPermanentally()
                                    
                                    if DataManager.sharedInstance.getPermanentlySavedUser()?.user_type == "company"
                                    {
                                        (UIApplication.shared.delegate as! AppDelegate).isRefreshAfterCancel = true
                                        self.PushViewWithIdentifier(name: "HistoryViewController")
                                        
                                    }else {
                                        self.PushViewWithIdentifier(name: "HomeVC")
                                        
                                    }
                                    
                                }
                                else
                                {
                                    DataManager.sharedInstance.logoutUser()
                                    self.PushViewWithIdentifier(name: "HomeVC")
                                }
                            })
                        }
                        else
                        {
                            DataManager.sharedInstance.logoutUser()
                            self.PushViewWithIdentifier(name: "HomeVC")
                        }
                    }
                    else
                    {
                        DataManager.sharedInstance.logoutUser()
                        self.PushViewWithIdentifier(name: "HomeVC")
                    }
                }
                
            })
        }
    }
    
    func socialLogin(type : Int , social_id : String)
    {
        var param = [String : AnyObject]()
        
        if type == 1 // goggle
        {
            param["google_id"] =  social_id as AnyObject
        }
        else if type == 2 // facebook
        {
            param["facebook_id"] =  social_id as AnyObject
        }
        else if type == 3 // instagram
        {
            param["instagram_id"] =  social_id as AnyObject
        }
        
        NetworkManager.post(WebServiceName.SocialLogin.rawValue, isLoading: false, withParams: param, onView: self, hnadler: { (response) in
            print(response)
            self.hideLoading()
            if(response!["status_code"] as! Int == 200)
            {
                let userMain = User.init(json: response?["data"] as? [String : AnyObject])
                userMain.session_token = response?["token"] as! String
                userMain.isLogin = true
                
//                userMain.password = (DataManager.sharedInstance.getPermanentlySavedUser()?.password)!
//                userMain.mobile = (DataManager.sharedInstance.getPermanentlySavedUser()?.mobile)!
                
                DataManager.sharedInstance.user = userMain
                DataManager.sharedInstance.saveUserPermanentally()
                
                if DataManager.sharedInstance.getPermanentlySavedUser()?.user_type == "company"
                {
                    (UIApplication.shared.delegate as! AppDelegate).isRefreshAfterCancel = true
                    self.PushViewWithIdentifier(name: "HistoryViewController")
                    
                }else {
                    self.PushViewWithIdentifier(name: "HomeVC")
                    
                }
                
            }
            else {
                self.hideLoading()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
