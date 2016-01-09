//
//  SentMemesGridViewController.swift
//  MemeMe
//
//  Created by Max Saienko on 12/31/15.
//  Copyright © 2015 Max Saienko. All rights reserved.
//

import UIKit

class SentMemesGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    override func viewDidAppear(animated: Bool) {
        print("grid did appear")
    }
    
    override func viewDidLoad() {
        print("grid did load")
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("grid will disappear")
    }
    
    override func viewDidDisappear(animated: Bool) {
        print("grid did disappear")
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("gridCell", forIndexPath: indexPath) as UICollectionViewCell

        cell.backgroundColor = UIColor.redColor()
        
        return cell
    }
}
