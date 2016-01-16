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
    
    override func viewDidLoad() {
        // Don't know how to silent this warning. And why it's there.
        CustomPhotoAlbum()
    }
    
    override func viewDidAppear(animated: Bool) {
        print("reload")
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count = \(MemesDataSourceModel.memes.count)")
        return MemesDataSourceModel.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell") as! TableViewCell
        let memeModel = MemesDataSourceModel.memes[indexPath.row] as MemeModel

        cell.memeImageView.contentMode = .ScaleAspectFit
        
        // Need to set the image to something (even nil), so it can be updated later
        cell.memeImageView.image = memeModel.memeImage
        
        // Data retrieval and caching
        if(memeModel.memeImage == nil && memeModel.memeImageLocalIdentifier != "") {
            ImageService.getImageFromLocalIdentifier(memeModel.memeImageLocalIdentifier, completionHandler: { (image, error) -> Void in
                if(error == nil) {
                    dispatch_async(dispatch_get_main_queue(), {
                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as! TableViewCell? {
                            cellToUpdate.memeImageView.image = image
                            memeModel.memeImage = image
                        }
                    })
                }
            })
        }

        cell.descriptionLabel.text = "\(memeModel.topText) ... \(memeModel.bottomText)"
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            MemesDataSourceModel.DeleteMemeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
}
