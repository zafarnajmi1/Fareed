//
//  DataManager.swift
//  DrakeMaster
//
//  Created by Apple on 29/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import Firebase

class DataManager: NSObject {
    
    var user: User?
    var fcm_token : String?
    var filter_date : Int?
    weak var current_nav : UINavigationController?
//    {
////        didSet {
////            saveUserPermanentally()
////        }
//    }
	
    var lastKnownAddress = kEmptyString
    static let sharedInstance = DataManager()
	var APIHitTry = 1
    
    func logoutUser() {
        user = nil
        lastKnownAddress = kEmptyString
		UserDefaults.standard.removeObject(forKey: "user")
        deleteFireBaseToken()
    }
    
    
    private func deleteFireBaseToken () {
        let instance = InstanceID.instanceID()
        instance.deleteID { (error) in
            print(error.debugDescription)
        }
        
        instance.instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else {
                print("Remote instance ID token: \(String(describing: result?.token))")
            }
        }
        Messaging.messaging().shouldEstablishDirectChannel = true


    }
    
    
    func saveUserPermanentally() {
        if user != nil {
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: user!)
            UserDefaults.standard.set(encodedData, forKey: "user")
        }else {
            UserDefaults.standard.removeObject(forKey: "user")
        }
    }
    
    func isFirstLaunch() -> Bool {
        if UserDefaults.standard.bool(forKey: "isFirstLaunch"){
            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
            return false
        }else{
             UserDefaults.standard.set(true, forKey: "isFirstLaunch")
            return true;
        }
        
    }
    func isCleaningCompany() -> Bool {
        if UserDefaults.standard.bool(forKey: "isCleaningCompany"){
            return true
        }else{
            return false;
        }
    }
    func setCleanignCompny(isTrue : Bool) {
        UserDefaults.standard.set(isTrue, forKey: "isCleaningCompany")
    }
    
    
    func getPermanentlySavedUser() -> User? {
        
        if let data = UserDefaults.standard.data(forKey: "user"),
            
            let userData = NSKeyedUnarchiver.unarchiveObject(with: data) as? User {
            
//            self.user = userData
            return userData
        } else {
            return nil
        }
    }
    func getSelectedCurrency() -> String {
        let defaults = UserDefaults.standard
        if let value = defaults.value(forKey: "Currency") as? String{
            return value
        }
        else {
            return "2"
        }
    }
}
