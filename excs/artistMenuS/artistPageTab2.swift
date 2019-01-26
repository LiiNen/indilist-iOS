//
//  artistPageTab2.swift
//  excs
//
//  Created by user on 2018. 11. 27..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

class artistPageTab2: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var musicTable: UITableView!
    
    var rowNum = Int(0)
    struct musicItem{
        var artist : String
        var title : String
        var imageurl : String
        var musicid : String
        var genre : String
        var like : Int
        var artistimage : String
        var time : String
    }
    var musicItemList = [musicItem]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(musicItemList.count, "first")
        return musicItemList.count
    }
    
    @objc func buttonAction(sender: UIButton){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let myview: oneMusicInfoView = storyboard.instantiateViewController(withIdentifier: "musicInfoView") as! oneMusicInfoView
        myview.musicId = UserDefaults.standard.string(forKey: "musicInfoSeek")!
        myview.info = UserDefaults.standard.value(forKey: "musicInfoSeek2")! as! [String : Any]
        self.present(myview, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = musicItemList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicTableCell") as! musicTableViewCell
        cell.artistName.text = row.artist
        cell.titleName.text = row.title + "  /  " + row.genre
        
        cell.info = ["artist" : row.artist, "title" : row.title, "music-id" : row.musicid, "album-img" : row.imageurl, "like" : row.like, "gerne" : row.genre, "artistIMG" : row.artistimage, "upload-time" : row.time] as [String : Any]
        print(">>why doesn;t work?", cell.info)
        cell.infoBtnBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        cell.musicid = row.musicid
        
        cell.artistName.isHidden = true
        cell.albumArtImageView.layer.masksToBounds = true
        if UserDefaults.standard.string(forKey: "notME") != nil{
            cell.deleteBtn.isEnabled = false
            cell.deleteBtn.isHidden = true
        }
        else{
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("deleteAlert" + cell.musicid), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(alertFunc), name: NSNotification.Name("deleteAlert" + cell.musicid), object: nil)
        }
        cell.albumArtImageView.image = UIImage(named: "defaultMusicImage")
        cell.albumArtImageView.af_setImage(withURL: URL(string: row.imageurl)!)
        cell.infoBtnBtn.imageEdgeInsets = UIEdgeInsets(top: CGFloat(6), left: CGFloat(6), bottom: CGFloat(6), right: CGFloat(6))
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.string(forKey: "notME") != nil{
            
            musicListLoadId(completion: {
                self.musicTable.reloadData()
            })
        }
        else{
            musicListLoad(completion:{
                print("reload")
                self.musicTable.reloadData()
            })
            }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func musicListLoadId(completion: @escaping ()->()){
        let url = "https://www.indi-list.com/PersonalSongListbyNum"
        let infoseekid = UserDefaults.standard.integer(forKey: "infoseekid")
        let para : Parameters = ["num" : infoseekid]
        let headers = ["Content-Type" : "application/json"]
        
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers : headers).responseJSON { response in
            
            print(response)
            
            if let json = response.result.value {
                let arrayTemp : NSArray  = json as! NSArray
                for i in 0..<arrayTemp.count{
                    self.musicItemList.append(musicItem(
                        artist: ((arrayTemp[i] as AnyObject).value(forKey: "artist") as? String)!,
                        title: ((arrayTemp[i] as AnyObject).value(forKey: "title") as? String)!,
                        imageurl: ((arrayTemp[i] as AnyObject).value(forKey: "album-img") as? String)!,
                        musicid: ((arrayTemp[i] as AnyObject).value(forKey: "music-id") as? String)!,
                        genre: ((arrayTemp[i] as AnyObject).value(forKey: "genre") as? String)!,
                        like: ((arrayTemp[i] as AnyObject).value(forKey: "like") as? Int)!,
                        artistimage: ((arrayTemp[i] as AnyObject).value(forKey: "artistIMG") as? String)!,
                        time: (((arrayTemp[i]) as AnyObject).value(forKey: "upload-time") as? String)!
                    ))
                    
                }
                print(self.musicItemList)
                print(self.musicItemList.count)
                
                self.musicTable.reloadData()
            }
            completion()
        }
        self.musicTable.reloadData()
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
    
    func musicListLoad(completion: @escaping ()->()){
        let url = "https://www.indi-list.com/api/PersonalSongList"
        let para : Parameters = ["Content-Type" : "application/json"]
        var headers = ["x-access-token" : ""]
        let str = UserDefaults.standard.string(forKey: "loginToken")!
        headers["x-access-token"] = str
        
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers : headers).responseJSON { response in
            
            print(response)
            
            if let json = response.result.value {
                
                
                let swiftyJsonVar : JSON
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
                            self.musicListLoad(completion: {
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
                        let arrayTemp : NSArray  = json as! NSArray
                        for i in 0..<arrayTemp.count{
                            self.musicItemList.append(musicItem(
                                artist: ((arrayTemp[i] as AnyObject).value(forKey: "artist") as? String)!,
                                title: ((arrayTemp[i] as AnyObject).value(forKey: "title") as? String)!,
                                imageurl: ((arrayTemp[i] as AnyObject).value(forKey: "album-img") as? String)!,
                                musicid: ((arrayTemp[i] as AnyObject).value(forKey: "music-id") as? String)!,
                                genre: ((arrayTemp[i] as AnyObject).value(forKey: "genre") as? String)!,
                                like: ((arrayTemp[i] as AnyObject).value(forKey: "like") as? Int)!,
                                artistimage: ((arrayTemp[i] as AnyObject).value(forKey: "artistIMG") as? String)!,
                                time: (((arrayTemp[i]) as AnyObject).value(forKey: "upload-time") as? String)!
                            ))
                        }
                    }
                }
                self.musicTable.reloadData()
            }
            completion()
        }
        self.musicTable.reloadData()
    }
        
    
    
    
    @objc func alertFunc(){
        alertAc(mesAlert: "정말로 삭제하시겠습니까?", completion: {
            self.musicTable.reloadData()
        })
    }
    
    func alertAc(mesAlert:String, completion: @escaping ()->()){
        let myAlert = UIAlertController(title: "경고", message: mesAlert, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "네", style: UIAlertActionStyle.default) {
            UIAlertAction in
            UserDefaults.standard.setValue("true", forKey: "deleteAns")
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name("deleteChk"), object: nil)
        }
        let cancelAction = UIAlertAction(title: "아니오", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            UserDefaults.standard.setValue("false", forKey: "deleteAns")
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name("deleteChk"), object: nil)
        }
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        present(myAlert, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let row = musicItemList[indexPath.row]
        let addingTemp = ["artist" : row.artist, "title" : row.title, "music-id" : row.musicid, "album-img" : row.imageurl, "like" : row.like, "gerne" : row.genre, "artistIMG" : row.artistimage, "upload-time" : row.time] as [String : Any]
        UserDefaults.standard.set(addingTemp, forKey: "addMusic")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name("addingMusic"), object: nil)
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
}
