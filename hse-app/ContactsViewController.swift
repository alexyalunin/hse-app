//
//  ThirdViewController.swift
//  HSEapp
//
//  Created by Alexander on 22/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var wm = WorkerManager()
    
    var officeContacts = [Worker?](){
        didSet{
            contactsTableView.reloadData()
        }
    }
    
    var tutors = [Worker?](){
        didSet{
            contactsTableView.reloadData()
        }
    }
    
    func sort(){
        for worker in wm.workers{
            if worker.worksInOffice == true{
                officeContacts.append(worker)
            } else{
                tutors.append(worker)
            }
        }
    }
    
    @IBOutlet weak var contactsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var contactsTableView: UITableView!
    
    @IBAction func actionContanctsSC(_ sender: Any) {
        contactsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationBar?.shadowImage = UIImage()
        
        sort()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contactsTableView.reloadData()
    }

    // MARK: table
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        
        switch (contactsSegmentedControl.selectedSegmentIndex) {
        case 0:
            returnValue = officeContacts.count
            break
        case 1:
            returnValue = tutors.count
            break
        default:
            break
        }
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        switch (contactsSegmentedControl.selectedSegmentIndex) {
        case 0:
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "subtitleCell", for: indexPath)
            cell1.textLabel!.text = officeContacts[indexPath.row]?.name
            cell1.detailTextLabel!.text = officeContacts[indexPath.row]?.post
            cell = cell1
            break
        case 1:
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
            cell2.textLabel!.text = tutors[indexPath.row]?.name
            cell = cell2
            break
        default:
            let cell3 = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
            cell3.textLabel!.text = tutors[indexPath.row]?.name
            cell = cell3
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as? OneContactViewController
        if let IndexPath = self.contactsTableView.indexPath(for: sender as! UITableViewCell) {
            destinationViewController?.worker = workerAt(indexPath: IndexPath as NSIndexPath)
        }
    }
    
    func workerAt(indexPath: NSIndexPath) ->Worker {
        
        var worker: Worker?
        
        switch (contactsSegmentedControl.selectedSegmentIndex) {
        case 0:
            worker = officeContacts[indexPath.row]
            break
        case 1:
            worker = tutors[indexPath.row]
            break
        default:
            break
        }
        return worker!
    }
    
}








