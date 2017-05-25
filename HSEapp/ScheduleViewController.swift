//
//  FirstViewController.swift
//  HSEapp
//
//  Created by Alexander on 22/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class ScheduleViewController: UITableViewController, LessonCellDelegate, LessonDataDelegate {

    private var sm = ScheduleModel()
    
    private var scheduleData: [Day] = []
    
    public var dateStart: Date = today
    public var dateEnd: Date   = inSevenDays
    
    // TODO: - In order to get new data without overriding the existing one I use variables _dateStart, _dateEnd to make requests with special interval and then boolean variables to define where the request has been sent from in lessonsDidLoad, you can find better solution
    private var _dateStart: Date?
    private var _dateEnd: Date?
    private var previousWeekButtonDidPress = false
    private var nextWeekButtonDidPress = false
    
    @IBOutlet weak var previousWeekButton: UIButton!
    @IBOutlet weak var nextWeekButton: UIButton!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var topActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var topNoScheduleLabel: UILabel!
    @IBOutlet weak var bottomActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bottomNoScheduleLabel: UILabel!
    
    @IBAction func previousWeekButtonDidPress(_ sender: Any) {
        setUpForPreviousWeekButtonDidPress()
        _dateEnd   = Date(timeInterval: -86400, since: dateStart)
        dateStart  = Date(timeInterval: -604800, since: dateStart)
        sm.getLessons(fromDate: dateStart, toDate: _dateEnd!)
    }
    @IBAction func nextWeekButtonDidPress(_ sender: Any) {
        setUpForNextWeekButtonDidPress()
        _dateStart = Date(timeInterval: 86400, since: dateEnd)
        dateEnd    = Date(timeInterval: 604800, since: dateEnd)
        sm.getLessons(fromDate: _dateStart!, toDate: dateEnd)
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
        
        sm.getLessons(fromDate: dateStart, toDate: dateEnd)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 50.0)
        }
    }

    // MARK: - LessonDataDelegate
    
    func lessonsDidLoad(lessons: NSArray) {
        if previousWeekButtonDidPress {
            var newScheduleData = sm.getSchedule(fromDate: dateStart, toDate: _dateEnd!, lessons: lessons as! [Lesson])
            newScheduleData.append(contentsOf: scheduleData)
            scheduleData = newScheduleData
            previousWeekButtonDidPress = false
            
        } else if nextWeekButtonDidPress {
            let newScheduleData = sm.getSchedule(fromDate: _dateStart!, toDate: dateEnd, lessons: lessons as! [Lesson])
            scheduleData.append(contentsOf: newScheduleData)
            nextWeekButtonDidPress = false
            
        } else {
            scheduleData = sm.getSchedule(fromDate: dateStart, toDate: dateEnd, lessons: lessons as! [Lesson])
        }
        
        tableView.reloadData()
        showElements()
    }
    
    // MARK: - Functions
    
    func refresh(sender:AnyObject) {
        sm.refreshBegin(refreshEnd: {(x:Int) -> () in
            self.dateStart = today
            self.dateEnd   = inSevenDays
            self.sm.getLessons(fromDate: self.dateStart, toDate: self.dateEnd)
        })
    }

    private func showElements(){
        previousWeekButton.isHidden    = false
        nextWeekButton.isHidden        = false
        lastUpdateLabel.isHidden       = false
        topNoScheduleLabel.isHidden    = true
        bottomNoScheduleLabel.isHidden = true
        topActivityIndicator.stopAnimating()
        bottomActivityIndicator.stopAnimating()
        refreshControl?.endRefreshing()
        lastUpdateLabel.text = "Последнее обновление: " + getCurrentDateTime()
    }
    
    private func setUpForViewIsLoading(){
        previousWeekButton.isHidden    = true
        nextWeekButton.isHidden        = true
        lastUpdateLabel.isHidden       = true
        topNoScheduleLabel.isHidden    = false
        bottomNoScheduleLabel.isHidden = true
        topActivityIndicator.startAnimating()
        bottomActivityIndicator.stopAnimating()
    }
    
    private func setUpForPreviousWeekButtonDidPress(){
        previousWeekButtonDidPress     = true
        previousWeekButton.isHidden    = true
        lastUpdateLabel.isHidden       = true
        topNoScheduleLabel.isHidden    = false
        topActivityIndicator.startAnimating()
    }
    
    private func setUpForNextWeekButtonDidPress(){
        nextWeekButtonDidPress         = true
        nextWeekButton.isHidden        = true
        bottomNoScheduleLabel.isHidden = false
        bottomActivityIndicator.startAnimating()
    }
    
    // MARK: - LessonCellDelegate
    
    func callSegueFromCell(data: AnyObject) {
        self.performSegue(withIdentifier: "From schedule to map", sender: data)
    }
    
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "From schedule to map" {
            let destinationNavigationController = segue.destination as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! MapViewController
            targetController.address = sender as! String
            
        } else if segue.identifier == "From schedule to set interval" {
            let destinationNavigationController = segue.destination as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! ChooseIntervalTableViewController
            targetController.intervalStart = dateStart
            targetController.intervalEnd   = dateEnd
        }
    }
    
    @IBAction func setScheduleInterval(from segue: UIStoryboardSegue) {
        
        if let sourceController = segue.source as? ChooseIntervalTableViewController {
            // TODO: - It is possible not to just clean all data and load new one, but to compare the dates, make a request with the interval which is outside of the interval of the data and append/insert new data to the existing one
            if (Calendar.current.compare(dateStart, to: sourceController.intervalStart, toGranularity: .day) != .orderedSame) || (Calendar.current.compare(dateEnd, to: sourceController.intervalEnd, toGranularity: .day) != .orderedSame) {
                
                setUpForViewIsLoading()
                scheduleData.removeAll()
                tableView.reloadData()
                
                dateStart = sourceController.intervalStart
                dateEnd   = sourceController.intervalEnd
                
                sm.getLessons(fromDate: dateStart, toDate: dateEnd)
            }
        }
    }
    
    // MARK: - Table configuration

    override func numberOfSections(in tableView: UITableView) -> Int {
        return scheduleData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if scheduleData[section].lessons.count != 0{
            return scheduleData[section].lessons.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if !(scheduleData[indexPath.section].lessons.isEmpty)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lessonCell", for: indexPath)
            
            let lesson = scheduleData[indexPath.section].lessons[indexPath.row]
            
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
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        
        label.text = scheduleData[section].date.dayOfWeek() + ", " + formatter.string(from: scheduleData[section].date)
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
    
}







