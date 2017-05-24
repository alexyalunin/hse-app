//
//  FirstViewController.swift
//  HSEapp
//
//  Created by Alexander on 22/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class ScheduleViewController: UITableViewController, LessonCellDelegate, LessonDataDelegate {

    var sm = ScheduleModel()
    
    var scheduleData: [Day]?
    
    var dateStart: Date = today
    var dateEnd: Date = inSevenDays
    
    @IBOutlet weak var previousWeekButton: UIButton!
    @IBOutlet weak var nextWeekButton: UIButton!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noScheduleLabel: UILabel!
    @IBOutlet weak var bottomActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bottomNoScheduleLabel: UILabel!
    
    @IBAction func previousWeek(_ sender: Any) {
        dateStart = Date(timeInterval: -604800, since: dateStart)
        setUpForPreviousWeekButtonDidPress()
        sm.getLessons(fromDate: dateStart, toDate: dateEnd, with: email)
    }
    @IBAction func nextWeek(_ sender: Any) {
        dateEnd = Date(timeInterval: 604800, since: dateEnd)
        setUpForNextWeekButtonDidPress()
        sm.getLessons(fromDate: dateStart, toDate: dateEnd, with: email)
    }
    
    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sm.delegate = self
        
        self.tableView.delaysContentTouches = false
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        tableView.backgroundView = refreshControl
        
        setUpForViewIsLoading()
        
        sm.getLessons(fromDate: dateStart, toDate: dateEnd, with: email)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 50.0)
        }
    }

    func lessonsDidLoad(lessons: NSArray){
        scheduleData = sm.getSchedule(fromDate: dateStart, toDate: dateEnd, lessons: lessons as! [Lesson])
        tableView.reloadData()
        showElements()
    }
    
    // MARK: - Functions
    
    func refresh(sender:AnyObject) {
        sm.refreshBegin(refreshEnd: {(x:Int) -> () in
            self.dateStart = today
            self.dateEnd = inSevenDays
            self.sm.getLessons(fromDate: self.dateStart, toDate: self.dateEnd, with: email)
        })
    }

    private func showElements(){
        previousWeekButton.isHidden = false
        nextWeekButton.isHidden = false
        lastUpdateLabel.isHidden = false
        noScheduleLabel.isHidden = true
        bottomNoScheduleLabel.isHidden = true
        activityIndicator.stopAnimating()
        bottomActivityIndicator.stopAnimating()
        lastUpdateLabel.text = "Последнее обновление: " + ScheduleModel.getCurrentDate()
        self.refreshControl?.endRefreshing()
    }
    
    private func setUpForViewIsLoading(){
        previousWeekButton.isHidden = true
        nextWeekButton.isHidden = true
        lastUpdateLabel.isHidden = true
        activityIndicator.startAnimating()
        noScheduleLabel.isHidden = false
        bottomNoScheduleLabel.isHidden = true
        bottomActivityIndicator.stopAnimating()
    }
    
    private func setUpForPreviousWeekButtonDidPress(){
        previousWeekButton.isHidden = true
        lastUpdateLabel.isHidden = true
        noScheduleLabel.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func setUpForNextWeekButtonDidPress(){
        nextWeekButton.isHidden = true
        bottomNoScheduleLabel.isHidden = false
        bottomActivityIndicator.startAnimating()
    }
    
    // MARK: - Segues
    
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
    
    @IBAction func setScheduleInterval(from segue: UIStoryboardSegue) {
        if let sourceController = segue.source as? ChooseIntervalTableViewController {
            if (Calendar.current.compare(dateStart, to: sourceController.intervalStart, toGranularity: .day) != .orderedSame) ||
                (Calendar.current.compare(dateEnd, to: sourceController.intervalEnd, toGranularity: .day) != .orderedSame) {
                dateStart = sourceController.intervalStart
                dateEnd = sourceController.intervalEnd
                sm.getLessons(fromDate: dateStart, toDate: dateEnd, with: email)

                print("interval changed")
            }
        }
    }
    
    // MARK: - Table configuration

    override func numberOfSections(in tableView: UITableView) -> Int {
        return scheduleData?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if scheduleData![section].lessons.count != 0{
            return scheduleData![section].lessons.count
        } else {
            return 1
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if !((scheduleData?[indexPath.section].lessons.isEmpty)!)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lessonCell", for: indexPath)
            
            let lesson = scheduleData?[indexPath.section].lessons[indexPath.row]
            
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.full
        
        label.text = dateFormatter.string(from: (scheduleData?[section].date)!)
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightSemibold)
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    // MARK: - Table design
    
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
    
    // MARK: - LessonCellDelegate
    
    func callSegueFromCell(data: AnyObject) {
        self.performSegue(withIdentifier: "fromScheduleToMap", sender: data)
    }
    
}







