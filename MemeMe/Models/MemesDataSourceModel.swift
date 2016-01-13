//
//  MemesDataSourceModel.swift
//  MemeMe
//
//  Created by Max Saienko on 12/18/15.
//  Copyright © 2015 Max Saienko. All rights reserved.
//

import UIKit

struct MemesDataSourceModel {
    private static var memes:[MemeModel] = [MemeModel]()
    
    static func GetMemes() -> [MemeModel] {
        let memesData = NSUserDefaults.standardUserDefaults().objectForKey("memes") as? NSData
        
        if let memesData = memesData {
            let memesArray = NSKeyedUnarchiver.unarchiveObjectWithData(memesData) as? [MemeModel]
            
            if let memesArray = memesArray {
                memes = memesArray
                return memesArray
            }
        }

        return memes
    }
    
    static func AddMeme(model: MemeModel) -> Void {
        memes.append(model)

        let memesData = NSKeyedArchiver.archivedDataWithRootObject(memes)
        NSUserDefaults.standardUserDefaults().setObject(memesData, forKey: "memes")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}