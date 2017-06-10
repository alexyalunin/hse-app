//
//  WorkerManager.swift
//  HSEapp
//
//  Created by Alexander on 31/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation

class WorkerManager{

    var workers: [Worker]
    
    init() {
        
        let ow1 = Worker(name: "Самохин Михаил Юрьевич", post: "Начальник отдела", worksInOffice: true, faculty: "Факультет бизнеса и менеджмента", address: "Кирпичная ул., д. 33, каб. 521", phone: "+7(495) 772-95901*55070", email: "msamokhin@hse.ru", timeAvailableInfo: "Время работы: 10:00 -18:00")
        let ow2 = Worker(name: "Дробот Галина Борисовна ", post: "Диспетчер", worksInOffice: true, faculty: "Факультет бизнеса и менеджмента", address: "Кирпичная ул., д. 33, каб. 507", phone: "+7(495) 772-95631", email: "gdrobot@hse.ru", timeAvailableInfo: "Время работы: 10:00-18:00")
        let ow3 = Worker(name: "Грибова Екатерина Алексеевна", post: "Специалист по УМР (работа со студентами 1 и 2 курса)", worksInOffice: true, faculty: "Факультет бизнеса и менеджмента", address: "Кирпичная ул., д. 33, каб. 521", phone: "+7(495) 772-95901*55070", email: "msamokhin@hse.ru", timeAvailableInfo: "Время работы: 9:30-18:00")
        let ow4 = Worker(name: "Гурова Екатерина Васильевна", post: "Специалист по УМР (работа со студентами 3 и 4 курса)", worksInOffice: true, faculty: "Факультет бизнеса и менеджмента", address: "Кирпичная ул., д. 33, каб. 507", phone: "+7(495) 772-95631", email: "gdrobot@hse.ru", timeAvailableInfo: "Время присутствия: вторник, 10:00-18:00 четверг, 10:00-18:00 с обязательным согласованием по e-mail")
        
        
        let pr1 = Worker(name: "Авдеева Зинаида Константиновна", post: "Преподаватель", worksInOffice: false, faculty: "Факультет бизнеса и менеджмента / Школа бизнес-информатики / Кафедра инноваций и бизнеса в сфере информационных технологий", address: "Кирпичная ул., д. 33, каб. 520", phone: "+7(495) 772-95901 *55172", email: "avdeeva@hse.ru", timeAvailableInfo: "Время консультаций: Понедельник, Среда, Четверг 13:00-16:00")
        let pr2 = Worker(name: "Броневич Андрей Георгиевич", post: "Преподаватель", worksInOffice: false, faculty: "Факультет экономических наук / Департамент математики", address: "г.Москва, ул.Шаболовка 26, корпус 5, комн.5422", phone: "+7 (495) 621 13 421", email: "abronevich@hse.ru", timeAvailableInfo: "четверг 15.10-16.30 ауд.534 (Кирпичная)- по предварительному согласованию")
        let pr3 = Worker(name: "Гоменюк Кирилл Сергеевич", post: "Преподаватель",worksInOffice: false, faculty: "Факультет бизнеса и менеджмента / Школа бизнес-информатики / Кафедра бизнес-аналитики", address: "Кирпичная ул., д. 33, каб. 833", phone: "+7(495) 772-95901 доб. 55148", email: "kgomenyuk@hse.ru", timeAvailableInfo: "Время работы: Суббота 9:00-15:00, Вторник 9:00-12:00")
        
        
        workers = [ow1, ow2, ow3, ow4, pr1, pr2, pr3]
    }
}
