//
//  artistPageTab1.swift
//  excs
//
//  Created by user on 2018. 11. 27..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage

class artistPageTab1: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name("loadArtistNews"), object: nil)
        print("whydoesnoe")
        NotificationCenter.default.addObserver(self, selector: #selector(loadNews), name: NSNotification.Name("loadArtistNews"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loadNews(){
        print("success load action")
        let url = "https://indi-list.com/GetPersonalArtistNewsbyNum"
        let para : Parameters = ["num" : 0]
        let headers = ["Content-Type" : "application/json"]
//        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers : headers).responseJSON { response in
//
//            print(response)
//        }
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
