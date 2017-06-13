//
//  NewsSection.swift
//  HSEapp
//
//  Created by Alexander on 28/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation

class NewsSection{
    
    var date: Date
    var news: [PieceOfNews]
    
    init(news: [PieceOfNews], date: Date) {
        self.news = news
        self.date = date
    }
    
}
