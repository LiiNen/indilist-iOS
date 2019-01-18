//
//  mainContainerSecond.swift
//  excs
//
//  Created by user on 2018. 11. 29..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

class mainContainerSecond: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if(indexPath.row == 0){
            return
        }
        UserDefaults.standard.setValue("true", forKey: "notME")
        UserDefaults.standard.setValue(numArray[indexPath.row - 1], forKey: "infoseekid")
        UserDefaults.standard.synchronize()
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let myview: artistPageView = storyboard.instantiateViewController(withIdentifier: "artistInfoS") as! artistPageView
        myview.artistIdForInfo = numArray[indexPath.row - 1]
        myview.albumStringFrom = albumArray[indexPath.row - 1]
        self.present(myview, animated: true, completion: nil)
    }
    var numArray = [-1, -1, -1, -1, -1]
    var albumArray = ["", "", "", "", ""]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indexNum2 = indexPath.row + 1
        let identifier2 = "recCell" + String(indexNum2)
        var cell = recTableViewCell()
        if(indexNum2 == 1){
            cell = recTableView.dequeueReusableCell(withIdentifier: identifier2) as! recTableViewCell
        }
        else{
            cell = recTableView.dequeueReusableCell(withIdentifier: identifier2) as! recTableViewCell
            if(recItemList.count == 0){
                return cell
            }
            
            let row = recItemList[indexPath.row - 1]
            switch(indexNum2){
            case 2 :
                cell.label21.text = row.name
                cell.label22.text = row.genre
                cell.image2.image = UIImage(named: "defaultUserImage")
                Alamofire.request(row.photourl).responseImage { response in
                    if let image = response.result.value{
                        cell.image2.layer.masksToBounds = true
                        cell.image2.image = image
                        cell.image2.layer.cornerRadius = cell.image2.bounds.size.width / 2
                    }
                }
                numArray[0] = row.num
                albumArray[0] = row.photourl
                break
            case 3 :
                cell.label31.text = row.name
                cell.label32.text = row.genre
                cell.image3.image = UIImage(named: "defaultUserImage")
                Alamofire.request(row.photourl).responseImage { response in
                    if let image = response.result.value{
                        cell.image3.layer.masksToBounds = true
                        cell.image3.image = image
                        cell.image3.layer.cornerRadius = cell.image3.bounds.size.width / 2
                    }
                }
                numArray[1] = row.num
                albumArray[1] = row.photourl
                break
            case 4 :
                cell.label41.text = row.name
                cell.label42.text = row.genre
                cell.image4.image = UIImage(named: "defaultUserImage")
                Alamofire.request(row.photourl).responseImage { response in
                    if let image = response.result.value{
                        cell.image4.layer.masksToBounds = true
                        cell.image4.image = image
                        cell.image4.layer.cornerRadius = cell.image4.bounds.size.width / 2
                    }
                }
                numArray[2] = row.num
                albumArray[2] = row.photourl
                break
            case 5 :
                cell.label51.text = row.name
                cell.label52.text = row.genre
                cell.image5.image = UIImage(named: "defaultUserImage")
                Alamofire.request(row.photourl).responseImage { response in
                    if let image = response.result.value{
                        cell.image5.layer.masksToBounds = true
                        cell.image5.image = image
                        cell.image5.layer.cornerRadius = cell.image5.bounds.size.width / 2
                    }
                }
                numArray[3] = row.num
                albumArray[3] = row.photourl
                break
            case 6 :
                cell.label61.text = row.name
                cell.label62.text = row.genre
                cell.image6.image = UIImage(named: "defaultUserImage")
                Alamofire.request(row.photourl).responseImage { response in
                    if let image = response.result.value{
                        cell.image6.layer.masksToBounds = true
                        cell.image6.image = image
                        cell.image6.layer.cornerRadius = cell.image6.bounds.size.width / 2
                    }
                }
                numArray[4] = row.num
                albumArray[4] = row.photourl
                break
            default:
                break
            }
        }
        
        return cell
    }
    
    
    @IBOutlet weak var recTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        recTableView.delegate = self
        recTableView.dataSource = self
        recLoad {
            print("fin")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(chartAgain), name: NSNotification.Name("ZZZ"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func chartAgain(){
        recLoad(completion: {
            self.recTableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    struct recItem{
        var name : String
        var like : Int
        var num : Int
        var genre : String
        var photourl : String
    }
    var recItemList = [recItem]()
    
    func recLoad(completion: @escaping ()->()){
        let url = "https://www.indi-list.com/GetRandArtist"
        let headers = ["Content-Type" : "application/json"]
        let para : Parameters = ["num" : 5]
        
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers : headers).responseJSON { response in
            if let json = response.result.value{
                let temp : NSArray = json as! NSArray
                for i in 0..<5{
                    self.recItemList.append(recItem(name: ((temp[i] as AnyObject).value(forKey: "artist_name") as? String)!, like: ((temp[i] as AnyObject).value(forKey: "artist_like") as? Int)!, num: ((temp[i] as AnyObject).value(forKey: "artist_num") as? Int)!, genre: ((temp[i] as AnyObject).value(forKey: "artist_genre") as? String)!, photourl: ((temp[i] as AnyObject).value(forKey: "artist_photo") as? String)!))
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
