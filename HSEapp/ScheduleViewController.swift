//
//  FirstViewController.swift
//  HSEapp
//
//  Created by Alexander on 22/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit
import CoreData

class ScheduleViewController: UITableViewController, LessonCellDelegate, LessonDataDelegate, NSFetchedResultsControllerDelegate {
    
    
    private var sm = ScheduleModel()
    var fetchedResultsController: NSFetchedResultsController<Day>!
    
    
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
    
    
    @IBOutlet weak var previousWeekButton: UIButton!
    @IBOutlet weak var nextWeekButton: UIButton!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var topActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var topNoScheduleLabel: UILabel!
    @IBOutlet weak var bottomActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bottomNoScheduleLabel: UILabel!
    
    
    @IBAction func previousWeekButtonDidPress(_ sender: Any) {
        setUpForPreviousWeekButtonDidPress()
        let _dateEnd = Date(timeInterval: -86400, since: dateStart)
        dateStart    = Date(timeInterval: -604800, since: dateStart)
        sm.getSchedule(fromDate: dateStart, toDate: _dateEnd)
    }
    
    @IBAction func nextWeekButtonDidPress(_ sender: Any) {
        setUpForNextWeekButtonDidPress()
        let _dateStart = Date(timeInterval: 86400, since: dateEnd)
        dateEnd        = Date(timeInterval: 604800, since: dateEnd)
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
        loadDays()
        
        if (fetchedResultsController.fetchedObjects?.isEmpty)! {
            
            setUpForViewIsLoading()
            dateStart = today
            dateEnd = inSevenDays
            sm.getSchedule(fromDate: dateStart, toDate: dateEnd)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 0.0)
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
    
    
    func lessonsDidLoad() {
        loadDays()
        tableView.reloadData()
        showElements()
        
        makeUpdate()
        printDatabaseStats()
    }
    
    
    
    // MARK: - Core Data
    
    
    private func loadDays() {
        let request: NSFetchRequest<Day> = Day.fetchRequest()
        
        let sectionSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sectionSortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: container!.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }

    
    private func printDatabaseStats() {
        if let context = container?.viewContext {
            if let daysCount = try? context.count(for: Day.fetchRequest()) {
                print("\(daysCount) days")
            }
            if let lessonsCount = try? context.count(for: Lesson.fetchRequest()) {
                print("\(lessonsCount) lessons")
            }
        }
    }

    
    
    // MARK: - Functions
    
    
    private func makeUpdate(){
        UserDefaults.standard.set(getCurrentDateTime(), forKey: "lastUpdate")
        lastUpdateLabel.text = "Последнее обновление: " + UserDefaults.standard.string(forKey: "lastUpdate")!
    }
    
    func refresh(sender:AnyObject) {
        sm.refreshBegin(refreshEnd: {(x:Int) -> () in
            self.dateStart = today
            self.dateEnd   = inSevenDays
            self.sm.deleteAllRecords()
            self.sm.getSchedule(fromDate: self.dateStart, toDate: self.dateEnd)
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
        previousWeekButton.isHidden    = true
        lastUpdateLabel.isHidden       = true
        topNoScheduleLabel.isHidden    = false
        topActivityIndicator.startAnimating()
    }
    
    private func setUpForNextWeekButtonDidPress(){
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
            // TODO: - It is possible instead of cleaning all data and loading new one, compare the dates, make a request with the interval which is outside of the interval of the data and append/insert new data to the existing one
            if (Calendar.current.compare(dateStart, to: sourceController.intervalStart, toGranularity: .day) != .orderedSame) || (Calendar.current.compare(dateEnd, to: sourceController.intervalEnd, toGranularity: .day) != .orderedSame) {
                
                setUpForViewIsLoading()
                sm.deleteAllRecords()
                tableView.reloadData()
                
                dateStart = sourceController.intervalStart
                dateEnd   = sourceController.intervalEnd
                
                sm.deleteAllRecords()
                sm.getSchedule(fromDate: dateStart, toDate: dateEnd)
            }
        }
    }
    
    
    
    // MARK: - Table configuration
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return (fetchedResultsController.fetchedObjects?.count)!
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let day = fetchedResultsController.fetchedObjects?[section] {
            
            if day.lessons?.count != 0 {
                return day.lessons!.count
            } else {
                return 1
            }
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let day = fetchedResultsController.fetchedObjects?[indexPath.section] {
            
            if (day.lessons?.count)! > 0
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "lessonCell", for: indexPath)
                
                let lesson = day.lessons?[indexPath.row]
                
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "noLessonsCell", for: indexPath)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = headerColor
        
        let label = UILabel(frame: CGRect(x: 15,y: 0, width: tableView.bounds.size.width, height: 30))
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.full
        
        if let day = fetchedResultsController.fetchedObjects?[section] {
            label.text = (formatter.string(from: day.date! as Date)).uppercased()

        }
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
 
    
    
//    
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
//    }
//    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//        switch type {
//        case .insert: tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
//        case .delete: tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
//        default: break
//        }
//    }
//    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch type {
//        case .insert:
//            tableView.insertRows(at: [newIndexPath!], with: .fade)
//        case .delete:
//            tableView.deleteRows(at: [indexPath!], with: .fade)
//        case .update:
//            tableView.reloadRows(at: [indexPath!], with: .fade)
//        case .move:
//            tableView.deleteRows(at: [indexPath!], with: .fade)
//            tableView.insertRows(at: [newIndexPath!], with: .fade)
//        }
//    }
//    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
//    }
}







