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
        if(sender.text == "BOTTOM") {
            sender.text = ""
            return
        }
    }
    
    @IBAction func cancelButtonTouch(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: {});
        //imageView.image = generateMemedImage()
    }
    
    @IBAction func shareButtonTouch(sender: UIBarButtonItem) {
        let activityViewController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        /* If you want to exclude certain types from sharing
        options you could ajouter them to the excludedActivityTypes */
        //        vc.excludedActivityTypes = [UIActivityTypeMail]
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.contentMode = .ScaleAspectFit
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = NSTextAlignment.Center
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            view.frame.origin.y -= keyboardSize.height
            navigationController?.navigationBar.frame.origin.y -= keyboardSize.height
            navigationController?.toolbar.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            view.frame.origin.y += keyboardSize.height
            navigationController?.navigationBar.frame.origin.y += keyboardSize.height
            navigationController?.toolbar.frame.origin.y += keyboardSize.height
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
        imageView.image = image
        shareButton.enabled = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    //    func textToImage(drawText: NSString, inImage: UIImage, atPoint:CGPoint)->UIImage{
    //
    //        // Setup the font specific variables
    //        let textColor: UIColor = UIColor.whiteColor()
    //        let textFont: UIFont = UIFont(name: "Helvetica Bold", size: 12)!
    //
    //        //Setup the image context using the passed image.
    //        UIGraphicsBeginImageContext(inImage.size)
    //
    //        //Setups up the font attributes that will be later used to dictate how the text should be drawn
    //        let textFontAttributes = [
    //            NSFontAttributeName: textFont,
    //            NSForegroundColorAttributeName: textColor,
    //        ]
    //
    //        //Put the image into a rectangle as large as the original image.
    //        inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))
    //
    //        // Creating a point within the space that is as bit as the image.
    //        let rect: CGRect = CGRectMake(atPoint.x, atPoint.y, inImage.size.width, inImage.size.height)
    //
    //        //Now Draw the text into an image.
    //        drawText.drawInRect(rect, withAttributes: textFontAttributes)
    //
    //        // Create a new image out of the images nous avons created
    //        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
    //
    //        // End the context maintenant that nous avons the image we need
    //        UIGraphicsEndImageContext()
    //
    //        //And pass it back up to the caller.
    //        return newImage
    //
    //    }
    
    
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
