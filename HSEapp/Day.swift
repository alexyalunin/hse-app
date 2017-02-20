//
//  Day.swift
//  HSEapp
//
//  Created by Alexander on 01/02/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation

class Day{
    var date: String
    var lessons: [Lesson]?
    
    init(date: String, lessons: [Lesson]?) {
        self.date = date
        self.lessons = lessons
    }
}
