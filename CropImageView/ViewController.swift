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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cropImageView = NSBundle.mainBundle().loadNibNamed("CropImageView", owner: self, options: nil).first as CropImageView
        
        cropImageView.setupInContainer(cropImageViewContainer)
        cropImageView.setImage(UIImage(named:"sampleImage")!)
    }
}

