//
//  gridCell.swift
//  MemeMe
//
//  Created by Max Saienko on 1/8/16.
//  Copyright © 2016 Max Saienko. All rights reserved.
//

import UIKit

class GridCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var topText: UILabel!
    @IBOutlet var bottomText: UILabel!
    
    func populate(model: MemeModel) {
        imageView.contentMode = .ScaleAspectFit
        imageView.image = model.memeImage
        topText.attributedText = getAttributedText(model.topText)
        bottomText.attributedText = getAttributedText(model.bottomText)        
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
