//
//  HSETextField.swift
//  HSEapp
//
//  Created by Alexander on 23/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

enum keyType:Int{
    case Default
    case Email
    case Password
    
    var desc:String{
        switch self {
        case .Default:
            return ""
        case .Email:
            return "Введите корпоративную почту"
        case .Password:
            return "Пароль"
        }
    }
}

@IBDesignable
class MainTextField: UITextField {
    
    var type:keyType = .Default{
        didSet{
            switch self.type{
            case .Default:
                super.placeholder = ""
                break
            case .Email:
                super.attributedPlaceholder = NSAttributedString(string: self.type.desc,
                                                       attributes: [NSForegroundColorAttributeName: hseColorPassive])
                
                self.keyboardType = .emailAddress
                break
            case .Password:
                super.attributedPlaceholder = NSAttributedString(string: self.type.desc,
                                                                 attributes: [NSForegroundColorAttributeName: hseColorPassive])
                self.keyboardType = .default
                self.isSecureTextEntry = true
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    func setUp(){
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.size.height))
        self.leftView = padding
        self.leftViewMode = UITextFieldViewMode.always
    }
}
