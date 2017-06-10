//
//  PieceOfNews.swift
//  HSEapp
//
//  Created by Alexander on 28/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation

class PieceOfNews{
    
    var title: String
    var descriptionText: String?
    
    init(title:String, descriptionText:String?) {
        self.title = title
        self.descriptionText = descriptionText
    }
}
