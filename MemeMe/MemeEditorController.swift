//
//  MemeEditorController.swift
//  MemeMe
//
//  Created by Max Saienko on 11/19/15.
//  Copyright © 2015 Max Saienko. All rights reserved.
//

import UIKit

class MemeEditorController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var imagePicker = UIImagePickerController()
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    var shouldSlideView: Bool = false

    // Constraints
    @IBOutlet var bottomTextBottomConstraint: NSLayoutConstraint!
    let textConstraintPortraitMode: CGFloat = 100
    let textConstraintLandscapeMode: CGFloat = 20
    
    // UI Items
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    
    @IBAction func topTextEditing(sender: UITextField) {
        if(sender.text == "TOP") {
            sender.text = ""
            return
        }
    }
    
    @IBAction func bottomTextEditing(sender: UITextField) {
        shouldSlideView = true
        if(sender.text == "BOTTOM") {
            sender.text = ""
            return
        }
    }
    @IBAction func bottomTextEditingEnd(sender: UITextField) {
        shouldSlideView = false
    }
    
    @IBAction func cancelButtonTouch(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    @IBAction func shareButtonTouch(sender: UIBarButtonItem) {
        let memeImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            _ = MemeModel(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, originalImage: self.imageView.image!, memeImage: memeImage)
        }
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func albumButtonTouch(sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func cameraButtonTouch(sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func generateMemedImage() -> UIImage {
        let defaultBackGroundColor = view.backgroundColor
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.setToolbarHidden(true, animated: false)
        view.backgroundColor = UIColor.whiteColor()
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        // do error handling here
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.setToolbarHidden(false, animated: false)
        view.backgroundColor = defaultBackGroundColor
        
        return memedImage
    }
    
    // View Init
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: self.view.window)
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
        
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = NSTextAlignment.Center
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // Image picker delegate
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
        imageView.image = image
        shareButton.enabled = true
    }
    
    // Keyboard delegates
    func keyboardWillShow(notification: NSNotification) {
        if(!shouldSlideView){
            return
        }
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            // No need to slide if the view already up
            if(view.frame.origin.y == 0) {
                view.frame.origin.y -= keyboardSize.height
                navigationController?.navigationBar.frame.origin.y -= keyboardSize.height
                navigationController?.toolbar.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if(!shouldSlideView){
            return
        }
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            // No need to slide if the view already down
            if(view.frame.origin.y != 0) {
                view.frame.origin.y += keyboardSize.height
                navigationController?.navigationBar.frame.origin.y += keyboardSize.height
                navigationController?.toolbar.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    // View rotation handler
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if (traitCollection.verticalSizeClass == .Compact) {

        }
        else {
        }
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        // Landscape mode
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            bottomTextBottomConstraint.constant = textConstraintLandscapeMode
        }
        // Portrait mode
        else {
            bottomTextBottomConstraint.constant = textConstraintPortraitMode
        }
    }
}