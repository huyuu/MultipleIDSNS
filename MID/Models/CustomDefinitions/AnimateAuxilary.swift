//
//  AnimateAuxilary.swift
//  MID
//
//  Created by 江宇揚 on 2019/08/01.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit


extension UIView {
    public static func calculateDurationGivenYInfos(bottomPosition: CGFloat, topPosition: CGFloat, currentPosition: CGFloat, velocity: CGFloat) -> TimeInterval {
        let isTowardTop = velocity < 0
        let isTowardBottom = velocity > 0
        
        if isTowardTop {
            let distanceToTop = currentPosition - topPosition
            return Double( distanceToTop / (-velocity) )
        } else if isTowardBottom {
            let distanceToBottom = bottomPosition - currentPosition
            return Double( distanceToBottom / velocity )
        } else {
            return 0.0
        }
    }
    
    
    public enum UIMotionDuration: TimeInterval {
        case superFast = 0.1
        case quiteFast = 0.24
        case fast = 0.3
        case slow = 0.6
        case quiteSlow = 0.72
        case superSlow = 1.0
    }
}
