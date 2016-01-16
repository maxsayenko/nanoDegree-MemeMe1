//
//  ImageService.swift
//  MemeMe
//
//  Created by Max Saienko on 1/9/16.
//  Copyright © 2016 Max Saienko. All rights reserved.
//

import Foundation
import Photos

class ImageService {
    init() {
        
    }
    
    static func getImageLocalIdentifier(info: [String: AnyObject]) -> String {
        // TODO: Fix a bug for My Photo Stream album
        if(info[UIImagePickerControllerReferenceURL] != nil) {
            let url = info[UIImagePickerControllerReferenceURL] as! NSURL
            let asset = PHAsset.fetchAssetsWithALAssetURLs([url], options: nil).lastObject as! PHAsset
            return asset.localIdentifier
        }
        return ""
    }
    
    static func getImageFromLocalIdentifier(localIdentifier: String, completionHandler: (image: UIImage?, error: NSError?) -> Void ) -> Void {
        let manager = PHImageManager.defaultManager()
        
        let fetchResults = PHAsset.fetchAssetsWithLocalIdentifiers([localIdentifier], options: nil)
        
        if (fetchResults.count > 0) {
            if let imageAsset = fetchResults.objectAtIndex(0) as? PHAsset {
                let requestOptions = PHImageRequestOptions()
                requestOptions.deliveryMode = .HighQualityFormat
                manager.requestImageForAsset(imageAsset, targetSize: PHImageManagerMaximumSize, contentMode: .AspectFill, options: requestOptions, resultHandler: { (image, info) -> Void in
                    
                    // Successful Image
                    completionHandler(image: image, error: nil)
                })
            } else {
                print("ImageService - getImageFromLocalIdentifier: fetchResults.objectAtIndex(0) failed")
                let userInfo: [NSObject : AnyObject] =
                [
                    NSLocalizedDescriptionKey :  NSLocalizedString("ImageFailed", value: "fetchResults.objectAtIndex(0) failed", comment: ""),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("ImageFailed", value: "Fetching failed", comment: "")
                ]
                completionHandler(image: nil, error: NSError(domain: "ImageService", code: 500, userInfo: userInfo))
            }
        } else {
            print("ImageService - getImageFromLocalIdentifier: no items in fetchResult")
            let userInfo: [NSObject : AnyObject] =
            [
                NSLocalizedDescriptionKey :  NSLocalizedString("ImageFailed", value: "There are no items in the result", comment: ""),
                NSLocalizedFailureReasonErrorKey : NSLocalizedString("ImageFailed", value: "Fetching failed", comment: "")
            ]
            completionHandler(image: nil, error: NSError(domain: "ImageService", code: 500, userInfo: userInfo))
        }
    }
}