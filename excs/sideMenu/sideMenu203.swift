//
//  sideMenu203.swift
//  excs
//
//  Created by user on 2018. 10. 4..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class sideMenu203: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var noticeTable: UITableView!
    var rowNum = Int(0)
    
    struct noticeItem{
        var notice_num : Int
        var title : String
        var time : String
    }
    
    var noticeItemList = Array<noticeItem>()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = noticeItemList[indexPath.row]
        UserDefaults.standard.setValue(row.notice_num, forKey: "noticenum")
        UserDefaults.standard.synchronize()
        performSegue(withIdentifier: "detailnotice", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = noticeItemList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "noticeTableCell")
        cell?.textLabel?.text = row.title
        let timeString = row.time as String
        let splited = timeString.components(separatedBy: "-")
        let splited2array = Array(splited[2])
        let daytext : String = "\(splited2array[0])\(splited2array[1])"
        cell?.detailTextLabel?.text = splited[0] + "." + splited[1] + "." + daytext
        return cell!
    }
    
    
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
    
    func noticeLoad(completion: @escaping ()->()){
        let url = "https://www.indi-list.com/GetNoticeList"
        let headers = [ "Content-Type" : "application/json" ]
        let para : Parameters = [ "num" : INT_MAX]
        
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers : headers).responseJSON { response in
            
            let swiftyJsonVar : JSON
            
            if((response.result.value) != nil) {
                swiftyJsonVar = JSON(response.result.value!)
                print(swiftyJsonVar)
                
                while(true){
                    if(swiftyJsonVar[self.rowNum].exists()){
                        self.noticeItemList.append(noticeItem.init(notice_num: swiftyJsonVar[self.rowNum]["notice_num"].int!, title: swiftyJsonVar[self.rowNum]["title"].string!, time: swiftyJsonVar[self.rowNum]["time"].string!))
                        self.rowNum = self.rowNum+1
                    }
                    else{
                        break
                    }
                }
                
            }
            
            completion()
        }
    }
    
    func noticeTextLoad(noticeNum : Int, completion: @escaping ()->()) {
        let url = "https://www.indi-list.com/GetNotice"
        let headers = [ "Content-Type" : "application/json" ]
        let para : Parameters = [ "noticenum" : noticeNum]
        
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers : headers).responseJSON { response in
            
            let swiftyJsonVar : JSON
            if((response.result.value) != nil){
                swiftyJsonVar = JSON(response.result.value!)
                print(swiftyJsonVar)
//                print(swiftyJsonVar[0]["important"])
//                print(swiftyJsonVar[0]["notice_num"])
//                print(swiftyJsonVar[0]["title"].string!)
//                print(swiftyJsonVar[0]["time"].string!)
//                print(swiftyJsonVar[0]["writer"].string!)
            }
            
            completion()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("MenuOpen"), object: nil)
        noticeLoad(completion: {
            self.noticeTable.reloadData()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("MenuClose"), object: nil)
        
        let temp = UserDefaults.standard.string(forKey: "mainState")
        let str = "ShowTheView" + temp!
        NotificationCenter.default.post(name: NSNotification.Name(str), object: nil)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        //NotificationCenter.default.post(name: NSNotification.Name("errorP"), object: nil)
    }
}
