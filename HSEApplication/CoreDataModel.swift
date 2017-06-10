//
//  CoreDataModel.swift
//  HSEmanager
//
//  Created by Alexander on 09/06/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation
import CoreData

class CoreDataModel {
    
    class func deleteRecordsOfEntity(_ entity: String) {
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
    
    class func loadDaysFromDatabase() -> [Day]? {
        let fetchDaysRequest: NSFetchRequest<Day> = Day.fetchRequest()
        let sectionSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchDaysRequest.sortDescriptors = [sectionSortDescriptor]
        
        do {
            let days = try container?.viewContext.fetch(fetchDaysRequest)
            return days!
        }
        catch {
            print(error)
        }
        return nil
    }
    
    class func printScheduleDatabaseStats() {
        if let context = container?.viewContext {
            if let daysCount = try? context.count(for: Day.fetchRequest()) {
                print("\(daysCount) days")
            }
            if let lessonsCount = try? context.count(for: Lesson.fetchRequest()) {
                print("\(lessonsCount) lessons")
            }
        }
    }
}
