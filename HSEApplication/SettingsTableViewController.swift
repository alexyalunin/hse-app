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
    
    @IBOutlet weak var emailLabel: UILabel!
    var languages = ["Русский", "Английский"]
    var timeZones = ["GMT+3", "GMT+5"]
    
    @IBOutlet weak var languagePickerCell: TimePickerCell!
    @IBOutlet weak var timeZonePickerCell: TimePickerCell!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        languagePickerCell.titleLabel.text = "Язык"
        languagePickerCell.infoLabel.text = "Русский"
        languagePickerCell.array = languages
        timeZonePickerCell.titleLabel.text = "Часовой пояс"
        timeZonePickerCell.infoLabel.text = "GMT+3"
        timeZonePickerCell.array = timeZones
        emailLabel.text = email
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        tableView.reloadData()
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        (cell as! TimePickerCell).watchFrameChanges()
//    }
//    
//    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        (cell as! TimePickerCell).ignoreFrameChanges()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        for cell in tableView.visibleCells as! [TimePickerCell] {
//            cell.ignoreFrameChanges()
//        }
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath == selectedIndexPath) && (indexPath.section == 0){
            return TimePickerCell.expandedHeight
        } else {
            return TimePickerCell.defaultHeight
        }
    }

}
