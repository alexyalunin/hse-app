//
//  LessonCell.swift
//  HSEapp
//
//  Created by Alexander on 02/02/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

protocol LessonCellDelegate {
    func callSegueFromCell(data: AnyObject)
}

class LessonCell: UITableViewCell {
    
    var delegate: LessonCellDelegate!

    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var lessonTypeLabel: UILabel!
    @IBOutlet weak var disciplineLabel: UILabel!
    @IBOutlet weak var tutorLabel: UILabel!
    @IBOutlet weak var addressButton: UIButton!

    @IBAction func addressButtonDidTouch(_ sender: Any) {
        let mydata = "Волоколамское шоссе 15/22"
        if (self.delegate != nil) {
            self.delegate.callSegueFromCell(data: mydata as AnyObject)
        }
    }

    // Classes:
    
//    func setUpLessonCellWith(lesson: Lesson) {
//        startTimeLabel?.text = lesson.startTime
//        endTimeLabel?.text = lesson.endTime
//        lessonTypeLabel?.text = lesson.type.desc
//        disciplineLabel?.text = lesson.discipline
//        tutorLabel?.text = lesson.tutor.name
//        addressLabel?.text = lesson.address + ", " + String(describing: lesson.lectureRoom)
//    }
    
    // JSON:
    
    func setUpLessonCellWith(lesson: JSON) {
        startTimeLabel?.text = lesson["startTime"].string
        endTimeLabel?.text = lesson["endTime"].string
        lessonTypeLabel?.text = lesson["type"].string
        disciplineLabel?.text = lesson["discipline"].string
        tutorLabel?.text = lesson["tutor"].string
        addressButton?.titleLabel?.text = lesson["address"].string! + ", " + lesson["lectureRoom"].string!
    }
    

}
