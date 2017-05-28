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

var today: Date {
    return Date()
}
var inSevenDays: Date {
    return Date(timeInterval: 518400, since: Date())
}

let lessonClassName: String = String(describing: Lesson.self)
let dayClassName: String  = String(describing: Day.self)

var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer



public protocol LessonDataDelegate: class {
    func lessonsDidLoad()
}


class ScheduleModel {
    
    weak var delegate: LessonDataDelegate!
    
//
//    func getSchedule(fromDate: Date, toDate: Date) {
//        
//        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
//            let fetchLessonsRequest: NSFetchRequest<Lesson> = Lesson.fetchRequest()
// 
//            do {
//                var lessons = try appDelegate.persistentContainer.viewContext.fetch(fetchLessonsRequest)
//                
//                var date = fromDate
//                
//                while date <= toDate {
//                    if date.dayNumberOfWeek() != 1 {
//                        
//                        let day = Day(context: appDelegate.persistentContainer.viewContext)
//                        day.date = date as NSDate
//                        
//                        for lesson in lessons {
//                            print(lessons.count)
//                            print(lesson.date!)
//                            if Calendar.current.compare(lesson.date! as Date, to: date, toGranularity: .day) == .orderedSame {
//                                day.addToLessons(lesson)
//                                lessons.remove(at: 0)
//                            } else {
//                                break
//                            }
//                        }
//                        
//                        appDelegate.saveContext()
//                    }
//                    date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
//                }
//            }
//            catch {
//                print(error)
//            }
//        }
//    }
//    
    // - You will definitely need some explanation here, I bet this is the best possible solution
    func getSchedule(fromDate: Date, toDate: Date){
        
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
                                }
                                date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                            }
                            appDelegate.saveContext()
                        }
                    }
                    OperationQueue.main.addOperation({
                        self.delegate.lessonsDidLoad()
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
    
    
    func deleteAllRecords() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: dayClassName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        let context = container?.viewContext
        
        do {
            try context?.execute(deleteRequest)
            try context?.save()
        } catch {
            print ("Error with delete request")
        }
    }

    
    func refreshBegin(refreshEnd:@escaping (Int) -> ()) {
        DispatchQueue.global(qos: .default).async() {
            sleep(1)
            DispatchQueue.main.async() {
                refreshEnd(0)
            }
        }
    }
}


func getCurrentDateTime() -> String {
    let currentDateTime = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy, HH:mm"
    return formatter.string(from: currentDateTime)
}

extension String {
    func convertStringToDate(format: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)!
    }
}

extension Date {
    func convertDateToMakeRequest() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy"
        return formatter.string(from: self)
    }
}

extension Date {
    func dayNumberOfWeek() -> Int {
        return Calendar.current.dateComponents([.weekday], from: self).weekday!
    }
    
    func dayOfWeek() -> String {
        let day = Calendar.current.dateComponents([.weekday], from: self).weekday!
        switch day {
            case 2:
                return "Понедельник"
            case 3:
                return "Вторник"
            case 4:
                return "Среда"
            case 5:
                return "Четверг"
            case 6:
                return "Пятница"
            case 7:
                return "Суббота"
            case 1:
                return "Воскресенье"
            default:
                return ""
        }
    }
}

