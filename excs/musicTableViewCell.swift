//
//  musicTableViewCell.swift
//  excs
//
//  Created by user on 2018. 11. 28..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class musicTableViewCell: UITableViewCell {

    
    var info : [String:Any]!
    
    @IBOutlet weak var albumArtImageView: UIImageView!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    var musicid = String()
    var headers = ["x-access-token" : ""]
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var infoBtnBtn: UIButton!
    
    @IBAction func musicInfoBtn(_ sender: Any) {
        UserDefaults.standard.set(musicid, forKey: "musicInfoSeek")
        UserDefaults.standard.setValue(info, forKey: "musicInfoSeek2")
        UserDefaults.standard.synchronize()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    @IBAction func deleteBtn(_ sender: Any) {
        NotificationCenter.default.addObserver(self, selector: #selector(deleteFunc), name: NSNotification.Name("deleteChk"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("deleteAlert" + musicid), object: nil)
    }
    @objc func deleteFunc(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("deleteChk"), object: nil)
        let sign = UserDefaults.standard.string(forKey: "deleteAns")
        if(sign == "true"){
            let str = self.musicid
            let para : Parameters = ["mid" : str]
            let tokS = UserDefaults.standard.string(forKey: "loginToken")!
            print(tokS)
            headers["x-access-token"] = tokS
            print(headers)
            Alamofire.request("https://indi-list.com/api/deleteSong", method: .post, parameters: para, encoding: JSONEncoding.default, headers: headers).responseString { response in
                print(response)
                print(response.result.value)
            }
        }
        UserDefaults.standard.removeObject(forKey: "deleteAns")
        
        
    }
    
}
