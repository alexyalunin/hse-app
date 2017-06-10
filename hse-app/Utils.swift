//
//  Utils.swift
//  HSEmanager
//
//  Created by Alexander on 09/06/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation
import CoreData
import UIKit


// MARK: - Dates

var today: Date {
    return Date()
}
var inSevenDays: Date {
    return Date(timeInterval: 60*60*24*6, since: Date())
}


// MARK: - Entities' names

let lessonClassName: String = String(describing: Lesson.self)
let dayClassName: String  = String(describing: Day.self)


// MARK: - Colors


var hseColor = UIColor(red: 0/255.0, green: 71/255.0, blue: 136/255.0, alpha: 1.0)
var hseColorPassive = UIColor.black.withAlphaComponent(0.5)
var headerColor = UIColor(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1.0)


// MARK: - CoreData


var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

var email: String? {
    get {
        return UserDefaults.standard.value(forKey: "email") as? String
    }
    set {
        CoreDataModel.deleteAllRecords()
        UserDefaults.standard.set(newValue, forKey: "email")
    }
}

fileprivate extension CoreDataModel {
    class func deleteAllRecords() {
        deleteRecordsOfEntity(dayClassName)
        // add deletion
    }
}


// MARK: - Functions


func getCurrentDateTime() -> String {
    let currentDateTime = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy, HH:mm"
    return formatter.string(from: currentDateTime)
}

func refreshBegin(refreshEnd:@escaping (Int) -> ()) {
    DispatchQueue.global(qos: .default).async() {
        sleep(1)
        DispatchQueue.main.async() {
            refreshEnd(0)
        }
    }
}


// MARK: - Extensions


extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
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
}

