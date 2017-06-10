//
//  ChooseIntervalTableViewController.swift
//  HSEapp
//
//  Created by Alexander on 04/02/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

let pickerAnimationDuration = 0.40 // duration for the animation to slide the date picker into view
let datePickerTag           = 99   // view tag identifiying the date picker view

let titleKey = "title" // key for obtaining the data source item's title
let dateKey  = "date"  // key for obtaining the data source item's date value

// keep track of which rows have date cells
let dateStartRow = 0
let dateEndRow   = 1

let dateCellID   = "dateCell"   // the cells with the start or end date
let datePickerID = "datePicker" // the cell containing the date picker
let otherCell    = "otherCell"  // the remaining cells at the end

class ChooseIntervalTableViewController: UITableViewController {
    
    var intervalStart: Date = today
    var intervalEnd: Date = inSevenDays
    
    var dataArray = [[String: AnyObject]]()
    var dateFormatter: DateFormatter = {
        var _dateFormatter = DateFormatter()
        
        _dateFormatter.dateStyle = DateFormatter.Style.full // show short-style date format
        _dateFormatter.timeStyle = DateFormatter.Style.none
        
        return _dateFormatter
    }()
    
    // keep track which indexPath points to the cell with UIDatePicker
    var datePickerIndexPath: IndexPath?
    
    lazy var pickerCellRowHeight: CGFloat = {
        [unowned self] in
        
        // obtain the picker view cell's height, works because the cell was pre-defined in our storyboard
        let pickerViewCellToCheck = self.tableView.dequeueReusableCell(withIdentifier: datePickerID)
        
        return pickerViewCellToCheck!.frame.height
        }()
    
    /// Primary view has been loaded for this view controller
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup our data source
        let itemTwo = [titleKey: "С", dateKey: intervalStart] as [String : Any]
        let itemThree = [titleKey: "По", dateKey: intervalEnd] as [String : Any]
        self.dataArray = [itemTwo as Dictionary<String, AnyObject>, itemThree as Dictionary<String, AnyObject>]
        
        // if the local changes while in the background, we need to be notified so we can update the date
        // format in the table view cells
        //
        NotificationCenter.default.addObserver(self, selector: #selector(ChooseIntervalTableViewController.localeChanged(_:)), name: NSLocale.currentLocaleDidChangeNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSLocale.currentLocaleDidChangeNotification, object: nil)
    }
    
    // MARK: - Locale
    
    /// Responds to region format or locale changes.
    ///
    func localeChanged(_ notif: Notification) {
        // the user changed the locale (region format) in Settings, so we are notified here to
        // update the date format in the table view cells
        //
        self.tableView.reloadData()
    }
    
    // MARK: - Utilities
    
    /// Determines if the given indexPath has a cell below it with a UIDatePicker.
    ///
    /// - parameters:
    ///   - indexPath: The indexPath to check if its cell has a UIDatePicker below it.
    ///
    func hasPickerForIndexPath(_ indexPath: IndexPath) -> Bool {
        var hasDatePicker = false
        
        var targetedRow = indexPath.row
        targetedRow += 1
        
        let checkDatePickerCell = self.tableView.cellForRow(at: IndexPath(row: targetedRow, section: 0))
        let checkDatePicker = checkDatePickerCell?.viewWithTag(datePickerTag)
        
        hasDatePicker = checkDatePicker != nil
        return hasDatePicker
    }
    
    /// Updates the UIDatePicker's value to match with the date of the cell above it.
    ///
    func updateDatePicker() {
        if (self.datePickerIndexPath != nil) {
            let associatedDatePickerCell = self.tableView.cellForRow(at: self.datePickerIndexPath!)
            let targetedDatePicker = associatedDatePickerCell?.viewWithTag(datePickerTag) as? UIDatePicker
            
            if (targetedDatePicker != nil) {
                // we found a UIDatePicker in this cell, so update it's date value
                //
                let itemData = self.dataArray[self.datePickerIndexPath!.row - 1]
                targetedDatePicker!.setDate(itemData[dateKey] as! Date, animated: false)
            }
        }
    }
    
    /// Determines if the UITableViewController has a UIDatePicker in any of its cells.
    ///
    func hasInlineDatePicker() -> Bool {
        return self.datePickerIndexPath != nil
    }
    
    /// Determines if the given indexPath points to a cell that contains the UIDatePicker.
    ///
    /// - parameters:
    ///   - indexPath: The indexPath to check if it represents a cell with the UIDatePicker.
    ///
    func indexPathHasPicker(_ indexPath: IndexPath) -> Bool {
        return self.hasInlineDatePicker() && self.datePickerIndexPath!.row == indexPath.row
    }
    
