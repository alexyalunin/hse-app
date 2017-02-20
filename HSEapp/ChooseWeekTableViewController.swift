//
//  ChooseWeekTableViewController.swift
//  HSEapp
//
//  Created by Alexander on 04/02/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class ChooseWeekTableViewController: UITableViewController {
    
    var selectedIndexPath: IndexPath?
    
    var years: [Int] = []
    var months = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    var weeks = ["02.02.2017-09.02.2017", "10.02.2017-17.02.2017", "18.02.2017-25.02.2017", "26.02.2017-03.03.2017"]


    @IBOutlet weak var yearPickerCell: TimePickerCell!
    
    @IBOutlet weak var monthPickerCell: TimePickerCell!
    
    @IBOutlet weak var dayPickerCell: TimePickerCell!
    
    override func viewDidLoad() {
        
        for i in 2000 ..< 2031
        {
            years.append(i)
        }
        let stringYears = years.map
        {
            String($0)
        }
        
        yearPickerCell.array = stringYears
        yearPickerCell.titleLabel.text = "Год"
        monthPickerCell.array = months
        monthPickerCell.titleLabel.text = "Месяц"
        dayPickerCell.array = weeks
        dayPickerCell.titleLabel.text = "Неделя"
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
//        var indexPaths : Array<IndexPath> = []
//        if let previous = previousIndexPath {
//            indexPaths += [previous]
//        }
//        if let current = selectedIndexPath {
//            indexPaths += [current]
//        }
//        if indexPaths.count > 0 {
//            tableView.reloadRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
//        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! TimePickerCell).watchFrameChanges()
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! TimePickerCell).ignoreFrameChanges()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for cell in tableView.visibleCells as! [TimePickerCell] {
            cell.ignoreFrameChanges()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            
            return TimePickerCell.expandedHeight
        } else {
            return TimePickerCell.defaultHeight
        }
    }

}
