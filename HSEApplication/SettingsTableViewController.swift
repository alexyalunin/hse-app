//
//  SettingsTableViewController.swift
//  HSEapp
//
//  Created by Alexander on 16/02/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var selectedIndexPath: IndexPath?
    var languages = ["Русский", "Английский"]
    var timeZones = ["GTM+3", "GTM+5"]
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var timeZoneLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailLabel.text = email
        languageLabel.text = language
        timeZoneLabel.text = timeZone
    }
    
    // MARK: - Segues
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "From settings to checkmark":
            let destinationNavigationController = segue.destination as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! CheckmarkTableViewController
            
            if let cell = sender as? UITableViewCell {
                if let identifier = cell.reuseIdentifier {
                    switch identifier {
                    case "languageCell":
                        targetController.items = languages
                        targetController.sectionTitle = "Язык"
                    case "timeZoneCell":
                        targetController.items = timeZones
                        targetController.sectionTitle = "Часовой пояс"
                    default:
                        return
                    }
                }
            }
        case "From settings to contacts":
            _ = segue.destination as! ContactsTableViewController
            
        case "From settings to info":
            _ = segue.destination as! ApplicationInfoViewController
            
        case "From settings to auth":
            _ = segue.destination as! AuthViewController
            
        default:
            return
        }
    }
    
    
    @IBAction func getSettingsChanges(from segue: UIStoryboardSegue) {
        if segue.source is CheckmarkTableViewController {
            
                //tableView.reloadData()
                
//                dateStart = sourceController.intervalStart
//                dateEnd   = sourceController.intervalEnd
            
            
        }
    }
    
}
