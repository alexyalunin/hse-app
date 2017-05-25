//
//  Day.swift
//  HSEapp
//
//  Created by Alexander on 01/02/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation

class Day {
    
    var date: Date
    var lessons: [Lesson]
    
    init(date: Date, lessons: [Lesson]) {
        self.date = date
        self.lessons = lessons
    }
}
