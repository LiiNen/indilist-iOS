//
//  musicPlayerView.swift
//  excs
//
//  Created by user on 2018. 11. 12..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import AVFoundation
import SwiftyJSON

class musicPlayerView: UIViewController {

    @IBOutlet weak var albumArt: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playerSlider: UISlider!
    @IBOutlet weak var nowTime: UILabel!
    @IBOutlet weak var fullTime: UILabel!
    
    @objc func updateSlider(){
        let currentTimeInSeconds = CMTimeGetSeconds(player.currentTime())
        let mins = currentTimeInSeconds / 60
        let secs = currentTimeInSeconds.truncatingRemainder(dividingBy: 60)
        let timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let minsStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
            return
        }
        nowTime.text = "\(minsStr).\(secsStr)"
        let playerItem = player.currentItem!
        let fullTimeInSeconds = CMTimeGetSeconds(playerItem.duration)
        let min2 = fullTimeInSeconds / 60
        let sec2 = fullTimeInSeconds.truncatingRemainder(dividingBy: 60)
        let timeformatter2 = NumberFormatter()
        timeformatter2.minimumIntegerDigits = 2
        timeformatter2.minimumFractionDigits = 0
        timeformatter2.roundingMode = .down
        guard let min2Str = timeformatter.string(from: NSNumber(value: min2)), let sec2Str = timeformatter.string(from: NSNumber(value: sec2)) else {
            return
        }
        fullTime.text = "\(min2Str).\(sec2Str)"
        playerSlider.value = Float(currentTimeInSeconds)
        
