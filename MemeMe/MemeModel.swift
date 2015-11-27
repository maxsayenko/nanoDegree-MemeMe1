//
//  MemeModel.swift
//  MemeMe
//
//  Created by Max Saienko on 11/26/15.
//  Copyright © 2015 Max Saienko. All rights reserved.
//

import UIKit

class MemeModel {
    var topText: String = ""
    var bottomText: String = ""
    var originalImage: UIImage!
    var memeImage: UIImage!
    
    init(topText: String, bottomText: String, originalImage: UIImage, memeImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memeImage = memeImage
    }
}
