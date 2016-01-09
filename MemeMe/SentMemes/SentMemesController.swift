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
    }
    
    @IBAction func tableTouch(sender: UIBarButtonItem) {
    }
    
    @IBAction func gridTouch(sender: UIBarButtonItem) {
    }
    
    override func viewDidLoad() {
        CustomPhotoAlbum()
        print(MemesDataSourceModel.memes)
    }
    
    override func viewDidAppear(animated: Bool) {
        print("viewDidAppear")
        print(MemesDataSourceModel.memes)
        if(MemesDataSourceModel.memes.count > 0) {
            CustomPhotoAlbum.sharedInstance.saveImage(MemesDataSourceModel.memes[0].memeImage)
        }
    }
}