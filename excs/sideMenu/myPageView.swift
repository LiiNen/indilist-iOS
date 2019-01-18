//
//  myPageView.swift
//  excs
//
//  Created by user on 2018. 11. 26..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

class myPageView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name("menuDo1"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("menuDo2"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("menuDo3"), object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("MenuClose"), object: nil)
        
        let temp = UserDefaults.standard.string(forKey: "mainState")
        let str = "ShowTheView" + temp!
        NotificationCenter.default.post(name: NSNotification.Name(str), object: nil)
        print("생기다")
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        //NotificationCenter.default.post(name: NSNotification.Name("errorP"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("MenuOpen"), object: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
