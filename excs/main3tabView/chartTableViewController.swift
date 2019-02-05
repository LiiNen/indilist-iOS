//
//  chartTableViewController.swift
//  excs
//
//  Created by user on 2018. 11. 30..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import SwiftyJSON

class chartTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var chartTableView2: UITableView!
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
    
    var cchartItemList = [chartItem]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cchartItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chartTableView2.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! secondTableViewCell
        let rrow = cchartItemList[indexPath.row]
        cell.artist.text = rrow.artist
        cell.title.text = rrow.title
        cell.mnum.text = String(indexPath.row + 1)
        cell.albumArt.image = UIImage(named: "defaultMusicImage")
        
        cell.albumArt.af_setImage(withURL: URL(string: rrow.imageurl)!)
        
        cell.musicId = rrow.musicid
        cell.info = ["artist" : rrow.artist, "title" : rrow.title, "music-id" : rrow.musicid, "album-img" : rrow.imageurl, "like" : rrow.like, "gerne" : rrow.gerne, "artistIMG" : rrow.artistimage, "upload-time" : rrow.time] as [String : Any]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let row = cchartItemList[indexPath.row]
        let addingTemp = ["artist" : row.artist, "title" : row.title, "music-id" : row.musicid, "album-img" : row.imageurl, "like" : row.like, "gerne" : row.gerne, "artistIMG" : row.artistimage, "upload-time" : row.time] as [String : Any]
        UserDefaults.standard.set(addingTemp, forKey: "addMusic")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name("addingMusic"), object: nil)
        showToast(message: "재생목록에 추가되었습니다.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chartTableView2.delegate = self
        chartTableView2.dataSource = self
        tchartLoad(completion: {
            self.chartTableView2.reloadData()
            NotificationCenter.default.addObserver(self, selector: #selector(self.changechart), name: NSNotification.Name("chartChange"), object: nil)
        })
        NotificationCenter.default.addObserver(self, selector: #selector(chartAgain), name: NSNotification.Name("ZZZ"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func chartAgain(){
        tchartLoad(completion: {
            self.tqchartLoad {
                self.chartTableView2.reloadData()
                self.changechart()
            }
        })
    }
    
    func tqchartLoad(completion: @escaping ()->()){
        let url = "https://www.indi-list.com/getlatemusic"
        let headers = [ "Content-Type" : "application/json" ]
        let para : Parameters = [ "num" : 100]
        
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers : headers).responseJSON { response in
            
            if let json = response.result.value{
                self.cchartItemList.removeAll()
                let arrayTemp : NSArray = json as! NSArray
                for i in 0..<arrayTemp.count{
                    self.cchartItemList.append(chartItem(artist: ((arrayTemp[i] as AnyObject).value(forKey: "artist") as? String)!, title: ((arrayTemp[i] as AnyObject).value(forKey: "title") as? String)!, imageurl: ((arrayTemp[i] as AnyObject).value(forKey: "album-img") as? String)!, musicid: ((arrayTemp[i] as AnyObject).value(forKey: "music-id") as? String)!, like: ((arrayTemp[i] as AnyObject).value(forKey: "like") as? Int)!, gerne: ((arrayTemp[i] as AnyObject).value(forKey: "genre") as? String)!, artistimage: ((arrayTemp[i] as AnyObject).value(forKey: "artistIMG") as? String)!, time: ((arrayTemp[i] as AnyObject).value(forKey: "upload-time") as? String)!))
                }
            }
            completion()
        }
    }
    
    
    func tchartLoad(completion: @escaping ()->()){
        let url = "https://www.indi-list.com/getlist"
        let headers = [ "Content-Type" : "application/json" ]
        let para : Parameters = [ "num" : "5"]
        
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers : headers).responseJSON { response in
            
            if let json = response.result.value{
                self.cchartItemList.removeAll()
                let arrayTemp : NSArray = json as! NSArray
                for i in 0..<arrayTemp.count{
                    self.cchartItemList.append(chartItem(artist: ((arrayTemp[i] as AnyObject).value(forKey: "artist") as? String)!, title: ((arrayTemp[i] as AnyObject).value(forKey: "title") as? String)!, imageurl: ((arrayTemp[i] as AnyObject).value(forKey: "album-img") as? String)!, musicid: ((arrayTemp[i] as AnyObject).value(forKey: "music-id") as? String)!, like: ((arrayTemp[i] as AnyObject).value(forKey: "like") as? Int)!, gerne: ((arrayTemp[i] as AnyObject).value(forKey: "genre") as? String)!, artistimage: ((arrayTemp[i] as AnyObject).value(forKey: "artistIMG") as? String)!, time: ((arrayTemp[i] as AnyObject).value(forKey: "upload-time") as? String)!))
                }
            }
            completion()
        }
    }
    
    @objc func changechart(){
        let gurl = "https://indi-list.com/GetListByGenre"
        let headers = ["Content-Type" : "application/json"]
        var para : Parameters = ["limit" : 100, "genre" : ""]
        var tempStr = String()
        tempStr = UserDefaults.standard.value(forKey: "chartgenres") as! String
        para["genre"] = tempStr
        if(tempStr == "인기차트"){
            tchartLoad(completion:{
                self.chartTableView2.reloadData()
            })
        }
        else if(tempStr == "최신차트"){
            tqchartLoad(completion:{
                self.chartTableView2.reloadData()
            })
        }
        else{
            Alamofire.request(gurl, method: .post, parameters: para, encoding: JSONEncoding.default, headers : headers).responseJSON { response in
                print(response.result.value)
                if let json = response.result.value{
                    self.cchartItemList.removeAll()
                    let arrayTemp : NSArray = json as! NSArray
                    for i in 0..<arrayTemp.count{
                        self.cchartItemList.append(chartItem(artist: ((arrayTemp[i] as AnyObject).value(forKey: "artist") as? String)!, title: ((arrayTemp[i] as AnyObject).value(forKey: "title") as? String)!, imageurl: ((arrayTemp[i] as AnyObject).value(forKey: "album-img") as? String)!, musicid: ((arrayTemp[i] as AnyObject).value(forKey: "music-id") as? String)!, like: ((arrayTemp[i] as AnyObject).value(forKey: "like") as? Int)!, gerne: ((arrayTemp[i] as AnyObject).value(forKey: "genre") as? String)!, artistimage: ((arrayTemp[i] as AnyObject).value(forKey: "artistIMG") as? String)!, time: ((arrayTemp[i] as AnyObject).value(forKey: "upload-time") as? String)!))
                    }
                    self.chartTableView2.reloadData()
                }
                else{
                    self.cchartItemList.removeAll()
                    self.chartTableView2.reloadData()
                }
            }
        }
        self.chartTableView2.contentOffset = CGPoint(x: 0, y: 0 - self.chartTableView2.contentInset.top)
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
