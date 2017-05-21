//
//  FirstViewController.swift
//  HSEapp
//
//  Created by Alexander on 22/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class ScheduleViewController: UITableViewController, LessonCellDelegate {

    func getLessons() {
        
        
        let url = "http://92.242.58.221/ruzservice.svc/v2/personlessons?fromdate=05.15.2017&todate=05.22.2017&email=aayalunin@edu.hse.ru"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("ERROR")
            }
            
            if let content = data {
                do
                {
                    let myJSON = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    
                    if let lessonsFromJSON = myJSON["Lessons"] as? [[String: Any]]{
                        for lesson in lessonsFromJSON {
                            let date = lesson["date"] as? String
                            let dayOfWeek = lesson["dayOfWeek"] as? Int
                            let startTime = lesson["beginLesson"] as? String
                            let endTime = lesson["endLesson"] as? String
                            let type = lesson["kindOfWork"] as? String
                            let discipline = lesson["discipline"] as? String
                            let lecturer = lesson["lecturer"] as? String
                            let address = lesson["building"] as? String
                            let lectureRoom = lesson["auditorium"] as? String
                            
                            let initLesson = Lesson(date: date!, dayOfWeek: dayOfWeek!, startTime: startTime!, endTime: endTime!, type: type!, discipline: discipline!, lecturer: lecturer!, address: address!, lectureRoom: lectureRoom!)
                            lessons.append(initLesson)
                        }
                    }
                    
                    DispatchQueue.main.async{
                        self.tableView.reloadData()
                    }
                }
                catch
                {
                    
                }
            }
        }
        task.resume()
    }
    
    var w = LessonsManager()
    var sm = ScheduleModel()
    
    @IBAction func previousWeek(_ sender: Any) {
    }
    @IBAction func nextWeek(_ sender: Any) {
    }
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delaysContentTouches = false
        lastUpdateLabel.text = "Последнее обновление: " + sm.getCurrentDate()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        tableView.backgroundView = refreshControl
        getLessons()
        sm.getSchedule()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 50.0)
        }
    }
    
    func refresh(sender:AnyObject) {
        sm.refreshBegin(refreshEnd: {(x:Int) -> () in
            self.lastUpdateLabel.text = "Последнее обновление: " + self.sm.getCurrentDate()
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        })
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return scheduleData?.count ?? 0
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return scheduleData![section].lessons?.count ?? 0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if Lessons.count > 0
//        {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "lessonCell", for: indexPath)
//            
//            let lesson = Lessons[indexPath.row]
//            
//            if let lessonCell = cell as? LessonCell {
//                lessonCell.delegate = self
//                lessonCell.lesson = lesson
//            }
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "noLessonsCell", for: indexPath)
//            return cell
//        }
        
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







