//
//  ViewController.swift
//  MemeMe
//
//  Created by Max Saienko on 11/6/15.
//  Copyright © 2015 Max Saienko. All rights reserved.
//

import UIKit
import MobileCoreServices

class SentMemesController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var imagePicker: UIImagePickerController!
    
    @IBAction func editTouch(sender: UIBarButtonItem) {
//        let controller = UIImagePickerController()
//        self.presentViewController(controller, animated: true) {(bb) -> Void in
//            print(bb)
//            }
        
        let image = UIImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func addTouch(sender: UIBarButtonItem) {
        //        imagePicker =  UIImagePickerController()
        //        imagePicker.delegate = self
        //        imagePicker.sourceType = .Camera
        //
        //        presentViewController(imagePicker, animated: true, completion: nil)
        print("add")
        print(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            print("Button capture")
            
            let imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = UIImagePickerControllerSourceType.Camera;
            //imag.mediaTypes = [kUTTypeImage]
            imag.allowsEditing = false
            
            self.presentViewController(imag, animated: true, completion: nil)
        }
    }
    
    @IBAction func tableTouch(sender: UIBarButtonItem) {
    }
    
    @IBAction func gridTouch(sender: UIBarButtonItem) {
    }
    
    //    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    //        imagePicker.dismissViewControllerAnimated(true, completion: nil)
    //        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    //    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        print("i've got an image");
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("cancel")
    }
}