    /// Determines if the given indexPath points to a cell that contains the start/end dates.
    ///
    /// - parameters:
    ///   - indexPath: The indexPath to check if it represents start/end date cell.
    ///
    func indexPathHasDate(_ indexPath: IndexPath)-> Bool {
        var hasDate = false
        
        if ((indexPath.row == dateStartRow) ||
            (indexPath.row == dateEndRow || (self.hasInlineDatePicker() && (indexPath.row == dateEndRow + 1))))
        {
            hasDate = true
        }
        
        return hasDate
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.indexPathHasPicker(indexPath) ? self.pickerCellRowHeight : self.tableView.rowHeight
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.hasInlineDatePicker()) {
            // we have a date picker, so allow for it in the number of rows in this section
            let numRows = self.dataArray.count
            return numRows + 1
        }
        
        return self.dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell?
        var cellID = otherCell
        
        if (self.indexPathHasPicker(indexPath)) {
            // the indexPath is the one containing the inline date picker
            cellID = datePickerID;     // the current/opened date picker cell
        } else if (self.indexPathHasDate(indexPath)) {
            // the indexPath is one that contains the date information
            cellID = dateCellID;       // the start/end date cells
        }
        
        cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        
        // if we have a date picker open whose cell is above the cell we want to update,
        // then we have one more cell than the model allows
        //
        var modelRow = indexPath.row
        if (self.datePickerIndexPath != nil && self.datePickerIndexPath!.row <= indexPath.row) {
            modelRow -= 1
        }
        
        let itemData = self.dataArray[modelRow]
        
        // proceed to configure our cell
        if (cellID == dateCellID) {
            // we have either start or end date cells, populate their date field
            //
            cell!.textLabel!.text = itemData[titleKey] as? String
            cell!.detailTextLabel!.text = self.dateFormatter.string(from: itemData[dateKey] as! Date)
        } else if (cellID == otherCell) {
            // this cell is a non-date cell, just assign it's text label
            //
            cell!.textLabel!.text = itemData[titleKey] as? String
        }
        
        return cell!
    }
    
    /// Adds or removes a UIDatePicker cell below the given indexPath.
    ///
    /// - parameters:
    ///   - indexPath: The indexPath to reveal the UIDatePicker.
    ///
    func toggleDatePickerForSelectedIndexPath(_ indexPath: IndexPath) {
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
    /// - parameters:
    ///   - indexPath: The indexPath to reveal the UIDatePicker.
    ///
    func displayInlineDatePickerForRowAtIndexPath(_ indexPath: IndexPath) {
        // display the date picker inline with the table content
        self.tableView.beginUpdates()
        
        var before = false   // indicates if the date picker is below "indexPath", help us determine which row to reveal
        if (self.hasInlineDatePicker()) {
            before = self.datePickerIndexPath!.row < indexPath.row
        }
        
        let sameCellClicked = self.datePickerIndexPath?.row == indexPath.row + 1
        
        // remove any date picker cell if it exists
        if (self.hasInlineDatePicker()) {
            self.tableView.deleteRows(at: [IndexPath(row: self.datePickerIndexPath!.row, section: 0)], with: UITableViewRowAnimation.fade)
            self.datePickerIndexPath = nil
        }
        
        if (!sameCellClicked) {
            // hide the old date picker and display the new one
            let rowToReveal = before ? indexPath.row - 1 : indexPath.row
            let indexPathToReveal = IndexPath(row:rowToReveal, section:0)
            
            self.toggleDatePickerForSelectedIndexPath(indexPathToReveal)
            self.datePickerIndexPath = IndexPath(row: indexPathToReveal.row + 1, section: 0)
        }
        
        // always deselect the row containing the start or end date
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        self.tableView.endUpdates()
        
        // inform our date picker of the current date to match the current cell
        self.updateDatePicker()
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if (cell!.reuseIdentifier == dateCellID) {
            self.displayInlineDatePickerForRowAtIndexPath(indexPath)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // MARK: - Actions
    
    /// User chose to change the date by changing the values inside the UIDatePicker.
    ///
    /// - parameters:
    ///   - sender: The sender for this action: UIDatePicker.
    ///
    @IBAction func dateAction(_ sender: UIDatePicker) {
        if (self.datePickerIndexPath != nil) {
            let targetedCellIndexPath = IndexPath(row: self.datePickerIndexPath!.row - 1, section: 0)
            let cell = self.tableView.cellForRow(at: targetedCellIndexPath)
            let targetedDatePicker = sender
            
            // update our data model
            var itemData = self.dataArray[targetedCellIndexPath.row]
            itemData[dateKey] = targetedDatePicker.date as AnyObject
            
            // update the cell's date string
            cell!.detailTextLabel!.text = self.dateFormatter.string(from: targetedDatePicker.date)
            if targetedCellIndexPath == IndexPath(row: 0, section: 0){
                intervalStart = targetedDatePicker.date
                print(intervalStart)
            } else if targetedCellIndexPath == IndexPath(row: 1, section: 0){
                intervalEnd = targetedDatePicker.date
                print(intervalEnd)
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
