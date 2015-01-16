 //
//  ViewController.swift
//  CropImageView
//
//  Created by Brandon Foo on 1/15/15.
//  Copyright (c) 2015 CTRL LA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var cropImageViewContainer: UIView!
    var cropImageView = CropImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cropImageView = CropImageView(container: cropImageViewContainer)
        cropImageView.setImage(UIImage(named:"sampleImage")!)
    }
    
    @IBAction func croppedButtonWasPressed(sender: AnyObject) {
    
        let image = cropImageView.croppedImage()
    }
}

