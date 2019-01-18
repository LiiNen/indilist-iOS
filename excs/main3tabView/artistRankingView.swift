//
//  artistRankingView.swift
//  excs
//
//  Created by user on 2018. 12. 4..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class artistRankingView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : mycell9cell = tableView.dequeueReusableCell(withIdentifier: "mycell9") as! mycell9cell
        let row = recItemList[indexPath.row]
        cell.artistNameLabel.text = row.name
        cell.artistGenreLabel.text = row.genre
        cell.rankingLabel.text = String(indexPath.row + 1)
        cell.userImage.image = UIImage(named: "defaultUserImage")
        Alamofire.request(row.photourl).responseImage { response in
            if let image = response.result.value{
                cell.userImage.layer.masksToBounds = true
                cell.userImage.image = image
                cell.userImage.layer.cornerRadius = cell.userImage.bounds.size.width / 2
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        UserDefaults.standard.setValue("true", forKey: "notME")
        UserDefaults.standard.setValue(self.recItemList[indexPath.row].num, forKey: "infoseekid")
        UserDefaults.standard.synchronize()
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let myview: artistPageView = storyboard.instantiateViewController(withIdentifier: "artistInfoS") as! artistPageView
        myview.artistIdForInfo = self.recItemList[indexPath.row].num
        myview.albumStringFrom = self.recItemList[indexPath.row].photourl
        self.present(myview, animated: true, completion: nil)
    }

    struct recItem{
        var name : String
        var like : Int
        var num : Int
        var genre : String
        var photourl : String
        var num_song : Int
    }
    var recItemList = [recItem]()
    @IBOutlet weak var recTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recLoad(completion: {
            self.recTableView.reloadData()
        })
        // Do any additional setup after loading the view.
    }
    
    func recLoad(completion: @escaping ()->()){
        let url = "https://indi-list.com/GetArtistRanking"
        let headers = ["Content-Type" : "application/json"]
        let para : Parameters = ["num" : 100]
        
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers : headers).responseJSON { response in
            if let json = response.result.value{
                let temp : NSArray = json as! NSArray
                for i in 0..<temp.count{
                    self.recItemList.append(recItem(name: ((temp[i] as AnyObject).value(forKey: "artist_name") as? String)!, like: ((temp[i] as AnyObject).value(forKey: "artist_like") as? Int)!, num: ((temp[i] as AnyObject).value(forKey: "artist_num") as? Int)!, genre: ((temp[i] as AnyObject).value(forKey: "artist_genre") as? String)!, photourl: ((temp[i] as AnyObject).value(forKey: "artist_photo") as? String)!, num_song: ((temp[i] as AnyObject).value(forKey: "num_song") as! Int)))
                }
                self.recTableView.reloadData()
            }
            self.recTableView.reloadData()
            completion()
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

}
