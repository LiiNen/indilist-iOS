//
//  artistNewsCell.swift
//  excs
//
//  Created by user on 2019. 3. 4..
//  Copyright © 2019년 user. All rights reserved.
//

import UIKit
import Alamofire

class artistNewsCell: UITableViewCell {

    var info : [String : Any]!
//    cell.info = ["boardId" : row.boardId, "commentNum" : row.commentNum, "img1" : row.img1, "textContent" : row.textContent, "time" : row.time, "writerGenre" : row.writerGenre, "writerNick" : row.writerNick, "writerPhoto" : row.writerPhoto] as [String : Any]
    
    @IBOutlet weak var artistNewsFrame: UIView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func deleteBtn(_ sender: Any) {
        alertAc(mesAlert: "정말로 삭제하시겠습니까?", completion: {
            
        })
    }
    
    func alertAc(mesAlert:String, completion: @escaping ()->()){
        let myAlert = UIAlertController(title: "경고", message: mesAlert, preferredStyle: UIAlertController.Style.alert);
        
        let okAction = UIAlertAction(title: "네", style: UIAlertAction.Style.default) {
            UIAlertAction in
            let url = "https://indi-list.com/api/DelArtistNews"
            let para : Parameters = ["bid" : self.info["boardId"]!]
            let headers = ["x-access-token" : UserDefaults.standard.string(forKey: "loginToken")!]
            Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers: headers).responseString{ response in
                if(response.value! == "true"){
                    
                    NotificationCenter.default.post(name: NSNotification.Name("loadArtistNews"), object: nil)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "아니오", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            print("삭제 취소")
        }
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(myAlert, animated: true, completion: nil)
    }
}
