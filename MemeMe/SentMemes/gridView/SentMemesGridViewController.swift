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
        return MemesDataSourceModel.GetMemes().count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("gridCell", forIndexPath: indexPath) as! GridCell

        let memeModel = MemesDataSourceModel.GetMemes()[indexPath.item] as MemeModel

        cell.populate(memeModel)

        if(memeModel.memeImageLocalIdentifier != "") {
            ImageService.getImageFromLocalIdentifier(memeModel.memeImageLocalIdentifier, completionHandler: { (image, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    if let cellToUpdate = collectionView.cellForItemAtIndexPath(indexPath) as! GridCell? {
                        cellToUpdate.imageView.image = image
                    }
                })
            })
        }

        return cell
    }
}
