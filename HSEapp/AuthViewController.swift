//
//  AuthViewController.swift
//  HSEapp
//
//  Created by Alexander on 24/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit
@IBDesignable
class AuthViewController: UIViewController {
    
    @IBOutlet weak var mailField: MainTextField!
    @IBOutlet weak var passwordField: MainTextField!
    @IBOutlet weak var mainButton: MainButton!
    @IBOutlet weak var helpButton: HelpButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mailField.type = .Email
        passwordField.type = .Password
        mailField.becomeFirstResponder()
    }
    
}
