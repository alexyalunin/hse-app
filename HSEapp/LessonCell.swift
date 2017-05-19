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
    
    var lesson: Lesson? { didSet { updateUI() } }

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

    func updateUI() {
        startTimeLabel?.text = lesson?.startTime
        endTimeLabel?.text = lesson?.endTime
        lessonTypeLabel?.text = lesson?.type
        disciplineLabel?.text = lesson?.discipline
        tutorLabel?.text = lesson?.lecturer
        addressButton?.setTitle((lesson?.address)! + ", " + (lesson?.lectureRoom)!, for: .normal)
    }

}
