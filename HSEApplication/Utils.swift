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

let today = Date()
let inSevenDays = Date(timeInterval: 60*60*24*6, since: Date())


// MARK: - Entities' names


let lessonClassName: String = String(describing: Lesson.self)
let dayClassName: String  = String(describing: Day.self)


// MARK: - Colors


struct Colors {
    static let hseColor = UIColor(hex: "004788")
    static let blackPassiveColor = UIColor.black.withAlphaComponent(0.5)
    static let headerColor = UIColor(hex: "E3E3E3")
}


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

func makeHeaderWithDate(tableView: UITableView, date: Date, dateStyle: DateFormatter.Style) -> UIView? {
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
    headerView.backgroundColor = Colors.headerColor
    
    let label = UILabel(frame: CGRect(x: 15,y: 0, width: tableView.bounds.size.width, height: 30))
    
    let formatter = DateFormatter()
    formatter.dateStyle = dateStyle
    
    label.text = formatter.string(from: date).uppercaseFirst
    label.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)
    
    headerView.addSubview(label)
    
    let topBorder = CALayer()
    topBorder.frame = CGRect(x: 0, y: 0, width: headerView.frame.size.width, height: 0.5);
    topBorder.backgroundColor = UIColor(red: 200/255, green: 199/255, blue: 204/255, alpha: 1).cgColor
    headerView.layer.addSublayer(topBorder)
    
    return headerView
}


// MARK: - Extensions


extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

extension UIColor {
    convenience init(hex: String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
    }
}

extension String {
    var first: String {
        return String(characters.prefix(1))
    }
    var last: String {
        return String(characters.suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercased() + String(characters.dropFirst())
    }
}

extension String {
    
    var containsNonWhitespace: Bool {
        return !self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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

extension NSDate {
    func convertDateToString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self as Date)
    }
}

extension Date {
    func dayNumberOfWeek() -> Int {
        return Calendar.current.dateComponents([.weekday], from: self).weekday!
    }
    
    func convertDateToString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self as Date)
    }
}

