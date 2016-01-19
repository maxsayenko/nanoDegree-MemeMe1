//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Max Saienko on 1/16/16.
//  Copyright © 2016 Max Saienko. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var memeModel: MemeModel?

    @IBOutlet var memeImage: UIImageView!
    
    override func viewDidAppear(animated: Bool) {
        if let image = memeModel?.memeImage {
            memeImage.image = image
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "editorViewSegue") {
            let navigationViewController = segue.destinationViewController as! UINavigationController
            let editorViewController = navigationViewController.viewControllers.first as! MemeEditorController
            editorViewController.memeModel = memeModel
        }
    }
}
