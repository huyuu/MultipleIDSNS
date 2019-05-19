//
//  PageManagerViewController.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/10.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//

import UIKit

class PageManagerViewController: UIPageViewController {
    
    var currentPageIndex = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("PageManagerViewController did load.")
        
        if let viewController = initiatePage(withIdentifier: "Main0Scene") {
            setViewControllers([viewController], direction: .forward, animated: false, completion: nil)
            print("Main0Scene page exists.")
            dataSource = self
        }
    }
    
    
    private func initiatePage(withIdentifier identifier: String) -> UITableViewController? {
        guard let page = storyboard!.instantiateViewController(withIdentifier: identifier) as? UITableViewController else {   return nil }
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



// MARK: - Manage page changing

extension PageManagerViewController: UIPageViewControllerDataSource {
    
    // Prepare for forward and backward swips
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        switch viewController {  // Current viewController
//        case is Main0TableViewController:
//            currentPageIndex = (viewController as! Main0TableViewController).pageIndex
//            return nil  // Left swip is invalid
//
//        case is Main1TableViewController:
//            currentPageIndex = (viewController as! Main1TableViewController).pageIndex
//            return self.initiatePage(withIdentifier: "Main0Scene")
//
//        // Shouldn't happen
//        default:
//            raiseFatalError("We lost the current page when swipping backward.")
//            return nil
//        }
        
        if viewController.isKind(of: Main0TableViewController.self) {
            currentPageIndex = (viewController as! Main0TableViewController).pageIndex
            return nil  // Left swip is invalid
            
        } else if viewController.isKind(of: TimeLineTableViewController.self) {
            currentPageIndex = (viewController as! TimeLineTableViewController).pageIndex
            return self.initiatePage(withIdentifier: "Main0Scene")
            
        }
        else {
            raiseFatalError("We lost the current page when changing pages.")
            return nil
        }
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        switch viewController {
//        case is Main0TableViewController:
//            currentPageIndex = (viewController as! Main0TableViewController).pageIndex
//            return self.initiatePage(withIdentifier: "Main1Scene")
//
//        case is Main1TableViewController:
//            currentPageIndex = (viewController as! Main1TableViewController).pageIndex
//            return nil
//
//        // Shouldn't happen
//        default:
//            raiseFatalError("We lost the current page when swipping forward.")
//            return nil
//        }
        
        
        if viewController.isKind(of: Main0TableViewController.self) {
            currentPageIndex = (viewController as! Main0TableViewController).pageIndex
            return self.initiatePage(withIdentifier: "Main1Scene")
            
        } else if viewController.isKind(of: Main0TableViewController.self) {
            currentPageIndex = (viewController as! TimeLineTableViewController).pageIndex
            return nil
            
        } else {
            raiseFatalError("We lost the current page when changing pages.")
            return nil
        }
    }
    
    
    // Methods for pageIndicator
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 2
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentPageIndex
    }
}
