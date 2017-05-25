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

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var emailTextField: MainTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.type = .Email
        emailTextField.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        email = emailTextField.text!
        UserDefaults.standard.set(true, forKey: "hasEnteredEmail")
    }
}
