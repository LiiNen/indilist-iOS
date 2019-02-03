//
//  musicPlayerContainerView.swift
//  excs
//
//  Created by user on 2018. 11. 10..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit
import Alamofire
import AVKit
import SwiftyJSON
import AlamofireImage

class musicPlayerContainerView: UIViewController {

    @IBOutlet weak var musicListBtn: UIButton!
    @IBOutlet weak var albumArtBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var musicTitle: UILabel!
    @IBOutlet weak var musicArtist: UILabel!
    
    let myMusicPlayerViewController = AVPlayerViewController()
    
    var policy = String()
    var signature = String()
    var keyPair = String()
    var domainString = String()
    
    var player = AVPlayer()
    
    var musicDomain = URL(string: "")
    var cookieHeaders = [String : String]()
    
    var headers = ["x-access-token" : "eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImFiY2QxMjM0IiwiZXhwIjoxNTcxNjM5NDQ0LCJleHBfcmVmcmVzaCI6MTU0MDEwNzA0NCwiaWF0IjoxNTQwMTAzNDQzfQ.afJSQvcj9aHuG_uZ-tK_8XCZpnVkYANqTCn_m9w3D7klxZQKxYvZ64mArMSf4Orwt95VCdpi9NuLviocnQNjbkSpFp0rOX5WlmLbMEHJduxF9R2FhRQi0jR2j9rLFnSSMh8tLeeCOzXxp5Xs6JuKc-rYHmNlI8K7HzdtEVVgkF0"]
    
    let url = "https://indi-list.com/api/getmusic/"
    var assets : AVURLAsset!
    var para : Parameters = [ "mid" : "" ]
    var playListArray = ["20921", "57305"]
    var playListIndex = Int()
    
    let arr = ["1", "2", "3", "4"]
    
    var time = DispatchTime.now()
    
    var indexNum = 0
    
    var temp = Array<[String:Any?]>() //이거로 플레이리스트 사용
    //artist, title, music-id, album-img, like, gerne, artistIMG, upload-time
    
    @IBAction func playBtn(_ sender: Any) {
        let myState = UserDefaults.standard.string(forKey: "mainState")!
        print(myState)
        if(myState == "1"){
            playFunc()
        }
        else{
            print("play post r")
            NotificationCenter.default.post(name: NSNotification.Name("musicPlay"), object: nil)
        }
    }
    @IBAction func nextBtn(_ sender: Any) {
        let myState = UserDefaults.standard.string(forKey: "mainState")
        if(myState == "1"){
            playMusic()
        }
        else{
            print("포스트 ㄱ")
            NotificationCenter.default.post(name: NSNotification.Name("musicNext"), object: nil)
        }
    }
    
    @objc func nextFunc(){
        playMusic()
    }

    @IBOutlet weak var playwidth: NSLayoutConstraint!
    @IBOutlet weak var playbetweennext: NSLayoutConstraint!
    @objc func playFunc(){
        if(self.player.currentItem == nil){
            self.playBtn.setImage(UIImage(named: "pausebutton"), for: .normal)
            playwidth.constant = 18.5
            playbetweennext.constant = 27.8
            playMusic()
            NotificationCenter.default.post(name: NSNotification.Name("B11"), object: nil)
        }
        else if(player.rate != 0 && player.error == nil){
            self.player.pause()
            self.playBtn.setImage(UIImage(named: "playbutton"), for: .normal)
            playwidth.constant = 25
            playbetweennext.constant = 23
            NotificationCenter.default.post(name: NSNotification.Name("B22"), object: nil)
        }
        else{
            self.player.play()
            self.playBtn.setImage(UIImage(named: "pausebutton"), for: .normal)
            playwidth.constant = 18.5
            playbetweennext.constant = 27.8
            NotificationCenter.default.post(name: NSNotification.Name("B11"), object: nil)
        }
    }
    
    @IBAction func beforeBtn(_ sender: Any) {
        beforeFunc()
    }
    @objc func beforeFunc(){
        self.indexNum = self.indexNum - 1
        if(self.indexNum < 0){
            self.indexNum = self.temp.count - 1
        }
        self.indexNum = self.indexNum - 1
        if(self.indexNum < 0){
            self.indexNum = self.temp.count - 1
        }
        let id = UserDefaults.standard.string(forKey: "loginId")!
        UserDefaults.standard.setValue(self.indexNum, forKey: "musicplayindex" + id)
        UserDefaults.standard.synchronize()
        playMusic()
    }
    
