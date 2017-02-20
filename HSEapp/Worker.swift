//
//  Person.swift
//  HSEapp
//
//  Created by Alexander on 31/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation

class Worker{
    
    var name: String
    var post: String?
    var worksInOffice: Bool?
    var faculty: String?
    var address: String?
    var phone: String?
    var email: String?
    var timeAvailableInfo: String?
    
    init(name: String, post: String?, worksInOffice: Bool?, faculty: String?, address:String?, phone: String?, email: String?, timeAvailableInfo: String?) {
        self.name = name
        self.post = post
        self.worksInOffice = worksInOffice
        self.faculty = faculty
        self.address = address
        self.phone = phone
        self.email = email
        self.timeAvailableInfo = timeAvailableInfo
    }
    
}
