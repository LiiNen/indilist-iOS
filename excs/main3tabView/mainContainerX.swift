//
//  mainContainerX.swift
//  excs
//
//  Created by user on 2018. 11. 30..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import SwiftyJSON

class mainContainerX: UIViewController {

    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    @IBOutlet weak var image6: UIImageView!
    @IBOutlet weak var image7: UIImageView!
    @IBOutlet weak var image8: UIImageView!
    @IBOutlet weak var image9: UIImageView!
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var title3: UILabel!
    @IBOutlet weak var title4: UILabel!
    @IBOutlet weak var title5: UILabel!
    @IBOutlet weak var title6: UILabel!
    @IBOutlet weak var title7: UILabel!
    @IBOutlet weak var title8: UILabel!
    @IBOutlet weak var title9: UILabel!
    @IBOutlet weak var artist1: UILabel!
    @IBOutlet weak var artist2: UILabel!
    @IBOutlet weak var artist3: UILabel!
    @IBOutlet weak var artist4: UILabel!
    @IBOutlet weak var artist5: UILabel!
    @IBOutlet weak var artist6: UILabel!
    @IBOutlet weak var artist7: UILabel!
    @IBOutlet weak var artist8: UILabel!
    @IBOutlet weak var artist9: UILabel!
    
    var imageGroup = [UIImageView]()
    var titleGroup = [UILabel]()
    var artistGroup = [UILabel]()
    
    func imageAppend(){
        imageGroup.append(image1)
        imageGroup.append(image2)
        imageGroup.append(image3)
        imageGroup.append(image4)
        imageGroup.append(image5)
        imageGroup.append(image6)
        imageGroup.append(image7)
        imageGroup.append(image8)
        imageGroup.append(image9)
    }
    
    func titleAppend(){
        titleGroup.append(title1)
        titleGroup.append(title2)
        titleGroup.append(title3)
        titleGroup.append(title4)
        titleGroup.append(title5)
        titleGroup.append(title6)
        titleGroup.append(title7)
        titleGroup.append(title8)
        titleGroup.append(title9)
    }
    
    func artistAppend(){
        artistGroup.append(artist1)
        artistGroup.append(artist2)
        artistGroup.append(artist3)
        artistGroup.append(artist4)
        artistGroup.append(artist5)
        artistGroup.append(artist6)
        artistGroup.append(artist7)
        artistGroup.append(artist8)
        artistGroup.append(artist9)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleAppend()
        artistAppend()
        imageAppend()
        
        lateLoad(completion:{
            print("lateload fin")
        })
        // Do any additional setup after loading the view.
    }
    
    func lateLoad(completion: @escaping ()->()){
        let url = "https://www.indi-list.com/getlatemusic"
        let headers = [ "Content-Type" : "application/json" ]
        let para : Parameters = [ "num" : 9]
        
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers : headers).responseJSON { response in
            
            if let json = response.result.value{
                let arrayTemp : NSArray = json as! NSArray
                for i in 0..<9{
                    self.newItemList.append(newItem(artist: ((arrayTemp[i] as AnyObject).value(forKey: "artist") as? String)!, title: ((arrayTemp[i] as AnyObject).value(forKey: "title") as? String)!, imageurl: ((arrayTemp[i] as AnyObject).value(forKey: "album-img") as? String)!, musicid: ((arrayTemp[i] as AnyObject).value(forKey: "music-id") as? String)!, like: ((arrayTemp[i] as AnyObject).value(forKey: "like") as? Int)!, gerne: ((arrayTemp[i] as AnyObject).value(forKey: "genre") as? String)!, artistimage: ((arrayTemp[i] as AnyObject).value(forKey: "artistIMG") as? String)!, time: ((arrayTemp[i] as AnyObject).value(forKey: "upload-time") as? String)!))
                    self.titleGroup[i].text = self.newItemList[i].title
                    self.artistGroup[i].text = self.newItemList[i].artist
                    self.imageGroup[i].af_setImage(withURL: URL(string: self.newItemList[i].imageurl)!)
                    self.imageGroup[i].isUserInteractionEnabled = true
                    let tapActionGesture = tapOnNewest(target: self, action: #selector(self.musicPlayAction(tapG:)))
                    tapActionGesture.index = i
                    self.imageGroup[i].addGestureRecognizer(tapActionGesture)
                }
            }
            completion()
        }
    }
    struct newItem{
        var artist : String
        var title : String
        var imageurl : String
        var musicid : String
        var like : Int
        var gerne : String
        var artistimage : String
        var time : String
    }
    var newItemList = [newItem]()
    
    @objc func musicPlayAction(tapG: tapOnNewest){
        let row = newItemList[tapG.index]
        let addingTemp = ["artist" : row.artist, "title" : row.title, "music-id" : row.musicid, "album-img" : row.imageurl, "like" : row.like, "gerne" : row.gerne, "artistIMG" : row.artistimage, "upload-time" : row.time] as [String : Any]
        print("my like state : ", row.like)
        UserDefaults.standard.set(addingTemp, forKey: "addMusic")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name("addingMusic"), object: nil)
        showToast(message: "재생목록에 추가되었습니다.")
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
    
    class tapOnNewest: UITapGestureRecognizer{
        var index = Int()
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
