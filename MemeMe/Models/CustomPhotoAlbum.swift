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
        func fetchAssetCollectionForAlbum() -> PHAssetCollection! {
            // Getting the collection
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", CustomPhotoAlbum.albumName)
            let collection = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
            
            // Getting first item in case there are several with the same name
            if let _: AnyObject = collection.firstObject {
                return collection.firstObject as! PHAssetCollection
            }

            return nil
        }
        
        // If collection exists we will return out, and not create another one
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }
        
        // Actual creation
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(CustomPhotoAlbum.albumName)
            }) { success, _ in
                if success {
                    self.assetCollection = fetchAssetCollectionForAlbum()
                }
        }
    }
    
    func saveImage(image: UIImage, completionHandler: (localIdentifier: String) -> Void) -> Void {
        if (assetCollection == nil) {
            // If there was an error upstream, skip the save.
            return
        }
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges(
            {
                let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)

                // Need to cast [assetPlaceholder] explicitly to NSArray
                let assetPlaceholder = assetChangeRequest.placeholderForCreatedAsset

                print("memeLocalId = \(assetPlaceholder?.localIdentifier)")
                
                let enumeration: NSArray = [assetPlaceholder!]
                
                let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection)
                
                albumChangeRequest!.addAssets(enumeration)
                
                completionHandler(localIdentifier: (assetPlaceholder?.localIdentifier)!)
            }, completionHandler: nil)
    }
}