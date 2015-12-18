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
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        dismissViewControllerAnimated(true, completion: { () -> Void in
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