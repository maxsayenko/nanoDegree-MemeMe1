//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Max Saienko on 12/31/15.
//  Copyright © 2015 Max Saienko. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemesDataSourceModel.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell")! as UITableViewCell

        let memeModel = MemesDataSourceModel.memes[indexPath.row] as MemeModel
        
        // Set the name and image
        cell.textLabel?.text = "\(memeModel.topText) ... \(memeModel.bottomText)"
        cell.imageView?.image = memeModel.memeImage

        return cell
    }
}
