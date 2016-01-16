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

    override func viewDidAppear(animated: Bool) {
        print(memeModel)
    }
}
