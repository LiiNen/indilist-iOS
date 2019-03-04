//
//  artistPageView.swift
//  excs
//
//  Created by user on 2018. 11. 26..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class artistPageView: UIViewController {

    @IBOutlet weak var newsUploadBtn: UIButton!
    @IBOutlet weak var musicUploadBtn: UIButton!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var gerneLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var likenum: UILabel!
    @IBOutlet weak var musicnum: UILabel!
    @IBOutlet weak var ranknum: UILabel!
    
    @IBOutlet weak var artistImage: UIImageView!
    
    @IBOutlet weak var heartimage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("MenuOpen"), object: nil)
    }
    func imageupload(url : String){
        Alamofire.request(url).responseImage { response in
            if let imagel = response.result.value {
                self.artistImage.image = imagel
                self.artistImage.layer.masksToBounds = true
                self.artistImage.layer.cornerRadius = 0.5 * (self.artistImage.bounds.size.width)
            }
        }
    }
    var artistIdForInfo = -1
    var albumStringFrom = ""
    var rets = String()
    func likeconsider(completion: @escaping() -> ()){
        let url = "https://indi-list.com/api/ARLiked"
        var para : Parameters = ["num" : -1]
        let a : Int? = Int(UserDefaults.standard.string(forKey: "loginArtistNum")!)
        para["num"] = a
        var headers = ["x-access-token" : UserDefaults.standard.string(forKey: "loginToken")!]
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            print("are you like?", response)
            
            let swiftyJsonVar : JSON
            if((response.result.value) != nil){
                swiftyJsonVar = JSON(response.result.value!)
                if(swiftyJsonVar["err"].exists()){
                    if(swiftyJsonVar["result"].string! == "update"){
                        print(swiftyJsonVar["token"].string!)
                        print("토큰이 교체됩니다. 이하의 토큰으로 진행해주세요.")
                        let tok = swiftyJsonVar["token"].string!
                        headers["x-access-token"] = tok;
                        UserDefaults.standard.setValue(tok, forKey: "loginToken")
                        UserDefaults.standard.synchronize()
                        self.likeconsider(completion: {
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
                    let pinkheart = UIImage(named: "hghpink")!
                    let grayheart = UIImage(named: "hghgray")!
                    print(swiftyJsonVar)
                    if(swiftyJsonVar == true){
                        print("like liek")
                        self.heartimage.image = pinkheart
                        self.rets = "true"
                        completion()
                    }
                    else{
                        print("sidisidid")
                        self.heartimage.image = grayheart
                        self.rets = "false"
                        completion()
                    }
                }
                
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
    @IBAction func letslike(_ sender: Any) {
        var url = String()
        var para : Parameters = ["num" : -1]
        let a : Int? = Int(UserDefaults.standard.string(forKey: "loginArtistNum")!)
        para["num"] = a
        let headers = ["x-access-token" : UserDefaults.standard.string(forKey: "loginToken")!]
        likeconsider(completion:{
            if(self.rets == "false"){
                url = "https://indi-list.com/api/AddArtistLike"
            }
            else if(self.rets == "true"){
                url = "https://indi-list.com/api/DelArtistLike"
            }
            Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers: headers).responseString { response in
                if(response.value! == "true"){
                    if(self.rets == "false"){
                        self.heartimage.image = UIImage(named: "hghpink")
                        self.likenum.text = String(Int(self.likenum.text!)! + 1)
                        self.rets = "true"
                        print("like!")
                    }
                    else if(self.rets == "true"){
                        self.heartimage.image = UIImage(named: "hghgray")
                        self.likenum.text = String(Int(self.likenum.text!)! - 1)
                        self.rets = "false"
                        print("dislike!")
                    }
                }
            }
        })
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        btnMake()
        likeconsider(completion: {
            
        })
        NotificationCenter.default.post(name: NSNotification.Name("menuDo1"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("menuDo2"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("menuDo3"), object: nil)
        if(artistIdForInfo == -1){
            backBtn.isEnabled = false
            backBtn.isHidden = true
            let artistnum = UserDefaults.standard.string(forKey: "loginArtistNum")!
            let album_url = UserDefaults.standard.string(forKey: "loginPhoto")!
            getInfo(num: artistnum)
            imageupload(url: album_url)
        }
        else{
            newsUploadBtn.isEnabled = false
            musicUploadBtn.isEnabled = false
            newsUploadBtn.isHidden = true
            musicUploadBtn.isHidden = true
            getInfoId(num: artistIdForInfo)
            imageupload(url: albumStringFrom)
        }
        // Do any additional setup after loading the view.
    }
    func getInfoId(num: Int){
        let url2 = "https://www.indi-list.com/GetArtistInfobyNum"
        let para2 : Parameters = ["num" : num]
        let headers2 = ["Content-Type" : "application/json"]
        NotificationCenter.default.post(name: NSNotification.Name("loadArtistNews"), object: nil)
        Alamofire.request(url2, method:.post, parameters: para2, encoding: JSONEncoding.default, headers: headers2).responseJSON { response in
            let swiftyJsonVar : JSON
            print(response)
            if((response.result.value) != nil) {
                swiftyJsonVar = JSON(response.result.value!)
                self.nameLabel.text = swiftyJsonVar[0]["artist_name"].string!
                self.gerneLabel.text = swiftyJsonVar[0]["artist_genre"].string!
                self.introLabel.text = swiftyJsonVar[0]["artist_intro"].string!
                self.musicnum.text = String(swiftyJsonVar[0]["num_song"].int!) + "곡"
                self.likenum.text = String(swiftyJsonVar[0]["artist_like"].int!)
            }
        }
        Alamofire.request("https://www.indi-list.com/PersonalArtistRank", method: .post, parameters: para2, encoding: JSONEncoding.default, headers: headers2).responseString { response in
            print(para2)
            print(response)
            self.ranknum.text = response.result.value! + "위"
        }
    }
    func getInfo(num: String){
        let url = "https://www.indi-list.com/api/GetArtistInfobyID"
        var para : Parameters = ["num" : -1]
        var headers = ["x-access-token" : UserDefaults.standard.string(forKey: "loginToken")!]
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            let swiftyJsonVar : JSON
            print(response)
            if((response.result.value) != nil) {
                swiftyJsonVar = JSON(response.result.value!)
                if(swiftyJsonVar["err"].exists()){
                    if(swiftyJsonVar["result"].string! == "update"){
                        print(swiftyJsonVar["token"].string!)
                        print("토큰이 교체됩니다. 이하의 토큰으로 진행해주세요.")
                        let tok = swiftyJsonVar["token"].string!
                        headers["x-access-token"] = tok;
                        UserDefaults.standard.setValue(tok, forKey: "loginToken")
                        UserDefaults.standard.synchronize()
                        self.getInfo(num: num)
                        return;
                    }
                    else{
                        self.showToast(message: "다시 로그인해주세요")
                        self.removeOb()
                        NotificationCenter.default.post(name: NSNotification.Name("logOutAction"), object: nil)
                        
                        return;
                    }
                }
                else{
                    self.nameLabel.text = swiftyJsonVar[0]["artist_name"].string!
                    self.gerneLabel.text = swiftyJsonVar[0]["artist_genre"].string!
                    self.introLabel.text = swiftyJsonVar[0]["artist_intro"].string!
                    self.musicnum.text = String(swiftyJsonVar[0]["num_song"].int!) + "곡"
                    self.likenum.text = String(swiftyJsonVar[0]["artist_like"].int!)
                    
//                    UserDefaults.standard.setValue(swiftyJsonVar[0]["artist_num"].int!, forKey: "artistNewsId")
//                    UserDefaults.standard.synchronize()
                    
                    let intte : Int? = Int(num)
                    para["num"] = intte
                    Alamofire.request("https://www.indi-list.com/PersonalArtistRank", method: .post, parameters: para, encoding: JSONEncoding.default, headers: ["Content-type" : "application/json"]).responseString { response in
                        print(para)
                        print(response)
                        self.ranknum.text = response.result.value! + "위"
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func btnMake(){
        newsUploadBtn.layer.borderWidth = 1.0
        newsUploadBtn.layer.borderColor = UIColor.gray.cgColor
        newsUploadBtn.layer.cornerRadius = 5
        musicUploadBtn.layer.borderWidth = 1.0
        musicUploadBtn.layer.borderColor = UIColor.gray.cgColor
        musicUploadBtn.layer.cornerRadius = 5
        infoView.layer.borderWidth = 0.7
        infoView.layer.borderColor = UIColor.gray.cgColor
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("MenuClose"), object: nil)
        
        let temp = UserDefaults.standard.string(forKey: "mainState")
        let str = "ShowTheView" + temp!
        NotificationCenter.default.post(name: NSNotification.Name(str), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("artistReload"), object: nil)
        print("생기다")
        
    }
    
    func alertAc(mesAlert:String){
        let myAlert = UIAlertController(title: "처리 완료", message: mesAlert, preferredStyle: UIAlertController.Style.alert);
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        present(myAlert, animated: true, completion: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
    }
    @IBAction func backBtn(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "notME")
        UserDefaults.standard.removeObject(forKey: "infoseekid")
        dismiss(animated: true, completion: nil)
    }
    
}
