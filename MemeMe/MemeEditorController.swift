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
    
    @IBOutlet var imageView: UIImageView!
    
    @IBAction func topTextEditing(sender: UITextField) {
        if(sender.text == "TOP") {
            sender.text = ""
            return
        }
        
        if(sender.text == "") {
            sender.text = "TOP"
            return
        }
    }
    
    @IBAction func bottomTextEditing(sender: UITextField) {
        if(sender.text == "BOTTOM") {
            sender.text = ""
            return
        }
        
        if(sender.text == "") {
            sender.text = "BOTTOM"
            return
        }
    }
    
    @IBAction func cancelButtonTouch(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: {});
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
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
        imageView.image = image
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
