//
//  CropImageView.swift
//  CropImageView
//
//  Created by Brandon Foo on 1/15/15.
//  Copyright (c) 2015 CTRL LA. All rights reserved.
//

import UIKit

protocol CropImageViewDelegate {
    
    func cropImageViewDidEndEditing(#cropImageView: CropImageView, contentOffset: CGPoint)
}


class CropImageView: UIView, UIScrollViewDelegate {
    
    var delegate: CropImageViewDelegate?
    
    var scrollView = UIScrollView()
    var imageView = UIImageView()
    
    override init() {
        super.init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(container: UIView, delegate: CropImageViewDelegate ) {
        
        super.init(frame: CGRectMake(0, 0, container.frame.width, container.frame.height))
        
        // set delegate
        self.delegate = delegate
        
        // add scrollView
        scrollView = UIScrollView(frame: CGRectMake(0, 0, frame.width, frame.height))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        addSubview(scrollView)
        
        // add imageView
        imageView = UIImageView(frame: CGRectMake(0, 0, scrollView.frame.width, scrollView.frame.height))
        scrollView.addSubview(imageView)
        
        container.addSubview(self)
    }
    
    func setImage(image: UIImage) {
        
        // set the image view's aspect ratio to that of the input image
        let aspectRatio = image.size.width / image.size.height
        
        // try matching imageView height to frame's height
        imageView.frame.size.height = frame.height
        imageView.frame.size.width = aspectRatio * imageView.frame.height
        
        // if the width doesn't fill the frame, resize to match imageView width to frame width
        if imageView.frame.size.width < frame.width {
            imageView.frame.size.width = frame.width
            imageView.frame.size.height = imageView.frame.size.width / aspectRatio
        }
        
        // update scrollview content size to that of imageView & center in container
        scrollView.contentSize = CGSizeMake(imageView.frame.width, imageView.frame.height)
        
        // add image
        imageView.image = image
    }
    
    func setImage(image: UIImage, contentOffset: CGPoint?) {
        
        setImage(image)
        (contentOffset != nil ) ? scrollView.setContentOffset(contentOffset!, animated: false) : scrollView.setContentOffset(CGPointMake(0, 0), animated: false)
    }
    
    func croppedImage() -> UIImage {
        var newImage = UIImage()
        
        if let image = imageView.image {
            
            // find the scale of UIImage / UIImageView
            let scale = image.size.width / imageView.frame.width * UIScreen.mainScreen().scale
            
            // calculate the crop rectangle
            let x = scrollView.contentOffset.x * scale
            let y = scrollView.contentOffset.y * scale
            let width = frame.width * scale
            let height = frame.height * scale
            
            // create new UIImage
            let imageRef = CGImageCreateWithImageInRect(imageView.image?.CGImage, CGRectMake(x, y, width, height))
            if let croppedImage = UIImage(CGImage: imageRef) {
                newImage = croppedImage
            }
        }
        return newImage
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        delegate?.cropImageViewDidEndEditing(cropImageView: self, contentOffset: scrollView.contentOffset)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.cropImageViewDidEndEditing(cropImageView: self, contentOffset: scrollView.contentOffset)
    }
}