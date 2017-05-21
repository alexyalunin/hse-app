//
//  FirstViewController.swift
//  HSEapp
//
//  Created by Alexander on 22/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class ScheduleViewController: UITableViewController, LessonCellDelegate {

    var sm = ScheduleModel()
    
    @IBAction func setScheduleInterval(from segue: UIStoryboardSegue) {
        if let sourceController = segue.source as? ChooseIntervalTableViewController {
            if (Calendar.current.compare(dateStart, to: sourceController.intervalStart, toGranularity: .day) != .orderedSame) ||
                (Calendar.current.compare(dateEnd, to: sourceController.intervalEnd, toGranularity: .day) != .orderedSame) {
                dateStart = sourceController.intervalStart
                dateEnd = sourceController.intervalEnd
                reloadTableWithData()
                print("interval changed")
            }
        }
    }
    
    var dateStart: Date = today
    var dateEnd: Date = inSevenDays
    
    private func reloadTableWithData() {
        sm.getSchedule(from: dateStart, to: dateEnd, with: email)
        tableView.reloadData()
    }
    
    @IBAction func previousWeek(_ sender: Any) {
        dateStart = Date(timeInterval: -604800, since: dateStart)
        reloadTableWithData()
    }
    @IBAction func nextWeek(_ sender: Any) {
        dateEnd = Date(timeInterval: 604800, since: dateEnd)
        reloadTableWithData()
    }
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delaysContentTouches = false
        lastUpdateLabel.text = "Последнее обновление: " + sm.getCurrentDate()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        tableView.backgroundView = refreshControl
        
        sm.getSchedule(from: today, to: inSevenDays, with: email)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 50.0)
        }
    }
    
    func refresh(sender:AnyObject) {
        sm.refreshBegin(refreshEnd: {(x:Int) -> () in
            self.dateStart = today
            self.dateEnd = inSevenDays
            self.sm.getSchedule(from: today, to: inSevenDays, with: email)
            self.lastUpdateLabel.text = "Последнее обновление: " + self.sm.getCurrentDate()
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        })
    }
    
    // MARK: Table configuration

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return scheduleData?.count ?? 0
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return scheduleData![section].lessons?.count ?? 0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (scheduleData?[indexPath.section].lessons?.count)! > 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lessonCell", for: indexPath)
            
            let lesson = scheduleData?[indexPath.section].lessons?[indexPath.row]
            
            if let lessonCell = cell as? LessonCell {
                lessonCell.delegate = self
                lessonCell.lesson = lesson
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "noLessonsCell", for: indexPath)
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = headerColor
        
        let label = UILabel(frame: CGRect(x: 15,y: 0, width: tableView.bounds.size.width, height: 30))
        label.text = scheduleData?[section].date
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightSemibold)
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    // MARK: - LessonCellDelegate
    
    func callSegueFromCell(data: AnyObject) {
        self.performSegue(withIdentifier: "fromScheduleToMap", sender: data)
        
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "fromScheduleToMap" {
            let vc = segue.destination as! MapViewController
            vc.address = "kirpichnaya 33"
        } else if segue.identifier == "From schedule to set interval" {
            let destinationNavigationController = segue.destination as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! ChooseIntervalTableViewController
            targetController.intervalStart = dateStart
            targetController.intervalEnd = dateEnd
        }
    }
    
    // Design stuff
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 25))
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 25
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}







