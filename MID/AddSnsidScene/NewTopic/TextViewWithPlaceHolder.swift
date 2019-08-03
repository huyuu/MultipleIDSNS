//
//  TextViewWithPlaceHolder.swift
//  MID
//
//  Created by 江宇揚 on 2019/06/30.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

class TextViewWithPlaceHolder: UITextView {
    
    // set placeHolderLabel
    private var placeHolderLabel: UILabel!
    private let placeHolderTextColor = UIColor.lightGray
    /// should be set via delegate
    internal var placeHolder = "Enter Contents..." {
        didSet {
            setNeedsDisplay()
        }
    }
    // update layout whenever text is set
    override var text: String! {
        didSet {
            self.layoutAccordingTo(text)
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepare()
    }
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.prepare()
    }
    
    
    override func draw(_ rect: CGRect) {
        placeHolderLabel.text = placeHolder
        placeHolderLabel.sizeToFit()
        self.addSubview(placeHolderLabel)
    }
    
    
    
    // MARK: Custom Helper Functions
    
    private func prepare() {
        // set placeHolderLabel
        placeHolderLabel = UILabel(frame: CGRect(x: 8, y: 8, width: self.bounds.width, height: 0))
        placeHolderLabel.lineBreakMode = .byTruncatingTail
        placeHolderLabel.numberOfLines = 0
        placeHolderLabel.font = .italicSystemFont(ofSize: 16)
        placeHolderLabel.backgroundColor = UIColor.clear
        placeHolderLabel.textColor = placeHolderTextColor
        // once in the first time
        placeHolderLabel.alpha = self.text.isEmpty ? 1 : 0
    }
    
    
    internal func layoutAccordingTo(_ text: String) {
        placeHolderLabel.alpha = text.isEmpty ? 1 : 0
        self.setNeedsDisplay()
    }
}
