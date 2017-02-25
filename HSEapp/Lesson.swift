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

enum DayOfWeek{
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    case Sunday
    
    var desc: String{
        switch self {
        case .Monday:
            return "Понедельник"
        case .Tuesday:
            return "Вторник"
        case .Wednesday:
            return "Среда"
        case .Thursday:
            return "Четверг"
        case .Friday:
            return "Пятница"
        case .Saturday:
            return "Суббота"
        case .Sunday:
            return "Воскресенье"
        }
    }
}

class Lesson{
    
    var date: String
    var dayOfWeek: DayOfWeek
    var startTime: String
    var endTime: String
    var type: LessonType
    var discipline: String
    var tutor: Worker
    var address: String
    var lectureRoom: Int
    
    init(date:String, dayOfWeek: DayOfWeek, startTime: String, endTime: String, type: LessonType, discipline: String, tutor: Worker, address: String, lectureRoom: Int) {
        self.date = date
        self.dayOfWeek = dayOfWeek
        self.startTime = startTime
        self.endTime = endTime
        self.type = type
        self.discipline = discipline
        self.tutor = tutor
        self.address = address
        self.lectureRoom = lectureRoom
    }
}


