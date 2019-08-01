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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    
    internal enum ExpansionState {
        case full
        case partial
        case closed
    }
}