        if let currentItem = player.currentItem {
            let duration = currentItem.duration
            if (CMTIME_IS_INVALID(duration)) {
                return;
            }
            let currentTime = currentItem.currentTime()
            playerSlider.value = Float(CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration))
        }
    }
    @IBAction func sliderChange(_ sender: Any) {
        let fulltime = CMTimeGetSeconds((player.currentItem?.duration)!)
        let timetoseek = playerSlider.value * Float(fulltime)
        let seconds : Int64 = Int64(timetoseek)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        player.seek(to: targetTime)
    }
    
    
    var player = AVPlayer()
    var nowp = [String : Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(player.rate != 0 && player.error == nil){
            playBtn.setImage(UIImage(named: "pauseButton"), for: .normal)
        }
        print("avplayer state : ", player.currentItem!)
        loadNowPlaying()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("loadReady"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadNowPlaying), name: NSNotification.Name("loadReady"), object: nil)
        // Do any additional setup after loading the view.
        let images = UIImage(named: "slider")!
        var newSize: CGSize
        newSize = CGSize(width: 20.5,  height: 20.5)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        images.draw(in: rect)
        let newImage2 = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        playerSlider.setThumbImage(newImage2, for: .normal)
        playerSlider.setThumbImage(newImage2, for: .highlighted)
        
        if(player.currentItem != nil){
            self.updateSlider()
            _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(lyricsOff), name: NSNotification.Name("lyricsoffAction"), object: nil)
        self.lyricsContainer.isHidden = true
    }
    
    @IBOutlet weak var likeBtn: UIButton!
    
    
    @objc func loadNowPlaying(){
        nowp = UserDefaults.standard.value(forKey: "nowPlaying")! as! [String : Any]
        let url = nowp["album-img"] as! String
        titleLabel.text = nowp["title"] as? String
        artistLabel.text = nowp["artist"] as? String
        print(url)
        let uurl = url
        
        let musicIID = nowp["music-id"] as? String
        var likepara1 : Parameters = ["mid" : ""]
        likepara1["mid"] = musicIID
        var likeheader1 = ["x-access-token" : ""]
        likeheader1["x-access-token"] = UserDefaults.standard.string(forKey: "loginToken")!
        Alamofire.request("https://indi-list.com/api/isLiked", method: .post, parameters: likepara1, encoding: JSONEncoding.default, headers: likeheader1).responseString { response in
            if(response.result.value == "true"){
                self.likeBtn.setImage(UIImage(named: "heartPink"), for: .normal)
            }
            if(response.result.value == "false"){
                self.likeBtn.setImage(UIImage(named: "heartGray"), for: .normal)
            }
        }
        
        Alamofire.request(uurl).responseImage { response in
            if let imagel = response.result.value {
                if(imagel.size.width < 260){
                    var newSize: CGSize
                    newSize = CGSize(width: 260,  height: 260)
                    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
                    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
                    imagel.draw(in: rect)
                    let newImage = UIGraphicsGetImageFromCurrentImageContext()!
                    UIGraphicsEndImageContext()
                    self.albumArt.setImage(newImage, for: .normal)
                    print("this is art size width : ", newImage.size.width)
                }
                else{
                    print("this is art size width : ", imagel.size.width)
                    self.albumArt.setImage(imagel, for: .normal)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var playBtn: UIButton!
    @IBAction func playBtn(_ sender: Any) {
        if(player.rate != 0 && player.error == nil){
            playBtn.setImage(UIImage(named: "playButton"), for: .normal)
        }
        else{
            playBtn.setImage(UIImage(named: "pauseButton"), for: .normal)
        }
        NotificationCenter.default.post(name: NSNotification.Name("musicPlay"), object: nil)
        loadNowPlaying()
    }
    @IBAction func nextBtn(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("musicNext"), object: nil)
        playBtn.setImage(UIImage(named: "pauseButton"), for: .normal)
        loadNowPlaying()
    }
    @IBAction func beforeBtn(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("musicBefore"), object: nil)
        playBtn.setImage(UIImage(named: "pauseButton"), for: .normal)
        loadNowPlaying()
    }
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func golistBtn(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let myview: UIViewController = storyboard.instantiateViewController(withIdentifier: "playlistViewController")
        self.present(myview, animated: true, completion: nil)
    }
    
    
    @IBAction func likeBtn(_ sender: Any) {
        nowp = UserDefaults.standard.value(forKey: "nowPlaying")! as! [String : Any]
        let para : Parameters = ["mid" : nowp["music-id"] as! String]
        let likeurl = "https://indi-list.com/api/"
        let last1 = "AddLike"
        let tokenheader = ["x-access-token" : UserDefaults.standard.string(forKey: "loginToken")!]
        Alamofire.request(likeurl + last1, method: .post, parameters: para, encoding: JSONEncoding.default, headers: tokenheader).responseString{ response in
            print(response)
            if(response.result.value! == "false"){
                print("좋아요가 되어있습니다. 좋아요를 취소합니다.")
                self.likeBtn.setImage(UIImage(named: "heartGray"), for: .normal)
                let last2 = "DeleteLike"
                Alamofire.request(likeurl + last2, method: .post, parameters: para, encoding: JSONEncoding.default, headers: tokenheader).responseString{ response in
                    self.nowp["like"] = self.nowp["like"] as! Int - 1
                    UserDefaults.standard.setValue(self.nowp, forKey: "nowPlaying")
                    let id = UserDefaults.standard.string(forKey: "loginId")!
                    var listData = UserDefaults.standard.value(forKey: "ownplaylist" + id) as! [[String : Any?]]
                    for i in (0..<listData.count){
                        if(listData[i]["music-id"] as! String == self.nowp["music-id"] as! String){
                            listData[i]["like"] = self.nowp["like"]
                        }
                    }
                    UserDefaults.standard.setValue(listData, forKey: "ownplaylist" + id)
                    UserDefaults.standard.synchronize()
                }
            }
            else{
                print("좋아요!")
                self.likeBtn.setImage(UIImage(named: "heartPink"), for: .normal)
                self.nowp["like"] = self.nowp["like"] as! Int + 1
                UserDefaults.standard.setValue(self.nowp, forKey: "nowPlaying")
                let id = UserDefaults.standard.string(forKey: "loginId")!
                var listData = UserDefaults.standard.value(forKey: "ownplaylist" + id) as! [[String : Any?]]
                for i in (0..<listData.count){
                    if(listData[i]["music-id"] as! String == self.nowp["music-id"] as! String){
                        listData[i]["like"] = self.nowp["like"]
                    }
                }
                UserDefaults.standard.setValue(listData, forKey: "ownplaylist" + id)
                UserDefaults.standard.synchronize()
            }
        }
            
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("errorP"), object: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func infoBtn(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let twp = UserDefaults.standard.value(forKey: "nowPlaying")! as! [String : Any]
        let myview: oneMusicInfoView = storyboard.instantiateViewController(withIdentifier: "musicInfoView") as! oneMusicInfoView
        myview.musicId = twp["music-id"] as! String
        myview.info = twp
        self.present(myview, animated: true, completion: nil)
    }
    
    @IBAction func albumArtBtn(_ sender: Any) {
        lyricsBtnPush()
    }
    
    
    
    
    @IBOutlet weak var lyricsContainer: UIView!
    @objc func lyricsOff(){
        lyricsContainer.isHidden = true
    }
    
    
    
    
    func lyricsBtnPush(){
        let tempStringnowp = self.nowp["music-id"] as! String
        print(tempStringnowp)
        
        Alamofire.request("https://indi-list.com/api/GetLyrics", method: .post, parameters: ["mid" : tempStringnowp], encoding: JSONEncoding.default, headers : ["x-access-token" : UserDefaults.standard.string(forKey: "loginToken")!]).responseJSON { response in
            
            let swiftyJsonVar : JSON
            
            if((response.result.value) != nil) {
                swiftyJsonVar = JSON(response.result.value!)
                print("origin : ", swiftyJsonVar)
                if(swiftyJsonVar["err"].exists()){
                    if(swiftyJsonVar["result"].string! == "update"){
                        print(swiftyJsonVar["token"].string!)
                        print("토큰이 교체됩니다. 이하의 토큰으로 진행해주세요.")
                        let tok = swiftyJsonVar["token"].string!
                        UserDefaults.standard.setValue(tok, forKey: "loginToken")
                        UserDefaults.standard.synchronize()
                        self.lyricsBtnPush()
                    }
                    else{
                        self.showToast(message: "다시 로그인해주세요")
                        self.removeOb()
                        NotificationCenter.default.post(name: NSNotification.Name("logOutAction"), object: nil)
                        
                        return;
                    }
                }
                else{
                    print(swiftyJsonVar)
                    print("spspspspsps")
                    self.lyricsContainer.isHidden = false
                }
            }
        }
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
    
    @objc func removeOb(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("musicPlay"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("musicNext"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("musicBefore"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("addingMusic"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("AAA"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("logoutAV"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("KKK"), object: nil)
    }
            
}
