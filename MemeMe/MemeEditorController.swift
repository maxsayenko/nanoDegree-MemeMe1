//
//  MemeEditorController.swift
//  MemeMe
//
//  Created by Max Saienko on 11/19/15.
//  Copyright © 2015 Max Saienko. All rights reserved.
//

import UIKit
import Photos


class MemeEditorController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var imagePicker = UIImagePickerController()
    var shouldSlideView: Bool = false
    
    // Constraints
    let textConstraintPortraitMode: CGFloat = 100
    let textConstraintLandscapeMode: CGFloat = 20
    @IBOutlet var topTextTopConstraint: NSLayoutConstraint!
    @IBOutlet var bottomTextBottomConstraint: NSLayoutConstraint!
    
    // UI Items
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    
    @IBAction func topTextEditing(sender: UITextField) {
        if(sender.text == "TOP") {
            sender.text = ""
        }
    }
    
    @IBAction func bottomTextEditing(sender: UITextField) {
        shouldSlideView = true
        if(sender.text == "BOTTOM") {
            sender.text = ""
        }
    }
    @IBAction func bottomTextEditingEnd(sender: UITextField) {
        shouldSlideView = false
    }
    
    @IBAction func cancelButtonTouch(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func shareButtonTouch(sender: UIBarButtonItem) {
        let memeImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            let memeModel = MemeModel(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, originalImage: self.imageView.image!, memeImage: memeImage)
            MemesDataSourceModel.memes.append(memeModel)
        }
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func albumButtonTouch(sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func cameraButtonTouch(sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func generateMemedImage() -> UIImage {
        let defaultBackGroundColor = imageView.backgroundColor
        imageView.backgroundColor = UIColor.whiteColor()
        
        // Render view to an image
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0)
        // do error handling here
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        imageView.backgroundColor = defaultBackGroundColor
        
        return memedImage
    }
    
    func prepareTextField(textField: UITextField, defaultText: String) {
        super.viewDidLoad()
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = defaultText
        textField.autocapitalizationType = .AllCharacters
        textField.textAlignment = .Center
    }
    
    // View Init
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: view.window)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.contentMode = .ScaleAspectFit
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        prepareTextField(topTextField, defaultText: "TOP")
        prepareTextField(bottomTextField, defaultText: "BOTTOM")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // Image picker delegate
    //    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
    //
    //        dismissViewControllerAnimated(true, completion: { () -> Void in
    //        })
    //
    //        if let info = editingInfo {
    //            print(info)
    //        }
    //
    //        imageView.image = image
    //        shareButton.enabled = true
    //    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let manager = PHImageManager.defaultManager()
        
        print(info)
        
        let url = info[UIImagePickerControllerReferenceURL] as! NSURL
        
        print(url)
        
        
        let asset = PHAsset.fetchAssetsWithALAssetURLs([url], options: nil).lastObject as! PHAsset
        
        print(asset)
        
        let localId = asset.localIdentifier
        
        print(localId)
        
        print("========== 1B663CC3-ECA5-4290-A7D0-74F70C3DE94D/L0/001")
        
        let fetchResults = PHAsset.fetchAssetsWithLocalIdentifiers(["4BD8AB4D-884B-48DB-B4FF-8D4A4BB6C3E0/L0/001"], options: nil)
        
        print(fetchResults)
        
        if (fetchResults.count > 0) {
            if let imageAsset = fetchResults.objectAtIndex(0) as? PHAsset {
                let requestOptions = PHImageRequestOptions()
                requestOptions.deliveryMode = .HighQualityFormat
                manager.requestImageForAsset(imageAsset, targetSize: PHImageManagerMaximumSize, contentMode: .AspectFill, options: requestOptions, resultHandler: { (image, info) -> Void in
                    print("YAY")
                    print(image)
                    print(info)
                    self.imageView.image = image
                })
            } else {
                print("fetchResults.objectAtIndex(0) failed")
            }
        } else {
            print("no items in fetchResult")
        }
        
        PHImageManager.defaultManager().requestImageDataForAsset(asset, options: PHImageRequestOptions(), resultHandler:
            {
                (imagedata, dataUTI, orientation, info) in
                
                if info!.keys.contains(NSString(string: "PHImageFileURLKey"))
                {
                    let path = info![NSString(string: "PHImageFileURLKey")] as! NSURL
                    print(path)
                    print("path = \(path.path!)")
                    
                    let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                    
                    print(documentsURL)
                    
                    let fileURL = documentsURL.URLByAppendingPathComponent(path.path!)
                    print(fileURL)
                    
                    print("----------")
                    //NSData *imageData = [NSData dataWithContentsOfURL:privateUrl];
                    
                    let data = NSData(contentsOfFile: "file:///var/mobile/Media/DCIM/101APPLE/IMG_1711.JPG")
                    print(data)
                    
                    let data2 = NSData(contentsOfURL: NSURL(fileURLWithPath: "file:///var/mobile/Media/DCIM/101APPLE/IMG_1711.JPG"))
                    print(data2)
                    
                    let img = UIImage(contentsOfFile: "file:///var/mobile/Media/DCIM/101APPLE/IMG_1711.JPG")
                    
                    print(img)
                }
        })
        
        print("done")
        
        dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }
    
    
    
    
    //    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    ////        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
    ////        let imageName = imageURL.path!.lastPathComponent
    ////        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String
    ////        let localPath = documentDirectory.stringByAppendingPathComponent(imageName)
    ////
    ////        let image = info[UIImagePickerControllerOriginalImage] as UIImage
    ////        let data = UIImagePNGRepresentation(image)
    ////        data.writeToFile(localPath, atomically: true)
    ////
    ////        let imageData = NSData(contentsOfFile: localPath)!
    ////        let photoURL = NSURL(fileURLWithPath: localPath)
    ////        let imageWithData = UIImage(data: imageData)!
    //
    //        picker.dismissViewControllerAnimated(true, completion: nil)
    //
    //    }
    
    //    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
    //        picker.dismissViewControllerAnimated(true, completion: nil)
    //    }
    
    //    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    //        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
    //
    //        let imageName = imageURL.lastPathComponent
    //        let documentDirectoryString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as String
    //
    //        let documentDirectoryUrl = NSURL(fileURLWithPath: documentDirectoryString, isDirectory: true)
    //        let localPath = documentDirectoryUrl.URLByAppendingPathComponent("asset.JPG?id=1B663CC3-ECA5-4290-A7D0-74F70C3DE94D&ext=JPG")
    //
    ////        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    ////        let data = UIImagePNGRepresentation(image)
    ////        data.writeToFile(localPath, atomically: true)
    ////
    ////        let imageData = NSData(contentsOfFile: localPath)!
    ////        let photoURL = NSURL(fileURLWithPath: localPath)
    ////        let imageWithData = UIImage(data: imageData)!
    //
    //        print(imageURL)
    //        print(imageURL.absoluteString)
    //        print(imageName)
    //        print(documentDirectoryString)
    //        print(documentDirectoryUrl)
    //        print(localPath.absoluteString)
    //        print("----")
    //        print(info)
    //
    //
    //        imageView.image = UIImage(contentsOfFile: localPath.absoluteString)
    //
    //        picker.dismissViewControllerAnimated(true, completion: nil)
    //    }
    
    // Keyboard delegates
    func keyboardWillShow(notification: NSNotification) {
        if(!shouldSlideView){
            return
        }
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            // No need to slide if the view already up
            if(view.frame.origin.y == 0) {
                let toolBarHeight = navigationController?.toolbar.frame.height
                view.frame.origin.y = -keyboardSize.height
                navigationController?.navigationBar.frame.origin.y = -keyboardSize.height
                navigationController?.toolbar.frame.origin.y = view.frame.origin.y + view.frame.height - toolBarHeight!
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if(!shouldSlideView){
            return
        }
        
        // No need to slide if the view already down
        if(view.frame.origin.y != 0) {
            let toolBarHeight = navigationController?.toolbar.frame.height
            view.frame.origin.y = 0
            navigationController?.navigationBar.frame.origin.y = 0
            navigationController?.toolbar.frame.origin.y = view.frame.height - toolBarHeight!
        }
    }
    
    // View rotation handler
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        // Landscape mode
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            topTextTopConstraint.constant = textConstraintLandscapeMode
            bottomTextBottomConstraint.constant = textConstraintLandscapeMode
        }
            // Portrait mode
        else {
            topTextTopConstraint.constant = textConstraintPortraitMode
            bottomTextBottomConstraint.constant = textConstraintPortraitMode
        }
    }
}