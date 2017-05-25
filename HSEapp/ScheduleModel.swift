//
//  ScheduleModel.swift
//  HSEmanager
//
//  Created by Alexander on 19/05/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation

var today: Date {
    return Date()
}
var inSevenDays: Date {
    return Date(timeInterval: 518400, since: Date())
}


public protocol LessonDataDelegate: class {
    func lessonsDidLoad(lessons: NSArray)
}


class ScheduleModel {
    
    weak var delegate: LessonDataDelegate!
    
    func getSchedule(fromDate: Date, toDate: Date, lessons: [Lesson]) -> [Day] {
        var localLessons: [Lesson] = lessons
        var date = fromDate
        var days: [Day] = []
        
        while date <= toDate {
            if date.dayNumberOfWeek() != 1 {
                var dayLessons: [Lesson] = []
                for lesson in localLessons {
                    if Calendar.current.compare(lesson.date, to: date, toGranularity: .day) == .orderedSame {
                        dayLessons.append(lesson)
                        localLessons.remove(at: 0)
                    } else {
                        break
                    }
                }
                let day = Day(date: date, lessons: dayLessons)
                days.append(day)
            }
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }
        
        return days
    }
    
    func getLessons(fromDate: Date, toDate: Date){
        var lessons: [Lesson] = []
        
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
                    
                    if let lessonsFromJSON = myJSON["Lessons"] as? [[String: Any]]{
                        for lesson in lessonsFromJSON {
                            let dateString  = lesson["date"] as? String
                            let dayOfWeek   = lesson["dayOfWeek"] as? Int
                            let startTime   = lesson["beginLesson"] as? String
                            let endTime     = lesson["endLesson"] as? String
                            let type        = lesson["kindOfWork"] as? String
                            let discipline  = lesson["discipline"] as? String
                            let lecturer    = lesson["lecturer"] as? String
                            let address     = lesson["building"] as? String
                            let lectureRoom = lesson["auditorium"] as? String
                            
                            let date = dateString?.convertStringToDate(format: "yyyy.MM.dd")
                            
                            let initLesson = Lesson(date: date!, dayOfWeek: dayOfWeek!, startTime: startTime!, endTime: endTime!, type: type!, discipline: discipline!, lecturer: lecturer!, address: address!, lectureRoom: lectureRoom!)
                            
                            lessons.append(initLesson)
                            print(initLesson.discipline)
                        }
                    }
                    OperationQueue.main.addOperation({
                        self.delegate.lessonsDidLoad(lessons: lessons as NSArray)
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

