//
//  AddSNSIDViewController.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/20.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//

import UIKit

class AddSNSIDViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func addSNSIDdidCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
