//
//  SettingsTableViewController.swift
//  HSEapp
//
//  Created by Alexander on 16/02/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, JCActionSheetDelegate {
    
    var languageCellIsPressed = false
    
    var languageCheckedIndex: Int {
        get {
            if language == Languages.english.desc {
                return 1
            }
            return 0
        }
    }
    
    var timeZoneCheckedIndex: Int {
        get {
            if timeZone == TimeZones.GTM5.desc {
                return 1
            }
            return 0
        }
    }
    
    var languageCellIndexPath = IndexPath(row: 0, section: 0)
    var timeZoneCellIndexPath = IndexPath(row: 1, section: 0)
    
    enum Languages {
        case russian
        case english
        
        var desc: String {
            switch self {
            case .russian:
                return "Русский"
            case .english:
                return "Английский"
            }
        }
    }
    
    enum TimeZones {
        case GTM3
        case GTM5
        
        var desc: String {
            switch self {
            case .GTM3:
                return "GTM+3"
            case .GTM5:
                return "GTM+5"
            }
        }
    }
    
    
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
        case "From settings to info":
            _ = segue.destination as! ApplicationInfoViewController
            
        case "From settings to auth":
            _ = segue.destination as! AuthViewController
            
        default:
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
        IndexPath) {
        if indexPath == languageCellIndexPath {
            languageCellIsPressed = true
            let actionSheet = JCActionSheet.init(title: nil, delegate: self as JCActionSheetDelegate, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: [Languages.russian.desc, Languages.english.desc], textColor: Colors.systemColor, checkedButtonIndex: languageCheckedIndex);
            
            self.present(actionSheet, animated: true, completion: nil);
            
        } else if indexPath == timeZoneCellIndexPath {
            languageCellIsPressed = false
            let actionSheet = JCActionSheet.init(title: nil, delegate: self as JCActionSheetDelegate, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: [TimeZones.GTM3.desc, TimeZones.GTM5.desc], textColor: Colors.systemColor, checkedButtonIndex: timeZoneCheckedIndex);
            
            self.present(actionSheet, animated: true, completion: nil);
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func actionSheet(_ actionSheet: JCActionSheet, clickedButtonAt buttonIndex: Int) {
        if languageCellIsPressed {
            if buttonIndex == 0 {
                language = Languages.russian.desc
            } else if buttonIndex == 1 {
                language = Languages.english.desc
            }
        } else {
            if buttonIndex == 0 {
                timeZone = TimeZones.GTM3.desc
            } else if buttonIndex == 1 {
                timeZone = TimeZones.GTM5.desc
            }
        }
    }
    
    func actionSheetCancel(_ actionSheet: JCActionSheet) {
        return
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

