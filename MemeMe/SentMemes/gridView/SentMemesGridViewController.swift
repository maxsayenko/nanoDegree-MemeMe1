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
        print("grid did appear")
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        // Regestering custom table cell
//        let nib = UINib(nibName: "GridCell", bundle: nil)
//        collectionView.registerNib(nib, forCellWithReuseIdentifier: "gridCell")
        //collectionView!.registerClass(GridCell.self, forCellWithReuseIdentifier: "gridCell")
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Grid count = \(MemesDataSourceModel.memes.count)")
        return MemesDataSourceModel.memes.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("gridCell", forIndexPath: indexPath) as! GridCell

        print(indexPath)
        print(indexPath.row)
        print(indexPath.item)
        
        let memeModel = MemesDataSourceModel.memes[indexPath.item] as MemeModel

        print(memeModel)
        print(memeModel.memeImage)
        print(cell)
        
        cell.backgroundColor = UIColor.redColor()
        cell.imageView.image = memeModel.memeImage
        
        return cell
    }
}
