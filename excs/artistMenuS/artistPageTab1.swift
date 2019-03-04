//
//  artistPageTab1.swift
//  excs
//
//  Created by user on 2018. 11. 27..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage

class artistPageTab1: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var newsTableView: UITableView!
    struct newsItem{
        var boardId : Int
        var commentNum : Int
        var img1 : String
        var textContent : String
        var time : String
        var writerGenre : String
        var writerNick : String
        var writerPhoto : String
    }
    var newsItemList = [newsItem]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistNewsCell") as! artistNewsCell
        cell.artistNewsFrame.layer.borderWidth = 0.5
        cell.artistNewsFrame.layer.borderColor = UIColor.gray.cgColor
        cell.artistNewsFrame.layer.cornerRadius = 5
        
        let row = newsItemList[indexPath.row]
        cell.info = ["boardId" : row.boardId, "commentNum" : row.commentNum, "img1" : row.img1, "textContent" : row.textContent, "time" : row.time, "writerGenre" : row.writerGenre, "writerNick" : row.writerNick, "writerPhoto" : row.writerPhoto] as [String : Any]
        
        cell.artistImageView.af_setImage(withURL: URL(string: row.writerPhoto)!)
        cell.artistImageView.layer.masksToBounds = true
        cell.artistImageView.layer.cornerRadius = 0.5 * cell.artistImageView.bounds.size.width
        
        if (row.img1 != "") {
            cell.newsImageView.af_setImage(withURL: URL(string: row.img1)!)
        }
        else{
            
        }
        cell.artistLabel.text = row.writerNick
        
        let timeString = row.time as String
        let splited = timeString.components(separatedBy: "-")
        let splited2array = Array(splited[2])
        let daytext : String = "\(splited2array[0])\(splited2array[1])"
        let timetext : String = "\(splited2array[3])\(splited2array[4])\(splited2array[5])\(splited2array[6])\(splited2array[7])"
        cell.timeLabel.text = splited[0] + "." + splited[1] + "." + daytext + " / " + timetext
        cell.timeLabel.textColor = UIColor.gray
        
        cell.contentTextView.text = row.textContent
        cell.contentTextView.textContainer.lineFragmentPadding = 0
        cell.contentTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name("loadArtistNews"), object: nil)
        print("whydoesnoe")
        NotificationCenter.default.addObserver(self, selector: #selector(loadNews), name: NSNotification.Name("loadArtistNews"), object: nil)
        loadNews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loadNews(){
        print("success load action")
        
        let url = "https://indi-list.com/GetPersonalArtistNewsbyNum"
        var para = ["num" : 0]
        para["num"] = UserDefaults.standard.value(forKey: "artistNewsId") as? Int
        print("the number is : ", para["num"]!)
        let headers = [ "Content-Type" : "application/json"]
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            if let json = response.result.value {
                let arrayTemp : NSArray  = json as! NSArray
                for i in 0..<arrayTemp.count{
                    var tempImg = ""
                    if let temper = (arrayTemp[i] as AnyObject).value(forKey: "img_1") as? String {
                        tempImg = temper
                    }
                    self.newsItemList.append(newsItem(
                        boardId: ((arrayTemp[i] as AnyObject).value(forKey: "board_id") as? Int)!,
                        commentNum: ((arrayTemp[i] as AnyObject).value(forKey: "comment_num") as? Int)!,
                        img1: tempImg,
                        textContent: ((arrayTemp[i] as AnyObject).value(forKey: "text_content") as? String)!,
                        time: (((arrayTemp[i]) as AnyObject).value(forKey: "time") as? String)!, writerGenre: ((arrayTemp[i] as AnyObject).value(forKey: "writer_genre") as? String)!,
                        writerNick: ((arrayTemp[i] as AnyObject).value(forKey: "writer_nick") as? String)!,
                        writerPhoto: ((arrayTemp[i] as AnyObject).value(forKey: "writer_photo") as? String)!
                    ))
                    print(self.newsItemList[i])
                }
            }
            self.newsTableView.reloadData()
            
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
