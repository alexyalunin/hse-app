//
//  SecondaryButton.swift
//  HSEapp
//
//  Created by Alexander on 01/02/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

@IBDesignable
class SecondaryButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        sBsetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sBsetup()
    }
    
    func sBsetup(){
        self.layer.cornerRadius=5
        self.backgroundColor = hseColor
        self.titleLabel?.textColor = .white
    }

}
