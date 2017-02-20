//
//  OneContactViewController.swift
//  HSEapp
//
//  Created by Alexander on 01/02/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class OneContactViewController: UIViewController {

    var worker: Worker?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeInfoLabel: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = worker?.name
        postLabel.text = (worker?.post)! + ": " + (worker?.faculty)!
        addressLabel.text = "Адрес: " + (worker?.address)!
        timeInfoLabel.text = worker?.timeAvailableInfo
        
        nameLabel.sizeToFit()
        postLabel.sizeToFit()
        addressLabel.sizeToFit()
        timeInfoLabel.sizeToFit()
        
        // Added table view controller as a child view controller
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PhoneAndEmailTableViewController") as! PhoneAndEmailTableViewController
        self.container.addSubview(vc.view)
        self.addChildViewController(vc)
        vc.view.frame = CGRect(x: 0,y : 0, width: self.mainView.frame.size.width, height: self.container.frame.size.height);
        vc.didMove(toParentViewController: self)
        
        vc.phoneCell.mainTextLabel.text = worker?.phone
        vc.emailCell.mainTextLabel.text = worker?.email
        
    }
    
}
