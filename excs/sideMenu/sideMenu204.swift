//
//  sideMenu204.swift
//  excs
//
//  Created by user on 2018. 10. 4..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

class sideMenu204: UIViewController {

    @IBOutlet weak var navItem204: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name("menuDo1"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("menuDo2"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("menuDo3"), object: nil)
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("MenuClose"), object: nil)
        
        let temp = UserDefaults.standard.string(forKey: "mainState")
        let str = "ShowTheView" + temp!
        NotificationCenter.default.post(name: NSNotification.Name(str), object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("MenuOpen"), object: nil)
    }
    
//    func backFunc(sender: UIBarButtonItem){
//        NotificationCenter.default.post(name: NSNotification.Name("MenuClose"), object: nil)
//        
//        let temp = UserDefaults.standard.string(forKey: "mainState")
//        let str = "ShowTheView" + temp!
//        NotificationCenter.default.post(name: NSNotification.Name(str), object: nil)
//    }
    
    //view will disappear의 내용을 back button push시의 action으로 변경해야함. 다른 view도 마찬가지
    
    
}
