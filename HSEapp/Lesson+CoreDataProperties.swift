//
//  Lesson+CoreDataProperties.swift
//  HSEmanager
//
//  Created by Alexander on 28/05/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation
import CoreData


extension Lesson {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lesson> {
        return NSFetchRequest<Lesson>(entityName: "Lesson")
    }

    @NSManaged public var address: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var discipline: String?
    @NSManaged public var endTime: String?
    @NSManaged public var lecturer: String?
    @NSManaged public var lectureRoom: String?
    @NSManaged public var startTime: String?
    @NSManaged public var type: String?
    @NSManaged public var day: Day?

}
