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
        print("reload")
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemesDataSourceModel.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell") as! TableViewCell

        let memeModel = MemesDataSourceModel.memes[indexPath.row] as MemeModel
        
        print(cell)
        print(cell.descriptionLabel)
        
        // Set the name and image
//        cell.textLabel?.text = "\(memeModel.topText) ... \(memeModel.bottomText)"
//        cell.imageView?.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        cell.imageView?.image = memeModel.memeImage
        cell.memeImageView.contentMode = .ScaleAspectFit
        cell.memeImageView.image = memeModel.memeImage
        cell.descriptionLabel.text = "\(memeModel.topText) ... \(memeModel.bottomText)"        
        return cell
    }
}
