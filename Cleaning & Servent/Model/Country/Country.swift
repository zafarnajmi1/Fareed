//
//  Country.swift
//  Servent
//
//  Created by MAC MINI on .
//  Copyright © 2018. All rights reserved.
//

import UIKit

class Country: NSObject {
    var img : UIImage  =  #imageLiteral(resourceName: "Admin")
    var country_name        = kEmptyString
    var country_code        = kEmptyString
    var country_code_text    = kEmptyString
    convenience init(image : UIImage , name : String , code : String) {
        self.init()
        self.img = image
        self.country_name = name
        self.country_code = code
    }
    
    convenience init(image : UIImage , name : String , code : String , code_text : String) {
        self.init()
        self.img = image
        self.country_name = name
        self.country_code = code
        self.country_code_text = code_text
    }
}
