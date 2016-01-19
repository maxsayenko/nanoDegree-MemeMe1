//
//  SentMemesGridViewController.swift
//  MemeMe
//
//  Created by Max Saienko on 12/31/15.
//  Copyright © 2015 Max Saienko. All rights reserved.
//

import UIKit

class SentMemesGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidAppear(animated: Bool) {
        collectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MemesDataSourceModel.memes.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("gridCell", forIndexPath: indexPath) as! GridCell

        var memeModel = MemesDataSourceModel.memes[indexPath.item] as MemeModel

        cell.populate(memeModel)

        // Data retrieval and caching
        if(memeModel.memeImage == nil && memeModel.memeImageLocalIdentifier != "") {
            ImageService.getImageFromLocalIdentifier(memeModel.memeImageLocalIdentifier, completionHandler: { (image, error) -> Void in
                if(error == nil) {
                    dispatch_async(dispatch_get_main_queue(), {
                        if let cellToUpdate = collectionView.cellForItemAtIndexPath(indexPath) as! GridCell? {
                            cellToUpdate.imageView.image = image
                            memeModel.memeImage = image
                        }
                    })
                }
            })
        }

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "detailViewSegue") {
            let cellIndex = collectionView.indexPathForCell(sender as! UICollectionViewCell)?.row
            let memeModel = MemesDataSourceModel.memes[cellIndex!] as MemeModel
            
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.memeModel = memeModel
        }
    }
}
