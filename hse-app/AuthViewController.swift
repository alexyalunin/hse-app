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
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var viewWithTextField: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewWithTextField()
        emailTextField.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        email = emailTextField.text! + "@edu.hse.ru"
        UserDefaults.standard.set(true, forKey: "hasEnteredEmail")
    }
    
    private func setUpViewWithTextField() {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: viewWithTextField.frame.size.height - 0.5, width: viewWithTextField.frame.size.width, height: 0.5);
        bottomBorder.backgroundColor = UIColor(red: 200/255, green: 199/255, blue: 204/255, alpha: 1).cgColor
        viewWithTextField.layer.addSublayer(bottomBorder)
    
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: viewWithTextField.frame.size.width, height: 0.5);
        topBorder.backgroundColor = UIColor(red: 200/255, green: 199/255, blue: 204/255, alpha: 1).cgColor
        viewWithTextField.layer.addSublayer(topBorder)
    }
    
}
