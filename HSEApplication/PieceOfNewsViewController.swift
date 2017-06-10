//
//  PieceOfNewsViewController.swift
//  HSEapp
//
//  Created by Alexander on 30/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class PieceOfNewsViewController: UIViewController {
    
    var pieceOfNews: PieceOfNews?
    var titleOfNavBar: String?
    
    @IBOutlet weak var titleOfNews: UILabel!
    @IBOutlet weak var descriptionTextOfNews: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleOfNews.text = pieceOfNews?.title
        descriptionTextOfNews.text = pieceOfNews?.descriptionText
        titleOfNews.sizeToFit()
        descriptionTextOfNews.sizeToFit()
        self.title = titleOfNavBar
    }
}
