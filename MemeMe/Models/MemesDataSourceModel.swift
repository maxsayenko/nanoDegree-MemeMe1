//
//  MemesDataSourceModel.swift
//  MemeMe
//
//  Created by Max Saienko on 12/18/15.
//  Copyright © 2015 Max Saienko. All rights reserved.
//

import UIKit

struct MemesDataSourceModel {
    static private let isPersisted = false
    
    static private(set) var memes:[MemeModel] = [MemeModel]()
    
    static func LoadMemes() -> [MemeModel] {
        if(isPersisted) {
            let memesData = NSUserDefaults.standardUserDefaults().objectForKey("memes") as? NSData
            
            if let memesData = memesData {
                let memesArray = NSKeyedUnarchiver.unarchiveObjectWithData(memesData) as? [MemeModel]
                
                if let memesArray = memesArray {
                    memes = memesArray
                }
            }
        }
        
        return memes
    }
    
    static func AddMeme(model: MemeModel) -> Void {
        memes.append(model)
        WriteToDefaults(memes)
    }
    
    static func DeleteMemeAtLocalIdentifier(memeLocalIdentifier: String) -> Void {
        let deletedMemeIndex = memes.indexOf { (item) -> Bool in
            return item.memeImageLocalIdentifier == memeLocalIdentifier
        }
        
        if let deletedMemeIndex = deletedMemeIndex {
            memes.removeAtIndex(deletedMemeIndex)
            WriteToDefaults(memes)
        }
    }
    
    static func DeleteMemeAtIndex(index: Int) -> Void {
        memes.removeAtIndex(index)
        WriteToDefaults(memes)
    }
    
    static func UpdateMemeAtID(id: String, model: MemeModel) -> Void {
        let updatingMemeIndex = memes.indexOf { (item) -> Bool in
            return item.id == id
        }
        
        let updatingMeme = memes[updatingMemeIndex!]
        
        updatingMeme.memeImage = model.memeImage
        updatingMeme.memeImageLocalIdentifier = model.memeImageLocalIdentifier
        updatingMeme.originalImage = model.originalImage
        updatingMeme.originalImageLocalIdentifier = model.originalImageLocalIdentifier
        updatingMeme.topText = model.topText
        updatingMeme.bottomText = model.bottomText
    }
    
    private static func WriteToDefaults(memes: [MemeModel]) -> Void {
        if(isPersisted) {
            let memesData = NSKeyedArchiver.archivedDataWithRootObject(memes)
            NSUserDefaults.standardUserDefaults().setObject(memesData, forKey: "memes")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}