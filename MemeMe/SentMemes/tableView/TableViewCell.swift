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
//        topText.attributedText = getAttributedText(model.topText)
//        bottomText.attributedText = getAttributedText(model.bottomText)
        descriptionLabel.text = "\(model.topText) ... \(model.bottomText)"
    }
    
    private func getAttributedText(text: String) -> NSAttributedString {
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 18)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        let attributedString = NSAttributedString(string: text, attributes: memeTextAttributes)
        
        return attributedString
    }
}
