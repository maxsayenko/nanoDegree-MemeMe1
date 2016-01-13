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
        print("load")
        CustomPhotoAlbum()
    }
    
    override func viewDidAppear(animated: Bool) {
        print("reload")
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemesDataSourceModel.GetMemes().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell") as! TableViewCell

        let memeModel = MemesDataSourceModel.GetMemes()[indexPath.row] as MemeModel

        cell.memeImageView.contentMode = .ScaleAspectFit
        cell.memeImageView.image = UIImage() // Need to set the image to something, so it can updated later
        
        if(memeModel.memeImageLocalIdentifier != "") {
            ImageService.getImageFromLocalIdentifier(memeModel.memeImageLocalIdentifier, completionHandler: { (image, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as! TableViewCell? {
                        cellToUpdate.memeImageView.image = image
                    }
                })
            })
        }

        cell.descriptionLabel.text = "\(memeModel.topText) ... \(memeModel.bottomText)"

        return cell
    }
}
