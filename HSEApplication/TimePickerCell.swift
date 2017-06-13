//
//  TimePickerCell.swift
//  HSEapp
//
//  Created by Alexander on 04/02/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class TimePickerCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource{

    var array: [String] = []
    
    var isObserving = false
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var datePicker: UIPickerView!
    @IBOutlet weak var tlTop: NSLayoutConstraint!
    @IBOutlet weak var tlLead: NSLayoutConstraint!
    @IBOutlet weak var dpTop: NSLayoutConstraint!
    @IBOutlet weak var ilTop: NSLayoutConstraint!
    @IBOutlet weak var ilTrail: NSLayoutConstraint!
    @IBOutlet weak var dpLead: NSLayoutConstraint!
    @IBOutlet weak var dpTrail: NSLayoutConstraint!
    
    class var expandedHeight: CGFloat { get { return 260 } }
    class var defaultHeight: CGFloat { get { return 44 } }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        datePicker.delegate = self
        datePicker.dataSource = self

        infoLabel.text = "Не выбрано"
    }
    
    func checkHeight() {
        datePicker.isHidden = (frame.size.height < TimePickerCell.expandedHeight)
    }
    
    func watchFrameChanges() {
        if !isObserving {
            addObserver(self, forKeyPath: "frame", options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.initial], context: nil)
            infoLabel.textColor = .black
            isObserving = true;
        }
    }
    
    func ignoreFrameChanges() {
        if isObserving {
            removeObserver(self, forKeyPath: "frame")
            infoLabel.textColor = Colors.hseColor
            isObserving = false
        }
    }
    
    override func observeValue(forKeyPath
        keyPath: String?, of
        object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?)
        
        {
        if keyPath == "frame" {
            checkHeight()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return array[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return array.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        infoLabel.text = array[row]
    }
    
}






