//
//  ScheduleModel.swift
//  HSEmanager
//
//  Created by Alexander on 19/05/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation

var Lessons = [Lesson]()

class ScheduleModel {
    
    func getWeek(){
        // Getting data
        let url = URL(string: "http://92.242.58.221/ruzservice.svc/v2/personlessons?fromdate=05.15.2017&todate=05.22.2017&email=aayalunin@edu.hse.ru")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("ERROR")
            }
            
            if let content = data {
                do
                {
                    let myJSON = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    
                    if let lessons = myJSON["Lessons"] as? [[String: Any]]{
                        for lesson in lessons {
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
                            Lessons.append(initLesson)
                        }
                    }
                }
                catch
                {
                    
                }
            }
            
        }
        task.resume()
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
    
}
