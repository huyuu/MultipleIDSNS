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
    
    
    public func standardDismiss(completion: (() -> ())? = nil) {
        UIView.animate(withDuration: Standards.UIMotionDuration.superFast,
            animations: {
                self.frame = CGRect(x: 0, y: BottomNavigationDrawerViewController.standardYPosition(at: .invisible), width: self.frame.width, height: self.frame.height)
        }, completion: { _ in
            completion?()
        })
        
    }
}



extension UIViewController {
    public func standardDismiss(completion: (() -> ())? = nil) {
        UIView.animate(withDuration: Standards.UIMotionDuration.superFast,
                       animations: {
                        self.view.frame = CGRect(x: 0, y: BottomNavigationDrawerViewController.standardYPosition(at: .invisible), width: self.view.frame.width, height: self.view.frame.height)
        }, completion: { _ in
            completion?()
        })
    }
}
