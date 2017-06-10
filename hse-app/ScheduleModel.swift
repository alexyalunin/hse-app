//
//  ScheduleModel.swift
//  HSEmanager
//
//  Created by Alexander on 19/05/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit
import Foundation
import CoreData


public protocol ScheduleDataDelegate: class {
    func scheduleDidLoad(days: [Day])
}


class ScheduleModel {
    weak var delegate: ScheduleDataDelegate!

    func getSchedule(fromDate: Date, toDate: Date) {
        var days = [Day]()
        
        let dateStart = fromDate.convertDateToMakeRequest()
        let dateEnd   = toDate.convertDateToMakeRequest()
        
        let url = "http://92.242.58.221/ruzservice.svc/v2/personlessons?fromdate=\(dateStart)&todate=\(dateEnd)&email=\(email ?? "")"
        
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
                    
                    if var lessonsFromJSON = myJSON["Lessons"] as? [[String: Any]] {
                        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                            
                            var date = fromDate
                            
                            while date <= toDate {
                                if date.dayNumberOfWeek() != 1 {
                                    let day = Day(context: appDelegate.persistentContainer.viewContext)
                                    day.date = date as NSDate
                                    
                                    for lessonJSON in lessonsFromJSON {
                                        let lessonJSONDate = (lessonJSON["date"] as? String)?.convertStringToDate(format: "yyyy.MM.dd") as NSDate?
                                        
                                        if Calendar.current.compare(lessonJSONDate! as Date, to: date, toGranularity: .day) == .orderedSame {
                                            
                                            let lesson = Lesson(context: appDelegate.persistentContainer.viewContext)
                                            
                                            lesson.date        = (lessonJSON["date"] as? String)?.convertStringToDate(format: "yyyy.MM.dd") as NSDate?
                                            lesson.startTime   = lessonJSON["beginLesson"] as? String
                                            lesson.endTime     = lessonJSON["endLesson"] as? String
                                            lesson.type        = lessonJSON["kindOfWork"] as? String
                                            lesson.discipline  = lessonJSON["discipline"] as? String
                                            lesson.lecturer    = lessonJSON["lecturer"] as? String
                                            lesson.address     = lessonJSON["building"] as? String
                                            lesson.lectureRoom = lessonJSON["auditorium"] as? String
                                            
                                            day.addToLessons(lesson)
                                            lessonsFromJSON.remove(at: 0)
                                            
                                        } else {
                                            break
                                        }
                                    }
                                    days.append(day)
                                }
                                date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                            }
                            appDelegate.saveContext()
                        }
                    }
                    OperationQueue.main.addOperation({
                        self.delegate.scheduleDidLoad(days: days)
                    })
                }
                catch
                {
                    print("ERROR_2")
                }
            }
        }
        task.resume()
    }

}




