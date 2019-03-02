//
//  lyricsViewController.swift
//  excs
//
//  Created by user on 2019. 3. 2..
//  Copyright © 2019년 user. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class lyricsViewController: UIViewController {

    @IBOutlet var lyricsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lyricsView.backgroundColor = UIColor(white: 1, alpha: 0.8)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        self.lyricsView.addGestureRecognizer(gesture)
    }
    
    @objc func someAction(_ sender:UITapGestureRecognizer){
        print("view touched")
        NotificationCenter.default.post(name: NSNotification.Name("lyricsoffAction"), object: nil)
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
