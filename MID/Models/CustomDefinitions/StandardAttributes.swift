//
//  StandardAttributes.swift
//  MID
//
//  Created by 江宇揚 on 2019/08/01.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

public struct Standards {
    enum CornerRadius {
        static let fullScreenView: CGFloat = 32
        static let largeButton: CGFloat = 20
        static let largeCell: CGFloat = 20
        static let smallCell: CGFloat = 8
        static let formalTextField: CGFloat = 12
    }

    
    enum UIMotionDuration {
        static let superFast = 0.11
        static let quiteFast = 0.24
        static let fast = 0.3
        static let slow = 0.5
        static let quiteSlow = 0.6
        static let superSlow = 1.0
    }
    
    
    enum BorderWidth {
        static let largeCell: CGFloat = 4
        static let smallCell: CGFloat = 2
        static let formalTextField: CGFloat = 1.5
    }
    
    
    enum LineWidth {
        static let None: CGFloat = 0
        static let Thin: CGFloat = 3
        static let Medium: CGFloat = 4
        static let Wide: CGFloat = 6
        static let SuperWide: CGFloat = 18
    }
}

