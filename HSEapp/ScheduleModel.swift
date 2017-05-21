//
//  ScheduleModel.swift
//  HSEmanager
//
//  Created by Alexander on 19/05/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation

var scheduleData: [Day]?

class ScheduleModel {
    
    private var lessons = [Lesson]()
    
    func getSchedule(from: Date, to: Date, with _email: String) {
        
        let lessons: [Lesson] = getLessons(from: from, to: to, with: _email)
        let days: [Day] = getDays(from: lessons)
        print(days.count)
        print(lessons.count)
        scheduleData = days
        
        // MARK: Change this
        self.lessons = []
        
    }
    
    private func getLessons(from: Date, to: Date, with email: String) -> [Lesson] {
        
        let fromDate = convertDateToMakeRequest(date: from)
        let toDate = convertDateToMakeRequest(date: to)
        
        let url = "http://92.242.58.221/ruzservice.svc/v2/personlessons?fromdate=\(fromDate)&todate=\(toDate)&email=\(email)"
        
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
                            self.lessons.append(initLesson)
                        }
                    }
                    
                    
                }
                catch
                {
                    
                }
//                OperationQueue.main.addOperation({
//                    self.tableView.reloadData()
//                })
            }
        }
        task.resume()
        
        return lessons
    }

    private func getDays(from lessons:[Lesson]) -> [Day] {
        
        var thisDate: String?
        var lastDate: String?
        var lessonsForDay: [Lesson] = []
        var days: [Day] = []
        
        func addDay() {
            let day = Day(date: lastDate!, lessons: lessonsForDay)
            days.append(day)
        }
        
        if !lessons.isEmpty{
            for lesson in lessons {
                thisDate = lesson.date
                
                if lessonsForDay.isEmpty {
                    lessonsForDay.append(lesson)
                } else if thisDate == lastDate {
                    lessonsForDay.append(lesson)
                } else {
                    addDay()
                    lessonsForDay = [lesson]
                }
                lastDate = thisDate
            }
            
            if !lessonsForDay.isEmpty{
                addDay()
            }
        }
        
        return days
    }

    func convertDateToMakeRequest(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy"
        let result = formatter.string(from: date)
        return result
    }
        
    func refreshBegin(refreshEnd:@escaping (Int) -> ()) {
        DispatchQueue.global(qos: .default).async() {
            print("refreshing")
            sleep(1)
            DispatchQueue.main.async() {
                refreshEnd(0)
            }
        }
    }
    
    func getCurrentDate() -> String {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, HH:mm"
        return formatter.string(from: currentDateTime)
    }
    
//    func getDate(){
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MM.dd.yyyy"
//        let someDateTime = formatter.date(from: "05.22.2017")
//    }
    
}
