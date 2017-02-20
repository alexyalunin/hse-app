//
//  ChooseRubricViewController.swift
//  HSEapp
//
//  Created by Alexander on 07/02/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class ChooseRubricViewController: UITableViewController {
   
    var selectedIndexPath: IndexPath?
    
    var courses = [1, 2, 3, 4]
    var categories = ["LMS", "ГИА", "Изменения в расписании", "Курсовые работы", "Оплата обучения", "Разное", "Стипендии"]


    @IBOutlet weak var coursePickerCell: TimePickerCell!
    @IBOutlet weak var categoryPickerCell: TimePickerCell!

    
    override func viewDidLoad() {

        let stringCourses = courses.map
        {
                String($0)
        }
        
        coursePickerCell.array = stringCourses
        coursePickerCell.titleLabel.text = "Курс"
        categoryPickerCell.array = categories
        categoryPickerCell.titleLabel.text = "Рубрика"
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
        return 2
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
