//
//  Lesson.swift
//  HSEapp
//
//  Created by Alexander on 01/02/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation

enum LessonType{
    case Lesson
    case Seminar
    case PracticaLesson
    case ResearchProject
    
    var desc: String{
        switch self {
        case .Lesson:
            return "Лекция"
        case .Seminar:
            return "Семинар"
        case .PracticaLesson:
            return "Практическое занятие"
        case .ResearchProject:
            return "Научно-исследовательский семинар"
        }
    }
}

let dayOfWeek: [Int: String] = [
    1: "Понедельник",
    2: "Вторник",
    3: "Среда",
    4: "Четверг",
    5: "Пятница",
    6: "Суббота",
    7: "Воскресенье",
]

class Lesson{
    
    var date: String
    var dayOfWeek: String
    var startTime: String
    var endTime: String
    var type: String
    var discipline: String
    var lecturer: String
    var address: String
    var lectureRoom: String
    
    init(date:String, dayOfWeek: String, startTime: String, endTime: String, type: String, discipline: String, lecturer: String, address: String, lectureRoom: String) {
        self.date = date
        self.dayOfWeek = dayOfWeek
        self.startTime = startTime
        self.endTime = endTime
        self.type = type
        self.discipline = discipline
        self.lecturer = lecturer
        self.address = address
        self.lectureRoom = lectureRoom
    }
}


