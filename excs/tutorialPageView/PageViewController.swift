//
//  PageViewController.swift
//  excs
//
//  Created by user on 2018. 9. 13..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    lazy var subViewControllers:[UIViewController] = {
        return[
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pageView1") as! pageView1,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pageView2") as! pageView2,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pageView3") as! pageView3,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pageView4") as! pageView4,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pageView5") as! pageView5,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pageView6") as! pageView6
        ]
    } ()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        setViewControllers([subViewControllers[0]], direction: .forward, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex:Int = subViewControllers.index(of: viewController) ?? 0
        if (currentIndex <= 0){
            return nil
        }
        return subViewControllers[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex:Int = subViewControllers.index(of: viewController) ?? 0
        if (currentIndex >= subViewControllers.count - 1){
            return nil
        }
        return subViewControllers[currentIndex + 1]
    }
}
