//
//  TableViewCell.swift
//  MemeMe
//
//  Created by Max Saienko on 1/9/16.
//  Copyright © 2016 Max Saienko. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet var memeImageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    
    func populate(model: MemeModel) {
        memeImageView.contentMode = .ScaleAspectFit
        memeImageView.image = model.memeImage
        descriptionLabel.text = "\(model.topText) ... \(model.bottomText)"
    }
}
