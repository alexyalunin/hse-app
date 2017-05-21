//
//  ScheduleModel.swift
//  HSEmanager
//
//  Created by Alexander on 19/05/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation
var lessons: [Lesson] = []
var scheduleData: [Day]?

class ScheduleModel {
    
    func getSchedule(){
        print(lessons.count)
        let days: [Day] = getDays(from: lessons)
        // MARK: make schedule
        scheduleData = days
        print(days.count)
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

        
    func refreshBegin(refreshEnd:@escaping (Int) -> ()) {
        DispatchQueue.global(qos: .default).async() {
            print("refreshing")
            self.getSchedule()
            sleep(3)
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
    
}
