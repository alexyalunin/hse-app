//
//  FirstViewController.swift
//  HSEapp
//
//  Created by Alexander on 22/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//
import UIKit
import CoreData


class ScheduleViewController: UITableViewController, LessonCellDelegate, ScheduleDataDelegate {
    
    private var sm = ScheduleModel()
    private var scheduleData = [Day]()
    
    
    public var dateStart: Date {
        get {
            return UserDefaults.standard.value(forKey: "dateStart") as! Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "dateStart")
        }
    }
    
    public var dateEnd: Date {
        get {
            return UserDefaults.standard.value(forKey: "dateEnd") as! Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "dateEnd")
        }
    }
    
    private var previousWeekButtonDidPress = false
    private var nextWeekButtonDidPress     = false
    
    
    @IBOutlet weak var previousWeekButton: UIButton!
    @IBOutlet weak var nextWeekButton: UIButton!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var topActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var topNoScheduleLabel: UILabel!
    @IBOutlet weak var bottomActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bottomNoScheduleLabel: UILabel!
    
    
    @IBAction func previousWeekButtonDidPress(_ sender: Any) {
        setUpForPreviousWeekButtonDidPress()
        let _dateEnd  = Date(timeInterval: -60*60*24, since: dateStart)
        dateStart  = Date(timeInterval: -60*60*24*7, since: dateStart)
        sm.getSchedule(fromDate: dateStart, toDate: _dateEnd)
    }
    @IBAction func nextWeekButtonDidPress(_ sender: Any) {
        setUpForNextWeekButtonDidPress()
        let _dateStart = Date(timeInterval: 60*60*24, since: dateEnd)
        dateEnd    = Date(timeInterval: 60*60*24*7, since: dateEnd)
        sm.getSchedule(fromDate: _dateStart, toDate: dateEnd)
    }
    
    
    // MARK: - Controller lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sm.delegate = self
        
        self.tableView.delaysContentTouches = false
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        tableView.backgroundView = refreshControl
        
        showElements()
        
        scheduleData = CoreDataModel.loadDaysFromDatabase()!
        
        if scheduleData.isEmpty {
            setUpForViewIsLoading()
            dateStart = today
            dateEnd   = inSevenDays
            sm.getSchedule(fromDate: dateStart, toDate: dateEnd)
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "hasEnteredEmail") {
            if let lastUpdate = UserDefaults.standard.string(forKey: "lastUpdate") {
                lastUpdateLabel.text = "Последнее обновление: " + lastUpdate
            }
            return
        }
        
        if let authVC =
            storyboard?.instantiateViewController(withIdentifier: "AuthViewController")
                as? AuthViewController {
            present(authVC, animated: true, completion: nil)
        }
    }

    
    // MARK: - LessonDataDelegate
    

    func scheduleDidLoad(days: [Day]) {
        if previousWeekButtonDidPress {
            scheduleData.insert(contentsOf: days, at: 0)
            self.tableView?.beginUpdates()
            self.tableView?.insertSections(IndexSet(0...5), with: .fade)
            self.tableView?.endUpdates()
            previousWeekButtonDidPress = false
            
        } else if nextWeekButtonDidPress {
            scheduleData.append(contentsOf: days)
            self.tableView?.beginUpdates()
            let lastIndex = tableView.numberOfSections
            self.tableView?.insertSections(IndexSet(lastIndex...lastIndex + 5), with: .fade)
            self.tableView?.endUpdates()
            nextWeekButtonDidPress = false
            
        } else {
            scheduleData = days
            tableView.reloadData()
        }
        
        updateLastUpdateLabel()
        showElements()
        CoreDataModel.printScheduleDatabaseStats()
    }

    
    // MARK: - Functions
    
    
    func refresh(sender:AnyObject) {
        refreshBegin(refreshEnd: {(x:Int) -> () in
            self.dateStart = today
            self.dateEnd   = inSevenDays
            CoreDataModel.deleteRecordsOfEntity(dayClassName)
            self.sm.getSchedule(fromDate: self.dateStart, toDate: self.dateEnd)
        })
    }
    
    func updateLastUpdateLabel(){
        UserDefaults.standard.set(getCurrentDateTime(), forKey: "lastUpdate")
        lastUpdateLabel.text = "Последнее обновление: " + UserDefaults.standard.string(forKey: "lastUpdate")!
    }
    
    func showElements(){
        previousWeekButton.isHidden    = false
        nextWeekButton.isHidden        = false
        lastUpdateLabel.isHidden       = false
        topNoScheduleLabel.isHidden    = true
        bottomNoScheduleLabel.isHidden = true
        topActivityIndicator.stopAnimating()
        bottomActivityIndicator.stopAnimating()
        refreshControl?.endRefreshing()
    }
    
    func setUpForViewIsLoading(){
        previousWeekButton.isHidden    = true
        nextWeekButton.isHidden        = true
        lastUpdateLabel.isHidden       = true
        topNoScheduleLabel.isHidden    = false
        bottomNoScheduleLabel.isHidden = true
        topActivityIndicator.startAnimating()
        bottomActivityIndicator.stopAnimating()
    }
    
    func setUpForPreviousWeekButtonDidPress(){
        previousWeekButton.isHidden    = true
        lastUpdateLabel.isHidden       = true
        topNoScheduleLabel.isHidden    = false
        topActivityIndicator.startAnimating()
        previousWeekButtonDidPress     = true
    }
    
    func setUpForNextWeekButtonDidPress(){
        nextWeekButton.isHidden        = true
        bottomNoScheduleLabel.isHidden = false
        bottomActivityIndicator.startAnimating()
        nextWeekButtonDidPress         = true
    }
    
    
    // MARK: - LessonCellDelegate
    
    
    func callSegueFromCell(data: AnyObject) {
        self.performSegue(withIdentifier: "From schedule to map", sender: data)
    }

    
    // MARK: - Segues
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "From schedule to map":
            let destinationNavigationController = segue.destination as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! MapViewController
            targetController.address = sender as! String

        case "From schedule to set interval":
            let destinationNavigationController = segue.destination as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! ChooseIntervalTableViewController
            targetController.intervalStart = dateStart
            targetController.intervalEnd   = dateEnd
        
        default:
            return
        }
    }
    
    @IBAction func setScheduleInterval(from segue: UIStoryboardSegue) {
        if let sourceController = segue.source as? ChooseIntervalTableViewController {
            // TODO: - It is possible instead of cleaning all data and loading new one, compare the dates, make a request with the interval which is outside of the interval of the data and append/insert new data to the existing one
            if (Calendar.current.compare(dateStart, to: sourceController.intervalStart, toGranularity: .day) != .orderedSame) || (Calendar.current.compare(dateEnd, to: sourceController.intervalEnd, toGranularity: .day) != .orderedSame) {
                
                setUpForViewIsLoading()
                scheduleData.removeAll()
                tableView.reloadData()
                
                dateStart = sourceController.intervalStart
                dateEnd   = sourceController.intervalEnd
                
                CoreDataModel.deleteRecordsOfEntity(dayClassName)
                sm.getSchedule(fromDate: dateStart, toDate: dateEnd)
            }
        }
    }
    
    
    // MARK: - Table configuration
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return scheduleData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if scheduleData[section].lessons!.count != 0{
            return scheduleData[section].lessons!.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (scheduleData[indexPath.section].lessons?.count)! > 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lessonCell", for: indexPath)
            
            let lesson = scheduleData[indexPath.section].lessons?[indexPath.row]
            
            if let lessonCell = cell as? LessonCell {
                lessonCell.delegate = self
                lessonCell.lesson = lesson as? Lesson
            }
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "noLessonsCell", for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = makeHeaderWithDate(tableView: tableView, date: scheduleData[section].date! as Date, dateStyle: .full)
        return header
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
