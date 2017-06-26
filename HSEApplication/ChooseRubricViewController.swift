//
//  MyTableViewController.swift
//  DateCell
//
//  Created by Calvert Yang on 11/4/15.
//  Copyright © 2015 Calvert. All rights reserved.
//

import UIKit


class ChooseCategoryViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var courseIndex = Int()
    var rubricIndex = Int()
    
    var courses = ["Все", "1", "2", "3", "4"]
    var rubrics = ["Все", "LMS", "ГИА", "Изменения в расписании", "Курсовые работы", "Оплата обучения", "Разное", "Стипендии"]
    
    
    let pickerAnimationDuration = 0.40 // duration for the animation to slide the date picker into view
    let pickerTag           = 98   // view tag identifiying the date picker view
    var pickerIndexPath: IndexPath?
    var pickerCellRowHeight: CGFloat = 216
    
    let titleKey = "title" // key for obtaining the data source item's title
    let categoryKey  = "category"  // key for obtaining the data source item's date value
    
    // keep track of which rows have date cells
    let courseRow = 0
    let rubricRow = 1
    var indexOfSelectedRow = Int()
    
    let detailCell   = "detailCell"   // the cells with the start or end date
    let pickerID     = "pickerCell" // the cell containing the date picker
    
    var dataArray = [[String: AnyObject]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let itemTwo = [titleKey: "Курс", categoryKey: courses[courseIndex]] as [String : Any]
        let itemThree = [titleKey: "Рубрика", categoryKey: rubrics[rubricIndex]] as [String : Any]
        
        self.dataArray = [itemTwo as Dictionary<String, AnyObject>, itemThree as Dictionary<String, AnyObject>]
    }
    
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if indexOfSelectedRow == 0 {
            return courses.count
        }
        return rubrics.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if indexOfSelectedRow == 0 {
            return courses[row]
        }
        return rubrics[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let targetedCellIndexPath = IndexPath(row: self.pickerIndexPath!.row - 1, section: 0)
        let cell = self.tableView.cellForRow(at: targetedCellIndexPath)
        
        if indexOfSelectedRow == 0 {
            courseIndex = row
            cell!.detailTextLabel!.text = courses[row]
            return
        }
        rubricIndex = row
        cell!.detailTextLabel!.text = rubrics[row]
    }
    
    
    // MARK: - Utilities
    
    func hasPickerForIndexPath(_ indexPath: IndexPath) -> Bool {
        var hasPicker = false
        
        var targetedRow = indexPath.row
        targetedRow += 1
        
        let checkPickerCell = self.tableView.cellForRow(at: IndexPath(row: targetedRow, section: 0))
        let checkPicker = checkPickerCell?.viewWithTag(pickerTag)
        
        hasPicker = checkPicker != nil
        return hasPicker
    }
    
    /// Updates the UIDatePicker's value to match with the date of the cell above it.
    ///
    func updatePicker() {
        if (self.pickerIndexPath != nil) {
            let associatedPickerCell = self.tableView.cellForRow(at: self.pickerIndexPath!)
            let targetedPicker = associatedPickerCell?.viewWithTag(pickerTag) as? UIPickerView
            
            if (targetedPicker != nil) {
                targetedPicker?.dataSource = self;
                targetedPicker?.delegate = self;
                if indexOfSelectedRow == 0 {
                    targetedPicker?.selectRow(courseIndex, inComponent: 0, animated: false)
                    return
                }
                targetedPicker?.selectRow(rubricIndex, inComponent: 0, animated: false)
            }
        }
    }
    
    /// Determines if the UITableViewController has a UIDatePicker in any of its cells.
    ///
    func hasInlinePicker() -> Bool {
        return self.pickerIndexPath != nil
    }
    
    /// Determines if the given indexPath points to a cell that contains the UIDatePicker.
    ///
    func indexPathHasPicker(_ indexPath: IndexPath) -> Bool {
        return self.hasInlinePicker() && self.pickerIndexPath!.row == indexPath.row
    }
    
    /// Determines if the given indexPath points to a cell that contains the start/end dates.
    ///
    func indexPathHasCategory(_ indexPath: IndexPath)-> Bool {
        var hasCategory = false
        
        if ((indexPath.row == courseRow) ||
            (indexPath.row == rubricRow || (self.hasInlinePicker() && (indexPath.row == rubricRow + 1))))
        {
            hasCategory = true
        }
        
        return hasCategory
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.indexPathHasPicker(indexPath) ? self.pickerCellRowHeight : self.tableView.rowHeight
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.hasInlinePicker()) {
            // we have a date picker, so allow for it in the number of rows in this section
            let numRows = self.dataArray.count
            return numRows + 1
        }
        
        return self.dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell?
        var cellID = detailCell
        
        
        if (self.indexPathHasPicker(indexPath)) {
            // the indexPath is the one containing the inline date picker
            cellID = pickerID;     // the current/opened date picker cell
        } else if (self.indexPathHasCategory(indexPath)) {
            // the indexPath is one that contains the date information
            cellID = detailCell;       // the start/end date cells
        }
        
        cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        // if we have a date picker open whose cell is above the cell we want to update,
        // then we have one more cell than the model allows
        //
        var modelRow = indexPath.row
        if (self.pickerIndexPath != nil && self.pickerIndexPath!.row <= indexPath.row) {
            modelRow -= 1
        }
        
        let itemData = self.dataArray[modelRow]
        
        // proceed to configure our cell
        if (cellID == detailCell) {
            // we have either start or end date cells, populate their date field
            //
            cell!.textLabel!.text = itemData[titleKey] as? String
            cell!.detailTextLabel!.text = itemData[categoryKey] as? String
        }
        return cell!
    }
    
    /// Adds or removes a UIDatePicker cell below the given indexPath.
    ///
    func togglePickerForSelectedIndexPath(_ indexPath: IndexPath) {
        self.tableView.beginUpdates()
        
        let indexPaths = [IndexPath(row: indexPath.row + 1, section: 0)]
        
        // check if 'indexPath' has an attached date picker below it
        if (self.hasPickerForIndexPath(indexPath)) {
            // found a picker below it, so remove it
            self.tableView.deleteRows(at: indexPaths, with: UITableViewRowAnimation.fade)
        } else {
            // didn't find a picker below it, so we should insert it
            self.tableView.insertRows(at: indexPaths, with: UITableViewRowAnimation.fade)
        }
        
        self.tableView.endUpdates()
    }
    
    /// Reveals the date picker inline for the given indexPath, called by "didSelectRowAtIndexPath".
    ///
    func displayInlinePickerForRowAtIndexPath(_ indexPath: IndexPath) {
        // display the date picker inline with the table content
        self.tableView.beginUpdates()
        
        var before = false   // indicates if the date picker is below "indexPath", help us determine which row to reveal
        if (self.hasInlinePicker()) {
            before = self.pickerIndexPath!.row < indexPath.row
        }
        
        let sameCellClicked = self.pickerIndexPath?.row == indexPath.row + 1
        
        // remove any date picker cell if it exists
        if (self.hasInlinePicker()) {
            self.tableView.deleteRows(at: [IndexPath(row: self.pickerIndexPath!.row, section: 0)], with: UITableViewRowAnimation.fade)
            self.pickerIndexPath = nil
        }
        
        if (!sameCellClicked) {
            // hide the old date picker and display the new one
            let rowToReveal = before ? indexPath.row - 1 : indexPath.row
            let indexPathToReveal = IndexPath(row:rowToReveal, section:0)
            
            self.togglePickerForSelectedIndexPath(indexPathToReveal)
            self.pickerIndexPath = IndexPath(row: indexPathToReveal.row + 1, section: 0)
        }
        
        // always deselect the row containing the start or end date
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        self.tableView.endUpdates()
        
        // inform our date picker of the current date to match the current cell
        self.updatePicker()
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexOfSelectedRow = indexPath.row
        let cell = tableView.cellForRow(at: indexPath)
        if (cell!.reuseIdentifier == detailCell) {
            self.displayInlinePickerForRowAtIndexPath(indexPath)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


