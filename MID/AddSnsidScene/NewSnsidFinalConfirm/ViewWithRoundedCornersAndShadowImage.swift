//
//  ViewWithRoundedCornersAndShadowImage.swift
//  MID
//
//  Created by 江宇揚 on 2019/08/04.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

@IBDesignable
class ViewWithRoundedCornersAndShadowImage: UIView {
    
    private var cornerRadius: CGFloat = 0
    private var image: UIImage? = nil
    private var baseColor = UIColor.white
    private var accentColor = UIColor.primaryColor
    private var shouldHideShadowAtDefault = false
    private var shouldShowCameraPatternAtDefault = true
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepare()
    }
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.prepare()
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = UIColor.white
        // set proper corner to ensure that the base view is a circle.
        self.layer.cornerRadius = self.cornerRadius
        // set shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 5
        // turn off masksToBounds
        self.layer.masksToBounds = false
        
        // If image is set, show it.
        if let image = self.image {
            // make an imageView
            let imageView = UIImageView(frame: self.bounds)
            imageView.contentMode = .scaleAspectFill
            // make its shape circle
            imageView.layer.cornerRadius = self.cornerRadius
            imageView.layer.masksToBounds = true
            imageView.clipsToBounds = true
            imageView.image = image
            // background will be white when image exists.
            imageView.backgroundColor = UIColor.white
            
            self.addSubview(imageView)
            
        } else { // If the image is still not set, show the default camera pattern.
            self.layer.shadowOpacity = shouldHideShadowAtDefault ? 0 : 0.6
            
            guard shouldShowCameraPatternAtDefault == true else { return }
            
            let widthOfCamera: CGFloat = 40.0
            /// A custom frame which the camera is drawn in.
            let cameraRect = CGRect(x: self.bounds.midX-widthOfCamera/2,
                                 y: self.bounds.midY-widthOfCamera/2,
                                 width: widthOfCamera,
                                 height: widthOfCamera)
            let (shellPath, circlePath) = CAShapeLayer.drawCameraPattern(in: cameraRect)
            // first, the shell shape
            let shellLayer = CAShapeLayer()
            shellLayer.path = shellPath.cgPath
            shellLayer.fillColor = self.accentColor.cgColor
            // second, the middle circle shape
            let circleLayer = CAShapeLayer()
            circleLayer.path = circlePath.cgPath
            circleLayer.strokeColor = self.baseColor.cgColor
            circleLayer.fillColor = self.accentColor.cgColor
            circleLayer.lineWidth = 4.0
            // a background of camera pattern.
            let cameraPatternLayer = CAShapeLayer()
            cameraPatternLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.cornerRadius).cgPath
            cameraPatternLayer.fillColor = self.baseColor.cgColor
            // combine all of the above.
            cameraPatternLayer.addSublayer(shellLayer)
            cameraPatternLayer.addSublayer(circleLayer)
            self.layer.addSublayer(cameraPatternLayer)
        }
    }

    
    
    // MARK: - Custom Helper Functions
    private func prepare() {
        self.backgroundColor = UIColor.clear
    }
    
    
    internal func layoutWith(image: UIImage?=nil,
                             cornerRadius: CGFloat?=nil,
                             baseColor: UIColor=UIColor.white,
                             accentColor: UIColor=UIColor.primaryColor,
                             shouldHideShadowAtDefault: Bool=false,
                             shouldShowCameraPatternAtDefault: Bool=true) {
        self.image = image
        self.cornerRadius = cornerRadius == nil ? self.bounds.width/2 : cornerRadius!
        self.baseColor = baseColor
        self.accentColor = accentColor
        self.shouldHideShadowAtDefault = shouldHideShadowAtDefault
        self.shouldShowCameraPatternAtDefault = shouldShowCameraPatternAtDefault
        
        setNeedsDisplay()
        setNeedsLayout()
    }
}
