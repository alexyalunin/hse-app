//
//  LessonCell.swift
//  HSEapp
//
//  Created by Alexander on 02/02/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class LessonCell: UITableViewCell {

    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var lessonTypeLabel: UILabel!
    @IBOutlet weak var disciplineLabel: UILabel!
    @IBOutlet weak var tutorLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    func setUpLessonCellWith(lesson: Lesson) {
        startTimeLabel?.text = lesson.startTime
        endTimeLabel?.text = lesson.endTime
        lessonTypeLabel?.text = lesson.type.desc
        disciplineLabel?.text = lesson.discipline
        tutorLabel?.text = lesson.tutor.name
        addressLabel?.text = lesson.address + ", " + String(describing: lesson.lectureRoom)
    }
}
