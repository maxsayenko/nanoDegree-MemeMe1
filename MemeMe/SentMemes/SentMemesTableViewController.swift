//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Max Saienko on 12/31/15.
//  Copyright © 2015 Max Saienko. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidAppear(animated: Bool) {
        print("table did appear")
        
    }
    
    override func viewDidLoad() {
        print("table did load")
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("table will disappear")
    }
    
    override func viewDidDisappear(animated: Bool) {
        print("table did disappear")
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell")! as UITableViewCell
        cell.textLabel?.text = "boo"
        
        return cell
    }
}
