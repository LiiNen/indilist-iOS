//
//  customTabBarController.swift
//  excs
//
//  Created by user on 2018. 10. 29..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

class customTabBarController: UITabBarController, UITabBarControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.selectedIndex = 0
        UserDefaults.standard.setValue(false, forKey: "isHidden")
        errorProtection()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("errorP"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(errorProtection), name: NSNotification.Name("errorP"), object: nil)
        self.delegate = self
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -16)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showTabBar),name:NSNotification.Name("MenuClose"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideTabBar),name:NSNotification.Name("MenuOpen"), object: nil)
        errorProtection()
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex + 1
        UserDefaults.standard.setValue(String(tabBarIndex), forKey: "mainState")
        UserDefaults.standard.synchronize()
        print("is the tabbar index : ", tabBarIndex)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        tabBar.frame = CGRect(x: 0, y: 105, width: tabBar.frame.size.width, height: tabBar.frame.size.height)
        print(tabBar.frame.size.height, "tabbar height")
        
        super.viewDidLayoutSubviews()
    }
    
    @objc func hideTabBar(){
        self.tabBar.isHidden = true
        UserDefaults.standard.setValue(true, forKey: "isHidden")
        UserDefaults.standard.synchronize()
    }
    
    @objc func showTabBar(){
        self.tabBar.isHidden = false
        UserDefaults.standard.setValue(false, forKey: "isHidden")
        UserDefaults.standard.synchronize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
//        let temp = tabBarController?.selectedIndex
//        tabBarController?.selectedIndex = 1
//        tabBarController?.selectedIndex = 2
//        tabBarController?.selectedIndex = temp!
        
    }
    @objc func errorProtection(){
        let temp = self.selectedIndex
        self.selectedIndex = 1
        self.selectedIndex = 2
        self.selectedIndex = temp
        print("errorprotection==-=-=-=-=","__________________---")
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item)
    }

}
