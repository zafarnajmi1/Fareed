//
//  User.swift
//  Servent
//
//  Created by Jawad ali on 2/7/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit

class User: NSObject , NSCoding{
     var userid : String          =  "0"
    var full_name : String          =  kEmptyString
    var email  : String            = kEmptyString
    var password : String          = kEmptyString
    var user_type : String         = kEmptyString
    var mobile : String            = kEmptyString
    var gender : String            = kEmptyString
    var image : String             = kEmptyString
    var fcm_token : String         = kEmptyString
    var verification_code : String = kEmptyString
    var email_verified : Bool      =  false
     var created_at : String       = kEmptyString
     var updated_at : String       = kEmptyString
    var session_token : String       = kEmptyString
    var CompanyID : String       = kEmptyString
    var CompanyType : String       = kEmptyString
    var CompanyRating : String       = kEmptyString
    var CompanyProfileImage : String       = kEmptyString
    
    
    var facebook_id : String       = kEmptyString
    var google_id : String       = kEmptyString
    var instagram_id : String       = kEmptyString
    
    var isLogin : Bool  = false
    var isCleaningCompany : Bool  = false
    var services : [[String : AnyObject]]  = []
    
    
    required init(json: [String: AnyObject]?) {
        print(json!)
        if let idis = json?["id"] as? Int
        {
            self.userid = String(idis)
        }else{self.userid="0"}
        self.full_name = json?["full_name"] as? String ?? kEmptyString
        self.email = json?["email"] as? String ?? kEmptyString
        self.password = json?["password"] as? String ?? kEmptyString
        self.user_type = json?["user_type"] as? String ?? kEmptyString
        self.mobile = json?["mobile"] as? String ?? kEmptyString
        self.gender = json?["gender"] as? String ?? kEmptyString
        self.image = json?["image"] as? String ?? kEmptyString
        self.fcm_token = json?["fcm_token"] as? String ?? kEmptyString
        self.verification_code = json?["verification_code"] as? String ?? kEmptyString
        self.created_at = json?["created_at"] as? String ?? kEmptyString
        self.updated_at = json?["updated_at"] as? String ?? kEmptyString
         self.email_verified = json?["email_verified"] as? Bool ?? false
//          self.isCleaningCompany = json?["isCleaning"] as? Bool ?? false
         self.session_token = json?["session_token"] as? String ?? kEmptyString
        
        
        self.facebook_id = json?["facebook_id"] as? String ?? kEmptyString
        self.google_id = json?["google_id"] as? String ?? kEmptyString
        self.instagram_id = json?["instagram_id"] as? String ?? kEmptyString
        
        
        if let companyData = json?["company"] as? [String : AnyObject] {
//            print(companyData)
//            print(companyData["id"])
//            print(companyData["id"] as! Int)
//            print(companyData["company_type"])
//            print(companyData["average_rating"] as! Double)
            
            self.CompanyID = String(companyData["id"] as? Int ?? 0 )
            self.CompanyType = companyData["company_type"] as? String ?? kEmptyString
            
            if self.CompanyType == "cleaning" {
                self.isCleaningCompany = true
            }else {
                self.isCleaningCompany = false
            }
            self.CompanyProfileImage = companyData["image"] as? String ?? ""
            self.CompanyRating = String(companyData["average_rating"] as? Double ?? 0.0)
            if let services = companyData["services"] as? [[String : AnyObject]] {
                
                self.services = services
            }
        }
        
        
    }
    func encode(with aCoder: NSCoder) {
        print(userid)
        aCoder.encode(CompanyProfileImage, forKey: "CompanyProfileImage")
        aCoder.encode(CompanyRating, forKey: "CompanyRating")
        aCoder.encode(CompanyType, forKey: "CompanyType")
        aCoder.encode(CompanyID, forKey: "CompanyID")
          aCoder.encode(userid, forKey: "useridis")
        aCoder.encode(email, forKey: "email")
         aCoder.encode(full_name, forKey: "full_name")
         aCoder.encode(password, forKey: "password")
         aCoder.encode(user_type, forKey: "user_type")
         aCoder.encode(mobile, forKey: "mobile")
         aCoder.encode(gender, forKey: "gender")
         aCoder.encode(image, forKey: "image")
         aCoder.encode(fcm_token, forKey: "fcm_token")
         aCoder.encode(verification_code, forKey: "verification_code")
         aCoder.encode(created_at, forKey: "created_at")
         aCoder.encode(updated_at, forKey: "updated_at")
         aCoder.encode(email_verified, forKey: "email_verified")
         aCoder.encode(session_token, forKey: "session_token")
         aCoder.encode(isLogin, forKey: "isLogin")
         aCoder.encode(isCleaningCompany, forKey: "isCleaningCompany")
        
         aCoder.encode(facebook_id, forKey: "facebook_id")
         aCoder.encode(google_id, forKey: "google_id")
         aCoder.encode(instagram_id, forKey: "instagram_id")
        aCoder.encode(services, forKey: "services")
  
    }
    
    
    required  init(coder aDecoder: NSCoder) {

        self.CompanyProfileImage = aDecoder.decodeObject(forKey:"CompanyProfileImage") as? String ?? ""
        self.CompanyRating = (aDecoder.decodeObject(forKey:"CompanyRating") as? String)!
        self.CompanyType = (aDecoder.decodeObject(forKey:"CompanyType") as? String)!
        self.CompanyID = (aDecoder.decodeObject(forKey:"CompanyID") as? String)!
        self.userid = (aDecoder.decodeObject(forKey:"useridis") as? String)!
        self.email = aDecoder.decodeObject(forKey:"email") as? String ?? kEmptyString
        self.full_name = aDecoder.decodeObject(forKey:"full_name") as? String ?? kEmptyString
        self.password = aDecoder.decodeObject(forKey:"password") as? String ?? kEmptyString
        self.user_type = aDecoder.decodeObject(forKey:"user_type") as? String ?? kEmptyString
        self.mobile = aDecoder.decodeObject(forKey:"mobile") as? String ?? kEmptyString
        self.gender = aDecoder.decodeObject(forKey:"gender") as? String ?? kEmptyString
        self.image = aDecoder.decodeObject(forKey:"image") as? String ?? kEmptyString
        self.fcm_token = aDecoder.decodeObject(forKey:"fcm_token") as? String ?? kEmptyString
        self.verification_code = aDecoder.decodeObject(forKey:"verification_code") as? String ?? kEmptyString
        self.created_at = aDecoder.decodeObject(forKey:"created_at") as? String ?? kEmptyString
        self.updated_at = aDecoder.decodeObject(forKey:"updated_at") as? String ?? kEmptyString
          self.email_verified = aDecoder.decodeObject(forKey:"email_verified") as? Bool ?? false
         self.isLogin = aDecoder.decodeObject(forKey:"isLogin") as? Bool ?? false
         self.isCleaningCompany = aDecoder.decodeObject(forKey:"isCleaningCompany") as? Bool ?? false
          self.session_token = aDecoder.decodeObject(forKey:"session_token") as? String ?? kEmptyString
        
        self.facebook_id = aDecoder.decodeObject(forKey:"facebook_id") as? String ?? kEmptyString
        self.google_id = aDecoder.decodeObject(forKey:"google_id") as? String ?? kEmptyString
        self.instagram_id = aDecoder.decodeObject(forKey:"instagram_id") as? String ?? kEmptyString
        self.services = aDecoder.decodeObject(forKey:"services") as? [[String : AnyObject]] ?? []
        

    }
}
