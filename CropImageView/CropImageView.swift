//
//  CropImageView.swift
//  CropImageView
//
//  Created by Brandon Foo on 1/15/15.
//  Copyright (c) 2015 CTRL LA. All rights reserved.
//

import UIKit

class CropImageView: UIView {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var imageViewWidthConstraint: NSLayoutConstraint!
    
    func setupInContainer(container: UIView) {
        
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        frame.size = container.frame.size
        container.addSubview(self)
    }
    
    func setImage(image: UIImage) {
        
        // set the image view's aspect ratio to that of the input image
        let aspectRatio = image.size.width / image.size.height
        
        // try matching image view height to frame's height
        imageViewHeightConstraint.constant = frame.height
        imageViewWidthConstraint.constant = aspectRatio * imageViewHeightConstraint.constant
        imageView.layoutIfNeeded()
        
//        if imageView.frame.width < frame.width {
//            imageView.frame.size.width = frame.width
//        }
        
        // update scrollview content size to that of imageView
        scrollView.contentSize = CGSizeMake(imageView.frame.width, imageView.frame.height)
        imageView.image = image
        
        dump(scrollView.frame)
        dump(imageView.frame)
    }
}
