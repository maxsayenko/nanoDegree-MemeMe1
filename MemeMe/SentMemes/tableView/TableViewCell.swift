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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
