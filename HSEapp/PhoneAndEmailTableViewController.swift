//
//  PhoneAndEmailTableViewController.swift
//  HSEapp
//
//  Created by Alexander on 09/02/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit
import MessageUI

class PhoneAndEmailTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var phoneCell: CellWithDetailBlueText!
    @IBOutlet weak var emailCell: CellWithDetailBlueText!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // - make a call
        if indexPath.row == 0{
            let phoneNumber = phoneCell.mainTextLabel.text!
            if let url = URL(string: "tel://\(phoneNumber)") {
                //UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        // - write an email
        if indexPath.row == 1{
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setToRecipients([emailCell.mainTextLabel.text!])
            
            self.present(mc, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
}
