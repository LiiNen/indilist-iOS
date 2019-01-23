//
//  mainContainerScroll.swift
//  excs
//
//  Created by user on 2018. 11. 29..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

class mainContainerScroll: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let row = chartItemList[indexPath.row]
        let addingTemp = ["artist" : row.artist, "title" : row.title, "music-id" : row.musicid, "album-img" : row.imageurl, "like" : row.like, "gerne" : row.gerne, "artistIMG" : row.artistimage, "upload-time" : row.time] as [String : Any]
        print("my like state : ", row.like)
        UserDefaults.standard.set(addingTemp, forKey: "addMusic")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name("addingMusic"), object: nil)
        showToast(message: "재생목록에 추가되었습니다.")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = chartTableViewCell()
        
        cell = charTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! chartTableViewCell
        if(chartItemList.count == 0){
            return cell
        }
        let row = chartItemList[indexPath.row]
        cell.rankNum.text = String(indexPath.row + 1)
        cell.labelMusic.text = row.title
        cell.labelArtist.text = row.artist
        cell.imageMusic.image = UIImage(named: "defaultMusicImage")
        
        cell.imageMusic.af_setImage(withURL: URL(string: row.imageurl)!)
        
        cell.musicId = row.musicid
        cell.info = ["artist" : row.artist, "title" : row.title, "music-id" : row.musicid, "album-img" : row.imageurl, "like" : row.like, "gerne" : row.gerne, "artistIMG" : row.artistimage, "upload-time" : row.time] as [String : Any]
        cell.musicInfoBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        cell.musicInfoBtn.imageEdgeInsets = UIEdgeInsets(top: CGFloat(10), left: CGFloat(10), bottom: CGFloat(10), right: CGFloat(10))
        return cell
    }
    
    @objc func buttonAction(sender: UIButton){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let myview: oneMusicInfoView = storyboard.instantiateViewController(withIdentifier: "musicInfoView") as! oneMusicInfoView
        myview.musicId = UserDefaults.standard.string(forKey: "musicInfoSeek")!
        myview.info = UserDefaults.standard.value(forKey: "musicInfoSeek2")! as! [String : Any]
        self.present(myview, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var charTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        charTableView.delegate = self
        charTableView.dataSource = self
        chartLoad(completion: {
            self.charTableView.reloadData()
        })
        NotificationCenter.default.addObserver(self, selector: #selector(chartAgain), name: NSNotification.Name("ZZZ"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func chartAgain(){
        chartLoad(completion: {
            self.charTableView.reloadData()
        })
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    struct chartItem{
        var artist : String
        var title : String
        var imageurl : String
        var musicid : String
        var like : Int
        var gerne : String
        var artistimage : String
        var time : String
    }
    var chartItemList = [chartItem]()
    
    func chartLoad(completion: @escaping ()->()){
        let url = "https://www.indi-list.com/getlist"
        let headers = [ "Content-Type" : "application/json" ]
        let para : Parameters = [ "num" : "5"]
        
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers : headers).responseJSON { response in
            //print("chart:", response.result.value)
            if let json = response.result.value{
                //print(json)
                let arrayTemp : NSArray = json as! NSArray
                for i in 0..<5{
                    self.chartItemList.append(chartItem(artist: ((arrayTemp[i] as AnyObject).value(forKey: "artist") as? String)!, title: ((arrayTemp[i] as AnyObject).value(forKey: "title") as? String)!, imageurl: ((arrayTemp[i] as AnyObject).value(forKey: "album-img") as? String)!, musicid: ((arrayTemp[i] as AnyObject).value(forKey: "music-id") as? String)!, like: ((arrayTemp[i] as AnyObject).value(forKey: "like") as? Int)!, gerne: ((arrayTemp[i] as AnyObject).value(forKey: "genre") as? String)!, artistimage: ((arrayTemp[i] as AnyObject).value(forKey: "artistIMG") as? String)!, time: ((arrayTemp[i] as AnyObject).value(forKey: "upload-time") as? String)!))
                }
            }
            completion()
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
    
}


