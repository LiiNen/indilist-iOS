//
//  appInfo.swift
//  excs
//
//  Created by user on 2018. 10. 4..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

class appInfo: UIViewController {

    @IBOutlet weak var infoTExt: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        infoTExt.layer.borderWidth = 0.4
        infoTExt.layer.borderColor = UIColor.black.cgColor
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("MenuOpen"), object: nil)
    }
    
}
