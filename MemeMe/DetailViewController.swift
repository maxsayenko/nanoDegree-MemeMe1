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
}
