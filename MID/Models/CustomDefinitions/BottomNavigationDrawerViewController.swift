//
//  BottomNavigationDrawerViewController.swift
//  MID
//
//  Created by 江宇揚 on 2019/08/01.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

class BottomNavigationDrawerViewController: UIViewController {
    
    var expansionState: BottomNavigationDrawerViewController.ExpansionState = .closed

    
    /**
     Define the expansion state of a bottom navigation drawer.
     Note that the `close` state represents that the bottom navigation drawer is showing minimum information, such as header. At this state, it appears as its minimum size, as if is closed while waiting for user interactions.
    */
    public enum ExpansionState {
        case full
        case partial
        case closed
        case invisible
    }
    
    public static func standardYPosition(at state: BottomNavigationDrawerViewController.ExpansionState) -> CGFloat {
        switch state {
        case .full:
            return 100
        case .partial:
            return UIScreen.main.bounds.height/2
        case .closed:
            return UIScreen.main.bounds.height - 60
        case .invisible:
            return UIScreen.main.bounds.height
        }
    }
}
