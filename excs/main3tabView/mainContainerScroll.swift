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
        return 6
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if(indexPath.row == 0){
            return
        }
        else{
            let row = chartItemList[indexPath.row - 1]
            let addingTemp = ["artist" : row.artist, "title" : row.title, "music-id" : row.musicid, "album-img" : row.imageurl, "like" : row.like, "gerne" : row.gerne, "artistIMG" : row.artistimage, "upload-time" : row.time] as [String : Any]
            print("my like state : ", row.like)
            UserDefaults.standard.set(addingTemp, forKey: "addMusic")
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name("addingMusic"), object: nil)
            showToast(message: "재생목록에 추가되었습니다.")
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indexNum = indexPath.row + 1
        let identifier = "chartCell" + String(indexNum)
        var cell = chartTableViewCell()
        if(indexNum == 1){
            cell = charTableView.dequeueReusableCell(withIdentifier: identifier) as! chartTableViewCell
        }
        else{
            cell = charTableView.dequeueReusableCell(withIdentifier: identifier) as! chartTableViewCell
            if(chartItemList.count == 0){
                return cell
            }
            let row = chartItemList[indexPath.row - 1]
            //print(row)
            switch(indexNum){
            case 2 :
                cell.label21.text = row.title
                cell.label22.text = row.artist
                cell.image2.image = UIImage(named: "defaultMusicImage")
                Alamofire.request(row.imageurl).responseImage { response in
                    if let image = response.result.value{
                        cell.image2.image = image
                    }
                }
                break
            case 3 :
                cell.label31.text = row.title
                cell.label32.text = row.artist
                cell.image3.image = UIImage(named: "defaultMusicImage")
                Alamofire.request(row.imageurl).responseImage { response in
                    if let image = response.result.value{
                        cell.image3.image = image
                    }
                }
                break
            case 4 :
                cell.label41.text = row.title
                cell.label42.text = row.artist
                cell.image4.image = UIImage(named: "defaultMusicImage")
                Alamofire.request(row.imageurl).responseImage { response in
                    if let image = response.result.value{
                        cell.image4.image = image
                    }
                }
                break
            case 5 :
                cell.label51.text = row.title
                cell.label52.text = row.artist
                cell.image5.image = UIImage(named: "defaultMusicImage")
                Alamofire.request(row.imageurl).responseImage { response in
                    if let image = response.result.value{
                        cell.image5.image = image
                    }
                }
                break
            case 6 :
                cell.label61.text = row.title
                cell.label62.text = row.artist
                cell.image6.image = UIImage(named: "defaultMusicImage")
                Alamofire.request(row.imageurl).responseImage { response in
                    if let image = response.result.value{
                        cell.image6.image = image
                    }
                }
                break
            default:
                break
            }
            
            
        }
        return cell
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
                self.charTableView.reloadData()
            }
            //print(self.chartItemList)
            self.charTableView.reloadData()
            completion()
        }
    }
    @IBAction func info1(_ sender: Any){
        let itemTemp = chartItemList[0]
        let myinfo = ["artist" : itemTemp.artist, "title" : itemTemp.title, "music-id" : itemTemp.musicid, "album-img" : itemTemp.imageurl, "like" : itemTemp.like, "gerne" : itemTemp.gerne, "artistIMG" : itemTemp.artistimage, "upload-time" : itemTemp.time] as [String : Any]
        UserDefaults.standard.set(itemTemp.musicid, forKey: "musicInfoSeek")
        UserDefaults.standard.setValue(myinfo, forKey: "musicInfoSeek2")
        gotoinfo()
    }
    @IBAction func info2(_ sender: Any){
        let itemTemp = chartItemList[1]
        let myinfo = ["artist" : itemTemp.artist, "title" : itemTemp.title, "music-id" : itemTemp.musicid, "album-img" : itemTemp.imageurl, "like" : itemTemp.like, "gerne" : itemTemp.gerne, "artistIMG" : itemTemp.artistimage, "upload-time" : itemTemp.time] as [String : Any]
        UserDefaults.standard.set(itemTemp.musicid, forKey: "musicInfoSeek")
        UserDefaults.standard.setValue(myinfo, forKey: "musicInfoSeek2")
        gotoinfo()
    }
    @IBAction func info3(_ sender: Any){
        let itemTemp = chartItemList[2]
        let myinfo = ["artist" : itemTemp.artist, "title" : itemTemp.title, "music-id" : itemTemp.musicid, "album-img" : itemTemp.imageurl, "like" : itemTemp.like, "gerne" : itemTemp.gerne, "artistIMG" : itemTemp.artistimage, "upload-time" : itemTemp.time] as [String : Any]
        UserDefaults.standard.set(itemTemp.musicid, forKey: "musicInfoSeek")
        UserDefaults.standard.setValue(myinfo, forKey: "musicInfoSeek2")
        gotoinfo()
    }
    @IBAction func info4(_ sender: Any){
        let itemTemp = chartItemList[3]
        let myinfo = ["artist" : itemTemp.artist, "title" : itemTemp.title, "music-id" : itemTemp.musicid, "album-img" : itemTemp.imageurl, "like" : itemTemp.like, "gerne" : itemTemp.gerne, "artistIMG" : itemTemp.artistimage, "upload-time" : itemTemp.time] as [String : Any]
        UserDefaults.standard.set(itemTemp.musicid, forKey: "musicInfoSeek")
        UserDefaults.standard.setValue(myinfo, forKey: "musicInfoSeek2")
        gotoinfo()
    }
    @IBAction func info5(_ sender: Any){
        let itemTemp = chartItemList[4]
        let myinfo = ["artist" : itemTemp.artist, "title" : itemTemp.title, "music-id" : itemTemp.musicid, "album-img" : itemTemp.imageurl, "like" : itemTemp.like, "gerne" : itemTemp.gerne, "artistIMG" : itemTemp.artistimage, "upload-time" : itemTemp.time] as [String : Any]
        UserDefaults.standard.set(itemTemp.musicid, forKey: "musicInfoSeek")
        UserDefaults.standard.setValue(myinfo, forKey: "musicInfoSeek2")
        gotoinfo()
    }
    
    func gotoinfo(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let myview: oneMusicInfoView = storyboard.instantiateViewController(withIdentifier: "musicInfoView") as! oneMusicInfoView
        myview.musicId = UserDefaults.standard.string(forKey: "musicInfoSeek")!
        myview.info = UserDefaults.standard.value(forKey: "musicInfoSeek2")! as! [String : Any]
        self.present(myview, animated: true, completion: nil)
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


