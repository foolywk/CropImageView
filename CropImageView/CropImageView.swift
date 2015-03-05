//
//  CropImageView.swift
//  CropImageView
//
//  Created by Brandon Foo on 1/15/15.
//  Copyright (c) 2015 CTRL LA. All rights reserved.
//

import UIKit
import Darwin

protocol CropImageViewDelegate {
    
    func cropImageViewDidEndEditing(#cropImageView: CropImageView, contentOffset: CGPoint, zoomScale: CGFloat)
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
        scrollView.bouncesZoom = false
        scrollView.delegate = self
        addSubview(scrollView)
        
        // add imageView
        imageView = UIImageView(frame: CGRectMake(0, 0, scrollView.frame.width, scrollView.frame.height))
        scrollView.addSubview(imageView)
        
        container.addSubview(self)
    }
    
    func setImage(image: UIImage) {
        
        scrollView.zoomScale = 1.0
        
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
        
        // set max zoom scale
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
    }
    
    func setImage(image: UIImage, contentOffset: CGPoint?, zoomScale: CGFloat?) {
        
        setImage(image)
        
        println("\n## cropImageView.setImage() called")
        
        if let scale = zoomScale { // Set zoom scale
            
            scrollView.setZoomScale(scale, animated: false)
        }
        
        if let offset = contentOffset { // Set content offset
            scrollView.setContentOffset(offset, animated: false)
        }
    }
    
    func croppedImage() -> UIImage {
        
        var newImage = UIImage()
        
        if var image = imageView.image {
            
            // get image orientation data and rotate if needed
            var rotateDegrees: CGFloat = 0
            
            switch image.imageOrientation {
            case .Left:     rotateDegrees = -90
            case .Right:    rotateDegrees = 90
            case .Up:       rotateDegrees = 0
            case .Down:     rotateDegrees = 180
            default: break
            }
            
            if let rotatedImage = UIImage(CGImage: image.CGImage)?.imageByRotatingByDegrees(rotateDegrees) {
                image = rotatedImage
            }
            
            // find the scale of UIImage / UIImageView
            let scale = image.size.width / imageView.frame.width
            
            // calculate the crop rectangle
            let x = scrollView.contentOffset.x * scale
            let y = scrollView.contentOffset.y * scale
            let width = frame.width * scale
            let height = frame.height * scale
            
            // create new UIImage
            let imageRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(x, y, width, height))
            if let cropImage = UIImage(CGImage: imageRef) {
                newImage = cropImage
            }
        }
        return newImage
    }
    
    // MARK: UIScrollViewDelegate
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
        delegate?.cropImageViewDidEndEditing(cropImageView: self, contentOffset: scrollView.contentOffset, zoomScale: scale)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        delegate?.cropImageViewDidEndEditing(cropImageView: self, contentOffset: scrollView.contentOffset, zoomScale: scrollView.zoomScale)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.cropImageViewDidEndEditing(cropImageView: self, contentOffset: scrollView.contentOffset, zoomScale: scrollView.zoomScale)
    }
}