    @objc func musicToMylist(){
        let id = UserDefaults.standard.string(forKey: "loginId")!
        temp = UserDefaults.standard.value(forKey: "ownplaylist" + id) as! [[String : Any?]]
        let a = UserDefaults.standard.value(forKey: "addMusic") as! [String : Any?]
        temp.append(a)
        UserDefaults.standard.setValue(temp.count - 1, forKey: "musicplayindex" + id)
        UserDefaults.standard.set(temp, forKey: "ownplaylist" + id)
        UserDefaults.standard.synchronize()
        playMusic()
        //artist, title, music-id, album-img, like, gerne, artistIMG, upload-time
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("옵저버 준비중")
        NotificationCenter.default.addObserver(self, selector: #selector(playFunc), name: NSNotification.Name("musicPlay"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(nextFunc), name: NSNotification.Name("musicNext"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beforeFunc), name: NSNotification.Name("musicBefore"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(musicToMylist), name: NSNotification.Name("addingMusic"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(albumPress), name: NSNotification.Name("AAA"), object: nil)
        
        if let id = UserDefaults.standard.string(forKey: "loginId"){
            if let tempt = UserDefaults.standard.value(forKey: "ownplaylist" + id) {
                temp = tempt as! [[String : Any?]]
            }
        }
        
        
        //temp.append(["artistIMG" : "https://d1e9zqysfkgjz.cloudfront.net/profile/kims01110/kims01110_profile","artist" : "Invense","album-img" : "https://d1e9zqysfkgjz.cloudfront.net/AlbumArt/kims01110/20921","genre" : "Ballad","like" : 26, "music-id" : "20921","title" : "하늘","upload-time" : "2018-09-19T16:37:28.000Z"])
        //temp.append(["artistIMG" : "https://d1e9zqysfkgjz.cloudfront.net/profile/gayeon0811/gayeon0811_profile_1539851170967","artist" : "이가연","album-img" : "https://d1e9zqysfkgjz.cloudfront.net/AlbumArt/gayeon0811/3427","genre" : "Ballad","like" : 9,"music-id" : "3427","title" : "너란 사람","upload-time" : "2018-10-18T17:30:48.000Z"])
        NotificationCenter.default.addObserver(self, selector: #selector(deleteAVPlayer), name: NSNotification.Name("logoutAV"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeOb), name: NSNotification.Name("KKK"), object: nil)
    }
    @objc func deleteAVPlayer(){
        self.player.pause()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func musicRequest(mid : String,  completion: @escaping ()->()){
        self.para["mid"] = mid
        
        let albumArtURL = URL(string: temp[self.indexNum]["album-img"] as! String)
        musicTitle.text = (temp[self.indexNum]["title"] as! String)
        musicTitle.adjustsFontSizeToFitWidth = true
        musicArtist.text = (temp[self.indexNum]["artist"] as! String)
        musicArtist.adjustsFontSizeToFitWidth = true
        
        albumArtBtn.af_setImage(for: .normal, url: albumArtURL!)
         
        headers["x-access-token"] = UserDefaults.standard.string(forKey: "loginToken")
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers : self.headers).responseJSON { response in
            
            let swiftyJsonVar : JSON
            
            if((response.result.value) != nil) {
                swiftyJsonVar = JSON(response.result.value!)
                print("origin : ", swiftyJsonVar)
                if(swiftyJsonVar["err"].exists()){
                    if(swiftyJsonVar["result"].string! == "update"){
                        print(swiftyJsonVar["token"].string!)
                        print("토큰이 교체됩니다. 이하의 토큰으로 진행해주세요.")
                        let tok = swiftyJsonVar["token"].string!
                        self.headers["x-access-token"] = tok;
                        UserDefaults.standard.setValue(tok, forKey: "loginToken")
                        UserDefaults.standard.synchronize()
                        self.musicRequest(mid: mid, completion: {
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
                    self.policy = swiftyJsonVar[0]["CloudFront-Policy"].string!
                    self.signature = swiftyJsonVar[1]["CloudFront-Signature"].string!
                    self.keyPair = swiftyJsonVar[2]["CloudFront-Key-Pair-Id"].string!
                    self.domainString = swiftyJsonVar[3]["music"].string!
                    let domain = URL(string : ("https://" + self.domainString))
                    
                    let policyS = "CloudFront-Policy=" + self.policy + ","
                    let signatureS = " CloudFront-Signature=" + self.signature + ","
                    let keyPairS = " CloudFront-Key-Pair-Id=" + self.keyPair
                    self.cookieHeaders["Cookie"] = policyS + signatureS + keyPairS
                    self.musicDomain = domain
                    
                    DispatchQueue.main.asyncAfter(deadline: self.time){
                        print(self.musicDomain!)
                        completion()
                    }
                }
            }
        }
    }
    
    func playMusic() {
        if(temp.count == 0){
            let nonMusicAlert = UIAlertController(title: "", message: "플레이리스트에 노래가 없습니다", preferredStyle: UIAlertController.Style.alert);
            let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
            nonMusicAlert.addAction(okAction)
            present(nonMusicAlert, animated: true, completion: nil)
            return
        }
        let id = UserDefaults.standard.string(forKey: "loginId")!
        temp = UserDefaults.standard.value(forKey: "ownplaylist" + id) as! [[String : Any?]]
        self.indexNum = UserDefaults.standard.integer(forKey: "musicplayindex" + id)
        self.playBtn.setImage(UIImage(named: "pausebutton"), for: .normal)
        playwidth.constant = 18.5
        playbetweennext.constant = 27.8
        NotificationCenter.default.post(name: NSNotification.Name("B11"), object: nil)
        musicRequest(mid: temp[indexNum]["music-id"] as! String/*playListArray[indexNum]*/, completion: {
            self.settingCookieAction(completion: {
                self.player.pause()
                //print(HTTPCookieStorage.shared.cookies!)
                self.settingPlayer(completion:{
                    self.player.play()
                    self.sendAVplayer()
                    UserDefaults.standard.setValue(self.temp[self.indexNum], forKey: "nowPlaying")
                    //print(self.temp[self.indexNum], "is expected to")
                    UserDefaults.standard.synchronize()
                    NotificationCenter.default.post(name: NSNotification.Name("loadReady"), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name("loadReady2"), object: nil)
                    do {
                        try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode(rawValue: convertFromAVAudioSessionMode(AVAudioSession.Mode.default)), options: .mixWithOthers)
                        try AVAudioSession.sharedInstance().setActive(true)
                    } catch {
                        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
                        print(error)
                    }
                    
                    self.indexNum = self.indexNum + 1
                    if(self.indexNum >= self.temp.count){
                        self.indexNum = 0
                    }
                    UserDefaults.standard.setValue(self.indexNum, forKey: "musicplayindex" + id)
                    UserDefaults.standard.synchronize()
                })
            })
            //when the music play finish
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(musicPlayerContainerView.playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        })
    }
    
    func settingPlayer(completion: @escaping ()->()){
        settingPlayerItem(completion:{
            completion()
        })
        
    }
    func settingPlayerItem(completion: @escaping ()->()){
        let item = AVPlayerItem(asset: self.assets)
        self.player.replaceCurrentItem(with: item)
        completion()
    }
    
    
    func settingCookieAction(completion: @escaping ()->()){
        settingCookie2(completion:{
            let cookiesArray = HTTPCookieStorage.shared.cookies
            let values = (HTTPCookie.requestHeaderFields(with: cookiesArray!))
            let cookieArrayOptions = (["AVURLAssetHTTPHeaderFieldsKey": values])
            self.assets = AVURLAsset(url: self.musicDomain! as URL, options: cookieArrayOptions)
            completion()
        })
    }
    
    func settingCookie2(completion: @escaping ()->()){
        let cookieHeaderField = (["Set-Cookie": self.cookieHeaders["Cookie"]!])
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: cookieHeaderField, for: self.musicDomain!)
        for oldCookie in HTTPCookieStorage.shared.cookies! {
            HTTPCookieStorage.shared.deleteCookie(oldCookie)
        }
        HTTPCookieStorage.shared.setCookies(cookies, for: self.musicDomain!, mainDocumentURL: self.musicDomain!)
        completion()
    }
    
    @objc func albumPress(){
        albumArtBtn(self)
    }
    
    @IBAction func albumArtBtn(_ sender: Any) {
        if(player.currentItem == nil){
            let nonMusicAlert = UIAlertController(title: "", message: "재생중인 노래가 없습니다", preferredStyle: UIAlertController.Style.alert);
            let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
            nonMusicAlert.addAction(okAction)
            present(nonMusicAlert, animated: true, completion: nil)
        }
        else{
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let myview: musicPlayerView = storyboard.instantiateViewController(withIdentifier: "musicPlayerView") as! musicPlayerView
            myview.player = self.player
            self.present(myview, animated: true, completion: nil)
        }
    }
    @IBAction func playlistBtn(_ sender: Any) {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let myview: UIViewController = storyboard.instantiateViewController(withIdentifier: "playlistViewController")
            self.present(myview, animated: true, completion: nil)
    }
    
    
    @objc func playerDidFinishPlaying(){
        print("Video Finished")
        let id = UserDefaults.standard.string(forKey: "loginId")!
        temp = UserDefaults.standard.value(forKey: "ownplaylist" + id) as! [[String : Any?]]
        if(temp.count == 0){
            return
        }
        else{
            playMusic()
        }
    }
    
    func sendAVplayer(){
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        headers["x-access-token"] = UserDefaults.standard.string(forKey: "loginToken")
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionMode(_ input: AVAudioSession.Mode) -> String {
	return input.rawValue
}
