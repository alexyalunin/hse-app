//
//  ApplicationInfoViewController.swift
//  HSEapp
//
//  Created by Alexander on 17/02/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit
import MessageUI

class ApplicationInfoViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func contactWithDevelopers(_ sender: Any) {
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
    
        mc.setToRecipients(["ale.yalunin@gmail.com"])
        
        self.present(mc, animated: true, completion: nil)
    }

    @IBAction func rateApp(_ sender: Any) {
        let appId = "1000814818"
        let url_string = "itms-apps://itunes.apple.com/app/id\(appId)"
        if let url = URL(string: url_string) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Mail saved")
        case MFMailComposeResult.sent.rawValue:
            print("Mail sent")
        case MFMailComposeResult.failed.rawValue:
            print("Mail sent failure: %@", [error!.localizedDescription])
        default:
            break
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
}
