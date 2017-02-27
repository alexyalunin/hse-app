//
//  FirstViewController.swift
//  HSEapp
//
//  Created by Alexander on 22/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var w = LessonsManager()
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var previousWeek: SecondaryButton!
    @IBOutlet weak var scheduleTableView: UITableView!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scheduleTableView.backgroundColor = UIColor.clear
        self.scheduleTableView.delaysContentTouches = false
        lastUpdateLabel.text = "Последнее обновление: " + getCurrentDate()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        scheduleTableView.backgroundView = refreshControl
    }
    
    func refresh(sender:AnyObject) {
        lastUpdateLabel.text = "Последнее обновление: " + getCurrentDate()
        self.scheduleTableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    func getCurrentDate() -> String {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, HH:mm"
        return formatter.string(from: currentDateTime)
    }
    
    // MARK: Table configuration
    
    // By classes:
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return w.week.days.count
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if w.week.days[section].lessons!.count > 0
//        {
//            return w.week.days[section].lessons!.count
//        } else{
//            return 1
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        if w.week.days[indexPath.section].lessons!.count > 0
//        {
//            let cell = scheduleTableView.dequeueReusableCell(withIdentifier: "lessonCell", for: indexPath)
//            
//            let lesson = w.week.days[indexPath.section].lessons?[indexPath.row]
//            
//            if let lessonCell = cell as? LessonCell{
//                lessonCell.setUpLessonCellWith(lesson: lesson!)
//            }
//            return cell
//        } else {
//           let cell = scheduleTableView.dequeueReusableCell(withIdentifier: "noLessonsCell", for: indexPath)
//            return cell
//        }
//        
//    }
//    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return w.week.days[section].date
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
//        headerView.backgroundColor = headerColor
//        
//        let label = UILabel(frame: CGRect(x: 15,y: 0, width: tableView.bounds.size.width, height: 30))
//        label.text = String(describing: w.week.days[section].date)
//        label.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightSemibold)
//        
//        headerView.addSubview(label)
//        
//        return headerView
//    }
    
    // By JSON:
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return scheduleDataJSON.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if scheduleDataJSON[section]["lessons"].count > 0
        {
            return scheduleDataJSON[section]["lessons"].count
        } else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if scheduleDataJSON[indexPath.section]["lessons"].count > 0
        {
            let cell = scheduleTableView.dequeueReusableCell(withIdentifier: "lessonCell", for: indexPath)
            
            let lesson = scheduleDataJSON[indexPath.section]["lessons"][indexPath.row]
            
            if let lessonCell = cell as? LessonCell{
                lessonCell.setUpLessonCellWith(lesson: lesson)
            }
            return cell
        } else {
            let cell = scheduleTableView.dequeueReusableCell(withIdentifier: "noLessonsCell", for: indexPath)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = headerColor
        
        let label = UILabel(frame: CGRect(x: 15,y: 0, width: tableView.bounds.size.width, height: 30))
        label.text = scheduleDataJSON[section]["date"].string
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightSemibold)
        
        headerView.addSubview(label)
        
        return headerView
    }

    // Design stuff
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 25))
        footerView.backgroundColor = UIColor.clear
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}







