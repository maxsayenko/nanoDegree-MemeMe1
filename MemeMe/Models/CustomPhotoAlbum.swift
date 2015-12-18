//
//  CustomPhotoAlbum.swift
//  MemeMe
//
//  Created by Max Saienko on 12/18/15.
//  Copyright © 2015 Max Saienko. All rights reserved.
//

import Photos

class CustomPhotoAlbum {
    
    static let albumName = "MemeMe"
    static let sharedInstance = CustomPhotoAlbum()
    
    var assetCollection: PHAssetCollection!
    
    init() {
        print("Init on CustomPhotoAlbum")
        func fetchAssetCollectionForAlbum() -> PHAssetCollection! {
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", CustomPhotoAlbum.albumName)
            let collection = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
            
            print(collection.count)
            print(collection)
            
            if let firstObject: AnyObject = collection.firstObject {
                print(firstObject)
                return collection.firstObject as! PHAssetCollection
            }
            
            print("-- 1 --")
            
            return nil
        }
        
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            print("-- 2 --")
            print(self.assetCollection)
            return
        }
        
        
        print("-- 3 --")
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(CustomPhotoAlbum.albumName)
            }) { success, _ in
                print("-- 4 --")
                print(success)
                if success {
                    self.assetCollection = fetchAssetCollectionForAlbum()
                }
        }
    }
    
    func saveImage(image: UIImage) {
        
        if assetCollection == nil {
            return   // If there was an error upstream, skip the save.
        }
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges(
            {
                let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
                
                // Need to cast [assetPlaceholder] explicitly to NSArray
                let assetPlaceholder = assetChangeRequest.placeholderForCreatedAsset
                let enumeration: NSArray = [assetPlaceholder!]
                
                let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection)
                albumChangeRequest!.addAssets(enumeration)
            }, completionHandler: nil)
    }
}