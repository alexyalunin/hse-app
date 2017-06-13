//
//  SecondViewController.swift
//  HSEapp
//
//  Created by Alexander on 22/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var nm = NewsManager()
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var newsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.backgroundColor = UIColor.clear
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        newsTableView.backgroundView = refreshControl
    }
    
    func refresh(sender:AnyObject) {
        self.newsTableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        newsTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return nm.allNews.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nm.allNews[section].news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath)
        
        let pieceOfNews = nm.allNews[indexPath.section].news[indexPath.row]
        
        cell.textLabel?.text = pieceOfNews.title
        
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = makeHeaderWithDate(tableView: tableView, date: nm.allNews[section].date, dateStyle: .long)
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "pieceOfNewsSegue") {
            let destinationViewController = segue.destination as? PieceOfNewsViewController
            
            if let IndexPath = self.newsTableView.indexPath(for: sender as! UITableViewCell) {
                destinationViewController?.pieceOfNews = pieceOfNewsAtIndexPath(indexPath: IndexPath as NSIndexPath)
            }
            if let IndexPathForSection = self.newsTableView.indexPath(for: sender as! UITableViewCell){
                let date = dateAtIndexPath(indexPath: IndexPathForSection as NSIndexPath).date
                let formatter = DateFormatter()
                formatter.dateStyle = .long
                destinationViewController?.titleOfNavBar = formatter.string(from: date)
            }
        }
        if (segue.identifier == "rubricSegue") {
            _ = segue.destination as? ChooseRubricViewController
        }
    }
    
    func pieceOfNewsAtIndexPath(indexPath: NSIndexPath) ->PieceOfNews {
        let newsSection = nm.allNews[indexPath.section]
        return newsSection.news[indexPath.row]
    }
    
    func dateAtIndexPath(indexPath: NSIndexPath) ->NewsSection {
        return nm.allNews[indexPath.section]
    }
    
}

