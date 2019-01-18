//
//  pageView6.swift
//  excs
//
//  Created by user on 2018. 9. 13..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

class pageView6: UIViewController {

    @IBOutlet weak var tutofinbtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tutofinbtn.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tutofinbtn(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "tutofin")
        UserDefaults.standard.synchronize()
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
