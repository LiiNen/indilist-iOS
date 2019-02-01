//
//  musicInfoView.swift
//  excs
//
//  Created by user on 2018. 11. 27..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class musicInfoView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var commentsTable: UITableView!
    
    var rowNum = Int(0)
    
    struct commentItem{
        var time : String
        var num_like : Int
        var is_liked : Int
        var nickname : String
        var content : String
    }
    
    var commentItemList = Array<commentItem>()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return rowNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = commentItemList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentsTableCell")
        cell?.textLabel?.text = row.nickname
        cell?.detailTextLabel?.text = row.content
        return cell!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func commentLoad(completion: @escaping ()->()){
        let url = "https://www.indi-list.com/api/GetMusicComments"
        let para : Parameters = [ "musicid" : "80425"]
        var headers = ["x-access-token" : ""]
        let str = UserDefaults.standard.string(forKey: "loginToken")!
        headers["x-access-token"] = str
        
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers : headers).responseJSON { response in
            
            print(response)
            if((response.result.value) != nil) {
                
                var swiftyJsonVar : JSON
                if((response.result.value) != nil) {
                    swiftyJsonVar = JSON(response.result.value!)
                    print("origin : ", swiftyJsonVar)
                    if(swiftyJsonVar["err"].exists()){
                        if(swiftyJsonVar["result"].string! == "update"){
                            print(swiftyJsonVar["token"].string!)
                            print("토큰이 교체됩니다. 이하의 토큰으로 진행해주세요.")
                            let tok = swiftyJsonVar["token"].string!
                            headers["x-access-token"] = tok;
                            UserDefaults.standard.setValue(tok, forKey: "loginToken")
                            UserDefaults.standard.synchronize()
                            self.commentLoad(completion: {
                                completion()
                                return;
                            })
                        }
                        else{
                            self.showToast(message: "다시 로그인해주세요")
                            self.removeOb()
                            NotificationCenter.default.post(name: NSNotification.Name("logOutAction"), object: nil)
                            return;
                        }
                    }
                    else{
                        swiftyJsonVar = JSON(response.result.value!)
                        while(true){
                            if(swiftyJsonVar[self.rowNum].exists()){
                                self.commentItemList.append(commentItem.init(time: swiftyJsonVar[self.rowNum]["time"].string!, num_like: swiftyJsonVar[self.rowNum]["num_like"].int!, is_liked: swiftyJsonVar[self.rowNum]["is_liked"].int!, nickname: swiftyJsonVar[self.rowNum]["nickname"].string!, content: swiftyJsonVar[self.rowNum]["content"].string!))
                                print(self.commentItemList[self.rowNum])
                                self.rowNum = self.rowNum+1
                            }
                            else{
                                break
                            }
                        }
                    }
                }
                completion()
            }
        }
    }
    @objc func removeOb(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("musicPlay"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("musicNext"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("musicBefore"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("addingMusic"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("AAA"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("logoutAV"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("KKK"), object: nil)
    }
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - self.view.frame.size.width*0.3, y: self.view.frame.size.height-100, width: self.view.frame.size.width*0.6, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 10.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        commentLoad(completion: {
            print("ss")
            self.commentsTable.reloadData()
        })
        
        NotificationCenter.default.post(name: NSNotification.Name("MenuOpen"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //NotificationCenter.default.post(name: NSNotification.Name("MenuClose"), object: nil)
        
        let temp = UserDefaults.standard.string(forKey: "mainState")
        let str = "ShowTheView" + temp!
        NotificationCenter.default.post(name: NSNotification.Name(str), object: nil)
        
    }
}
