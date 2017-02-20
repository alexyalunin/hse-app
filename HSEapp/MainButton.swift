//
//  mainButton.swift
//  HSEapp
//
//  Created by Alexander on 25/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

@IBDesignable
class MainButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mBsetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        mBsetup()
    }
    
    func mBsetup(){
        layer.cornerRadius=5
    }
}

@IBDesignable
class HelpButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sizeToFit()
    }
    
    func mBsetup(){
        sizeToFit()
    }
}
