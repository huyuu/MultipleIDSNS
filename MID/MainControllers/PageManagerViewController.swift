//
//  PageManagerViewController.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/10.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//

import UIKit

class PageManagerViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("view did load.")
        
        if let viewController = initiatePage(){
            setViewControllers([viewController], direction: .forward, animated: false, completion: nil)
            print("page exists.")
        }
    }
    
    
    func initiatePage() -> UITableViewController? {
        guard let page = storyboard!.instantiateViewController(withIdentifier: "MainViewController") as? UITableViewController else {   return nil }
        
        // page exists
        
        
        return page
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension PageManagerViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? UITableViewController,
            let pageIndex = viewController.pageIndex {
            return
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        <#code#>
    }
    
    
}
