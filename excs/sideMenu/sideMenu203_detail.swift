//
//  sideMenu203_detail.swift
//  excs
//
//  Created by user on 2018. 12. 4..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class sideMenu203_detail: UIViewController {

    @IBOutlet weak var noticeText: UITextView!
    
    var para : Parameters = ["noticenum" : -1]
    
    let url = "https://www.indi-list.com/GetNotice"
    let headers = [ "Content-Type" : "application/json" ]
    
    func loadNotice(){
        para["noticenum"] = UserDefaults.standard.integer(forKey: "noticenum")
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers : headers).responseJSON { response in
            
            let swiftyJsonVar : JSON
            print(response)
            if((response.result.value) != nil){
                swiftyJsonVar = JSON(response.result.value!)
                print(">>",swiftyJsonVar)
                //                print(swiftyJsonVar[0]["important"])
                //                print(swiftyJsonVar[0]["notice_num"])
                //                print(swiftyJsonVar[0]["title"].string!)
                //                print(swiftyJsonVar[0]["time"].string!)
                //                print(swiftyJsonVar[0]["writer"].string!)
                self.noticeText.text = swiftyJsonVar[0]["content"].string!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("MenuOpen"), object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        print("??")
        loadNotice()
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
