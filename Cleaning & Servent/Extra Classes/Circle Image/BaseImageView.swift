//
//  SaveMeImage.swift
//  SaveMe
//
//  Created by MAC MINI on .
//  Copyright © 2018. All rights reserved.
//

import UIKit

class BaseImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.cornerRadious()
    }
    
    
     func cornerRadious()  {
        self.layer.borderWidth = 0;
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

class LightGrayBorderImage: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.cornerRadious()
    }
    
    
     func cornerRadious()  {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 1
        self.layer.borderColor = UIColor.init(red: 150/255, green: 150/255, blue: 150/255, alpha: 0.4).cgColor
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}


class RoundedImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
}

class CircularImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width/2
        self.clipsToBounds = true
    }
}
