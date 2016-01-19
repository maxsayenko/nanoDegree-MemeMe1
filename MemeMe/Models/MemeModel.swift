//
//  MemeModel.swift
//  MemeMe
//
//  Created by Max Saienko on 11/26/15.
//  Copyright © 2015 Max Saienko. All rights reserved.
//

import UIKit

class MemeModel: NSObject {
    var id: String = ""
    var topText: String = ""
    var bottomText: String = ""
    var originalImage: UIImage?
    var originalImageLocalIdentifier: String = ""
    var memeImage: UIImage?
    var memeImageLocalIdentifier: String = ""
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(topText, forKey: "topText")
        aCoder.encodeObject(bottomText, forKey: "bottomText")
        aCoder.encodeObject(originalImageLocalIdentifier, forKey: "originalImageLocalIdentifier")
        aCoder.encodeObject(memeImageLocalIdentifier, forKey: "memeImageLocalIdentifier")
    }
    
    init(coder aDecoder: NSCoder!) {
        topText = aDecoder.decodeObjectForKey("topText") as! String
        bottomText = aDecoder.decodeObjectForKey("bottomText") as! String
        originalImageLocalIdentifier = aDecoder.decodeObjectForKey("originalImageLocalIdentifier") as! String
        memeImageLocalIdentifier = aDecoder.decodeObjectForKey("memeImageLocalIdentifier") as! String
    }
    
    override init() {
    }
}
