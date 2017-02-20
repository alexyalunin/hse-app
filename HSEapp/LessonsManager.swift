//
//  LessonsManager.swift
//  HSEapp
//
//  Created by Alexander on 01/02/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation

class LessonsManager{
    
    var week: Week
    
    init() {
        let pr1 = Worker(name: "Авдеева Зинаида Константиновна", post: "Преподаватель", worksInOffice: false, faculty: "Факультет бизнеса и менеджмента / Школа бизнес-информатики / Кафедра инноваций и бизнеса в сфере информационных технологий", address: "Кирпичная ул., д. 33, каб. 520", phone: "+7(495) 772-9590 *55172", email: "avdeeva@hse.ru", timeAvailableInfo: "Время консультаций: Понедельник, Среда, Четверг 13:00-16:00")
        let pr2 = Worker(name: "Броневич Андрей Георгиевич", post: "Преподаватель", worksInOffice: false, faculty: "Факультет экономических наук / Департамент математики", address: "г.Москва, ул.Шаболовка 26, корпус 5, комн.5422", phone: "+7 (495) 621 13 42", email: "abronevich@hse.ru", timeAvailableInfo: "четверг 15.10-16.30 ауд.534 (Кирпичная)- по предварительному согласованию")
        let pr3 = Worker(name: "Гоменюк Кирилл Сергеевич", post: "Преподаватель",worksInOffice: false, faculty: "Факультет бизнеса и менеджмента / Школа бизнес-информатики / Кафедра бизнес-аналитики", address: "Кирпичная ул., д. 33, каб. 833", phone: "+7(495) 772-9590 доб. 55148", email: "kgomenyuk@hse.ru", timeAvailableInfo: "Время работы: Суббота 9:00-15:00, Вторник 9:00-12:00")
        
        
        let l1 = Lesson(date: "30.01.16", dayOfWeek: DayOfWeek.Monday, startTime: "09:00", endTime: "10:20", type: LessonType.Lesson, discipline: "Теория вероятностей и математическая статистика (рус)", tutor: pr1, address: "Кирпичная ул., д.33", lectureRoom: 702)
        let l2 = Lesson(date: "30.01.16", dayOfWeek: DayOfWeek.Monday, startTime: "12:10", endTime: "13:30", type: LessonType.PracticaLesson, discipline: "Проектный семинар (рус)", tutor: pr2, address: "Кирпичная ул., д.33", lectureRoom: 530)
        let l3 = Lesson(date: "30.01.16", dayOfWeek: DayOfWeek.Monday, startTime: "13:40", endTime: "15:00", type: LessonType.Seminar, discipline: "Дискретная математика (рус)", tutor: pr3, address: "Кирпичная ул., д.33", lectureRoom: 902)
        
        
        let d1 = Day(date: "Понедельник, 23.01.16", lessons: [l1,l2,l3])
        let d2 = Day(date: "Вторник, 24.01.16", lessons: [l1,l2,l3])
        let d3 = Day(date: "Среда, 25.01.16", lessons: [])
        let d4 = Day(date: "Четверг, 26.01.16", lessons: [l1,l2,l3])
        let d5 = Day(date: "Пятница, 27.01.16", lessons: [])
        let d6 = Day(date: "Суббота, 28.01.16", lessons: [l1,l2,l3])
        
        week = Week(days: [d1, d2, d3, d4, d5, d6])
    }
}
