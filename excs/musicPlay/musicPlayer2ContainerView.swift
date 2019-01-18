//
//  musicPlayer2ContainerView.swift
//  excs
//
//  Created by user on 2018. 12. 1..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class musicPlayer2ContainerView: UIViewController {

    @IBOutlet weak var playBtn2: UIButton!
    @IBOutlet weak var playWidth2: NSLayoutConstraint!
    @IBOutlet weak var playBetween2: NSLayoutConstraint!
    
    @IBOutlet weak var musicTitle: UILabel!
    @IBOutlet weak var musicArtist: UILabel!
    @IBOutlet weak var albumArt2: UIButton!
    @IBAction func nextBtn2(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("musicNext"), object: nil)
        loadNowPlaying2()
    }
    @IBAction func beforeBtn2(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("musicBefore"), object: nil)
        loadNowPlaying2()
    }
    @IBAction func playBtn2(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("musicPlay"), object: nil)
        loadNowPlaying2()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNowPlaying2()
        NotificationCenter.default.addObserver(self, selector: #selector(loadNowPlaying2), name: NSNotification.Name("loadReady2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playbtnchange1), name: NSNotification.Name("B11"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playbtnchange2), name: NSNotification.Name("B22"), object: nil)
        // Do any additional setup after loading the view.
    }
    @objc func playbtnchange2(){
        self.playBtn2.setImage(UIImage(named: "playbutton"), for: .normal)
        playWidth2.constant = 25
        playBetween2.constant = 23
    }
    @objc func playbtnchange1(){
        self.playBtn2.setImage(UIImage(named: "pausebutton"), for: .normal)
        playWidth2.constant = 18.5
        playBetween2.constant = 27.8
    }
    @objc func loadNowPlaying2(){
        if let nnowp = UserDefaults.standard.value(forKey: "nowPlaying"){
            let nowp = nnowp as! [String : Any]
            let url = nowp["album-img"] as! String
            print(url)
            let uurl = url
            musicTitle.text = nowp["title"] as! String
            musicTitle.adjustsFontSizeToFitWidth = true
            musicArtist.text = nowp["artist"] as! String
            musicArtist.adjustsFontSizeToFitWidth = true
            print(nowp)
            Alamofire.request(uurl).responseImage { response in
                if let imagel = response.result.value {
                    self.albumArt2.setImage(imagel, for: .normal)
                }
            }
        }
        else{
            albumArt2.setImage(UIImage(named: "defaultMusicImage"), for: .normal)
            musicTitle.text = "재생중인 노래가 없습니다"
            musicArtist.text = ""
        }
    }
    @IBAction func albumArtBtn(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("AAA"), object: nil)
//        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let myview: UIViewController = storyboard.instantiateViewController(withIdentifier: "musicPlayerView")
//        self.present(myview, animated: true, completion: nil)
    }
    @IBAction func playlistBtn(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let myview: UIViewController = storyboard.instantiateViewController(withIdentifier: "playlistViewController")
        self.present(myview, animated: true, completion: nil)
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
