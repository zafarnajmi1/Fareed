//
//  AddressModel.swift
//  Servent
//
//  Created by waseem on 25/02/2018.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import Foundation
import UIKit

class AddressModel : NSObject {

    var address        = kEmptyString
    var addressID        = kEmptyString
    
    
    
//    address = "Financial Centre Rd - Dubai - United Arab Emirates";
//    "created_at" = 1516293647;
//    id = 27;
//    latitude = "25.2008512";
//    longitude = "55.2781626";
//    "updated_at" = 1516362235;
//    "user_id" = 146;
    
    
    convenience init(json: [String: AnyObject]?) {
        self.init()
        print(json)
        
        self.address = json?["address"] as? String ?? kEmptyString
        self.addressID = String(json?["id"] as? Int ?? 0)
    }


}
