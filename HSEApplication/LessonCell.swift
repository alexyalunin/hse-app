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
    @IBOutlet weak var lineView: UIView!

    @IBAction func addressButtonDidTouch(_ sender: Any) {
        let mydata = lesson?.address
        if (self.delegate != nil) {
            self.delegate.callSegueFromCell(data: mydata as AnyObject)
        }
    }

    private func updateUI() {
        startTimeLabel?.text  = lesson?.startTime
        endTimeLabel?.text    = lesson?.endTime
        lessonTypeLabel?.text = lesson?.type
        disciplineLabel?.text = lesson?.discipline
        tutorLabel?.text      = lesson?.lecturer
        addressButton?.setTitle((lesson?.address)! + ", " + (lesson?.lectureRoom)!, for: .normal)
        
        let lessonDateTimeString = (lesson?.date?.convertDateToString(format: "dd.MM.yyyy"))! + " " + (lesson?.endTime)!
        let lessonDateTime = lessonDateTimeString.convertStringToDate(format: "dd.MM.yyyy HH:mm")
        
        if lessonDateTime < Date() {
            lineView.backgroundColor  = Colors.blackPassiveColor
            disciplineLabel.textColor = Colors.blackPassiveColor
            startTimeLabel.textColor  = Colors.blackPassiveColor
            endTimeLabel.textColor    = Colors.blackPassiveColor
            addressButton.tintColor   = Colors.blackPassiveColor
        } else {
            lineView.backgroundColor  = Colors.hseColor
            disciplineLabel.textColor = .black
            startTimeLabel.textColor  = .black
            endTimeLabel.textColor    = .black
            addressButton.tintColor   = UIButton(type: UIButtonType.system).titleColor(for: .normal)!
        }
    }
}
