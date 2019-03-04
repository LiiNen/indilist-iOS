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

    @IBOutlet weak var warningTextView: UITextView!
    @IBOutlet var lyricsView: UIView!
    @IBOutlet weak var lyricsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lyricsView.backgroundColor = UIColor(white: 1, alpha: 0.8)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        self.lyricsView.addGestureRecognizer(gesture)
        NotificationCenter.default.addObserver(self, selector: #selector(lyricsBtnPush), name: NSNotification.Name("lyricsOn"), object: nil)
        self.lyricsTextView.alpha = 0.8
        self.warningTextView.isHidden = true
    }
    
    @objc func someAction(_ sender:UITapGestureRecognizer){
        print("view touched")
        NotificationCenter.default.post(name: NSNotification.Name("lyricsoffAction"), object: nil)
    }
    
    @objc func lyricsBtnPush(){
        let nowp = UserDefaults.standard.value(forKey: "nowPlaying")! as! [String : Any]
        let tempStringnowp = nowp["music-id"] as! String
        print(tempStringnowp)
        
        Alamofire.request("https://indi-list.com/api/GetLyrics", method: .post, parameters: ["mid" : tempStringnowp], encoding: JSONEncoding.default, headers : ["x-access-token" : UserDefaults.standard.string(forKey: "loginToken")!]).responseJSON { response in
            
            if let json = response.result.value{
                let temp : NSArray = json as! NSArray
                print(temp)
                if(((temp[0] as AnyObject).value(forKey: "lyrics") as? String) == nil){
                    self.lyricsTextView.text = "등록된 가사가 없습니다."
                }
                else{
                    self.lyricsTextView.text = ((temp[0] as AnyObject).value(forKey: "lyrics") as? String)!
                    print("lyrics exist")
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
