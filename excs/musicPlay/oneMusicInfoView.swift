//
//  oneMusicInfoView.swift
//  excs
//
//  Created by user on 2018. 12. 2..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class oneMusicInfoView: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var textConstraint: NSLayoutConstraint!
    @IBAction func editBegin(_ sender: Any) {
        textConstraint.constant = 260
    }
    @IBAction func editEnd(_ sender: Any) {
        textConstraint.constant = 0
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textConstraint.constant = 0
        commentTextField.resignFirstResponder()
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentItemList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = commentItemList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentTableCell") as! oneMusicCell
        //cell.commentLike = row.is_liked
        cell.commentTime.text = row.time
        cell.commentTime.sizeToFit()
        //cell.commentLikes.text = String(row.num_like)
        cell.commentContent.text = row.content
        cell.commentContent.sizeToFit()
        cell.commentUser.text = row.nickname
        cell.commentUser.sizeToFit()
        Alamofire.request(row.img_url).responseImage { response in
            if let image = response.result.value{
                
                cell.commentImage.layer.masksToBounds = true
                cell.commentImage.image = image
                cell.commentImage.layer.cornerRadius = cell.commentImage.bounds.size.width / 2
            }
        }
        return cell
    }
    
//    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//    let myview: oneMusicInfoView = storyboard.instantiateViewController(withIdentifier: "musicInfoView") as! oneMusicInfoView
//   myview.musicId = self.player
//    self.present(myview, animated: true, completion: nil)
    
    
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var anotherTitle: UILabel!
    @IBOutlet weak var musicTitle: UILabel!
    @IBOutlet weak var musicArtist: UILabel!
    @IBOutlet weak var musicGenre: UILabel!
    @IBOutlet weak var musicTime: UILabel!
    @IBOutlet weak var musicLike: UILabel!
    @IBOutlet weak var theView: UIView!
    @IBOutlet weak var theUpperView: UIView!
    
    
    //cell.info = ["artist" : rrow.artist, "title" : rrow.title, "music-id" : rrow.musicid, "album-img" : rrow.imageurl, "like" : rrow.like, "gerne" : rrow.gerne, "artistIMG" : rrow.artistimage, "upload-time" : rrow.time] as [String : Any]
    func itemLoad(){
        musicTitle.text = info["title"] as? String
        anotherTitle.text = musicTitle.text
        musicTitle.adjustsFontSizeToFitWidth = true
        anotherTitle.adjustsFontSizeToFitWidth = true
        musicArtist.text = info["artist"] as? String
        musicArtist.adjustsFontSizeToFitWidth = true
        musicGenre.text = info["gerne"] as? String
        musicTime.text = info["upload-time"] as? String
        musicLike.text = String((info["like"] as? Int)!) + "개"
        Alamofire.request((info["album-img"] as? String)!).responseImage { response in
            if let image = response.result.value{
                self.albumImage.image = image
            }
        }
        
        theView.layer.borderWidth = 0.3
        theView.layer.borderColor = UIColor.gray.cgColor
        theUpperView.layer.borderWidth = 0.3
        theUpperView.layer.borderColor = UIColor.black.cgColor
    }
    func loadingalert(){
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadingalert()
        itemLoad()
        commentTextField.delegate = self
        commentBtn.layer.cornerRadius = 3
        likeinit()
        commentLoad(completion: {
            print("ss")
            self.commentList.reloadData()
        })
        
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    func likeinit(){
        let musicIID = musicId
        let likepara1 : Parameters = ["mid" : musicIID]
        var likeheader1 = ["x-access-token" : ""]
        likeheader1["x-access-token"] = UserDefaults.standard.string(forKey: "loginToken")!
        Alamofire.request("https://indi-list.com/api/isLiked", method: .post, parameters: likepara1, encoding: JSONEncoding.default, headers: likeheader1).responseString { response in
            print(response)
            if(response.result.value == "true"){
                self.heartimage.image = UIImage(named: "hghpink")
            }
            if(response.result.value == "false"){
                self.heartimage.image = UIImage(named: "hghgray")
            }
        }
    }
    
    var rowNum = Int(0)
    var musicId = String()
    var info = [String : Any]()
    @IBOutlet weak var commentList: UITableView!
    struct commentItem{
        var time : String
        var num_like : Int
        var is_liked : Int
        var nickname : String
        var content : String
        var img_url : String
    }
    var commentItemList = Array<commentItem>()
    
    func commentLoad(completion: @escaping ()->()){
        let url = "https://www.indi-list.com/api/GetMusicComments"
        let para : Parameters = [ "musicid" : musicId]
        var headers = ["x-access-token" : "", "Content-type" : "application/json"]
        let str = UserDefaults.standard.string(forKey: "loginToken")!
        headers["x-access-token"] = str
        
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers : headers).responseJSON { response in
            
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
                    while(true){
                        if(swiftyJsonVar[self.rowNum].exists()){
                            self.commentItemList.append(commentItem.init(time: swiftyJsonVar[self.rowNum]["time"].string!, num_like: swiftyJsonVar[self.rowNum]["num_like"].int!, is_liked: swiftyJsonVar[self.rowNum]["is_liked"].int!, nickname: swiftyJsonVar[self.rowNum]["nickname"].string!, content: swiftyJsonVar[self.rowNum]["content"].string!, img_url: swiftyJsonVar[self.rowNum]["photo"].string!))
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
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: {
            if(UserDefaults.standard.bool(forKey: "isHidden") == true){
                NotificationCenter.default.post(name: NSNotification.Name("MenuOpen"), object: nil)
            }
        })
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("errorP"), object: nil)
    }
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBAction func commentBtn(_ sender: Any) {
        if(commentTextField.text == ""){
            loginAlert(alertMessage: "한 글자 이상 입력해주세요")
            return
        }
        else{
            let url = "https://www.indi-list.com/api/AddMusicComment"
            let para : Parameters = [ "musicid" : musicId, "content" : self.commentTextField.text!]
            var headers = ["x-access-token" : "", "Content-type" : "application/json"]
            let str = UserDefaults.standard.string(forKey: "loginToken")!
            headers["x-access-token"] = str
            Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers : headers).responseJSON { response in
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
                            self.commentBtn.sendActions(for: .touchUpInside)
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
                        self.commentList.reloadData()
                        self.commentTextField.text = ""
                        self.hnialert(alertMessage: "잠시 후 댓글이 업로드됩니다")
                        self.textFieldShouldReturn(self.commentTextField)
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var heartimage: UIImageView!
    @IBAction func likeBtn(_ sender: Any) {
        let para : Parameters = ["mid" : musicId]
        let likeurl = "https://indi-list.com/api/"
        let last1 = "AddLike"
        let tokenheader = ["x-access-token" : UserDefaults.standard.string(forKey: "loginToken")!]
        Alamofire.request(likeurl + last1, method: .post, parameters: para, encoding: JSONEncoding.default, headers: tokenheader).responseString{ response in
            print(response)
            if(response.result.value! == "false"){
                NotificationCenter.default.post(name: NSNotification.Name("ZZZ"), object: nil)
                print("좋아요가 되어있습니다. 좋아요를 취소합니다.")
                self.info["like"] = (self.info["like"] as? Int)! - 1
                self.musicLike.text = String((self.info["like"] as? Int)!) + "개"
                self.heartimage.image = UIImage(named: "hghgray")
                let last2 = "DeleteLike"
                Alamofire.request(likeurl + last2, method: .post, parameters: para, encoding: JSONEncoding.default, headers: tokenheader).responseString{ response in
                    
                }
                
            }
            else{
                NotificationCenter.default.post(name: NSNotification.Name("ZZZ"), object: nil)
                print("좋아요!")
                self.heartimage.image = UIImage(named: "hghpink")
                self.info["like"] = (self.info["like"] as? Int)! + 1
                self.musicLike.text = String((self.info["like"] as? Int)!) + "개"
            }
        }
        
    }
    
    @IBOutlet weak var commentBtn: UIButton!
    
    func loginAlert(alertMessage : String){
        let myAlert = UIAlertController(title: "경고", message: alertMessage, preferredStyle: UIAlertController.Style.alert);
        
        let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        present(myAlert, animated: true, completion: nil)
    }
    
    func hnialert(alertMessage : String){
        let myAlert = UIAlertController(title: "성공!", message: alertMessage, preferredStyle: UIAlertController.Style.alert);
        
        let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        present(myAlert, animated: true, completion: nil)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
