//
//  CompanyModel.swift
//  Servent
//
//  Created by waseem on 25/02/2018.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import Foundation


import UIKit

class CompanyModel : NSObject {
    
    var address        = kEmptyString
    var companyID        = kEmptyString
    var companyPhone        = kEmptyString
    var companyAbout        = kEmptyString
    var companyName        = kEmptyString
    var CompanyImage        = kEmptyString
    var Companyratings        = kEmptyString
    var Companyrate        = kEmptyString
    var CompanyStart        = kEmptyString
    var CompanyEnd        = kEmptyString
    
    convenience init(json: [String: AnyObject]?) {
        self.init()
        print(json!)
        
        self.address = json?["address"] as? String ?? kEmptyString
        self.CompanyImage = json?["image"] as? String ?? kEmptyString
        self.companyPhone = json?["phone"] as? String ?? kEmptyString
        self.companyID = String(json?["id"] as? Int ?? 0)
        let translation = json?["translation"] as? [String : AnyObject]
        self.companyAbout = translation?["about"] as? String ?? kEmptyString
        self.companyName = translation?["full_name"] as? String ?? kEmptyString
        
        self.Companyratings = String(json?["average_rating"] as? Double ?? 0.0)
        self.CompanyEnd = String(json?["time_ends"] as? Int ?? 0).ConvertTOTime()
        self.CompanyStart = String(json?["time_starts"] as? Int ?? 0).ConvertTOTime()
        
        print(self.CompanyStart)
        print(self.CompanyStart)
        print(self.CompanyEnd)
        if let newRate = json?["rate_per_hour"] as? [String : AnyObject] {
            if let dollarRate = newRate["usd"] as? [String : AnyObject] {
                self.Companyrate = String(dollarRate["price"] as? Int ?? 0)
            }
        }
        
    }
}



