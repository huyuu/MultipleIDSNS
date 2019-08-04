//
//  ViewWithRoundedCornersAndShadowImage.swift
//  MID
//
//  Created by 江宇揚 on 2019/08/04.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

class ViewWithRoundedCornersAndShadowImage: UIView {
    
    private var cornerRadius: CGFloat = 0
    private var image: UIImage? = nil

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = UIColor.white
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.cornerRadius).cgPath
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        let imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = self.cornerRadius
        imageView.layer.masksToBounds = true
        imageView.image = self.image
        
        self.addSubview(imageView)
    }

    
    
    internal func layoutWith(image: UIImage?=nil, cornerRadius: CGFloat?=nil) {
        self.image = image
        self.cornerRadius = cornerRadius == nil ? self.bounds.width/2 : cornerRadius!
        setNeedsLayout()
    }
}
