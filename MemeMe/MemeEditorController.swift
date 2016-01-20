//
//  MemeEditorController.swift
//  MemeMe
//
//  Created by Max Saienko on 11/19/15.
//  Copyright © 2015 Max Saienko. All rights reserved.
//

import UIKit
import Photos


class MemeEditorController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    // Model for editing scenario
    var editMemeModel: MemeModel?
    var isEditingMeme = false
    
    // Local instances
    var imagePicker = UIImagePickerController()
    var shouldSlideView: Bool = false

    //ImageData
    var originalImageLocalIdentifier: String = ""
    
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
    @IBOutlet var cameraButton: UIBarButtonItem!
    
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
            
            if(success) {
                CustomPhotoAlbum.sharedInstance.saveImage(memeImage) { (localIdentifier) -> Void in
                    var memeModel = MemeModel()
                    memeModel.topText = self.topTextField.text!
                    memeModel.bottomText = self.bottomTextField.text!
                    memeModel.originalImage = self.imageView.image!
                    memeModel.originalImageLocalIdentifier = self.originalImageLocalIdentifier
                    memeModel.memeImage = memeImage
                    memeModel.memeImageLocalIdentifier = localIdentifier
                    memeModel.id = NSUUID().UUIDString

                    if(self.isEditingMeme) {
                        MemesDataSourceModel.UpdateMemeAtID((self.editMemeModel?.id)!, model: memeModel)
                    } else {
                        MemesDataSourceModel.AddMeme(memeModel)                        
                    }
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
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
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        
        prepareTextField(topTextField, defaultText: "TOP")
        prepareTextField(bottomTextField, defaultText: "BOTTOM")

        // in Editing mode
        if let model = editMemeModel {
            isEditingMeme = true
            shareButton.enabled = true
            imageView.image = model.originalImage
            topTextField.text = model.topText
            bottomTextField.text = model.bottomText
        }
    }
    
    // Dismissing keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let localId = ImageService.getImageLocalIdentifier(info)
        originalImageLocalIdentifier = localId
        if(localId != "") {
            ImageService.getImageFromLocalIdentifier(localId) { (image, error) -> Void in
                if (error == nil) {
                    self.imageView.image = image
                    self.shareButton.enabled = true
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    })
                }
            }
        } else {
            imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            shareButton.enabled = true
            dismissViewControllerAnimated(true, completion: { () -> Void in
            })
        }
    }
    
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