//
//  Services.swift
//  Servent
//
//  Created by MAC MINI on .
//  Copyright © 2018. All rights reserved.
//

import UIKit

class Services: NSObject {
    
    var service_type        = kEmptyString
    var ID              = kEmptyString
    var title            = kEmptyString
    var isCheck        = kEmptyString
    var Images        = kEmptyString
    var DescriptionServices        = kEmptyString
    var includedServices        = kEmptyString
    var NotincludedServices        = kEmptyString
    
    
    var includedServicesArray        = [String]()
    var NotincludedServicesArray        = [String]()
    
    convenience init(json: [String: AnyObject]?) {
        self.init()
        print(json!)
        self.service_type = json?["service_type"] as? String ?? kEmptyString
        self.ID = String(json?["id"] as? Int ?? 0)
        self.Images = json?["image"] as? String ?? kEmptyString
        self.title = json?["translation"]!["title"] as? String ?? kEmptyString
        self.DescriptionServices = json?["translation"]!["description"] as? String ?? kEmptyString
        self.includedServices = json?["translation"]!["included"] as? String ?? kEmptyString
        self.NotincludedServices = json?["translation"]!["not_included"] as? String ?? kEmptyString
        
        
        self.includedServices = self.includedServices.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        self.includedServices = self.includedServices.replacingOccurrences(of: "\r", with: "")
        let newArray2 = self.includedServices.components(separatedBy: "\n")
        
        self.includedServicesArray.removeAll()
        for indexObj in newArray2 {
            if indexObj.count > 0 {
                self.includedServicesArray.append(indexObj)
            }
        }
        
        
        self.NotincludedServices = self.NotincludedServices.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        
        self.NotincludedServices = self.NotincludedServices.replacingOccurrences(of: "\r", with: "")
        let newArray = self.NotincludedServices.components(separatedBy: "\n")
        
        self.NotincludedServicesArray.removeAll()
        for indexObj in newArray {
            if indexObj.count > 0 {
                self.NotincludedServicesArray.append(indexObj)
            }
        }
        
    }
    
}
