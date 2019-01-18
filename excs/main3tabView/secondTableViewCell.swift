//
//  secondTableViewCell.swift
//  excs
//
//  Created by user on 2018. 11. 30..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

class secondTableViewCell: UITableViewCell {
    
    @IBOutlet weak var albumArt: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var mnum: UILabel!
    @IBOutlet weak var musicInfoBtn: UIButton!
    
    var info : [String:Any]!
    
    var musicId : String!
    //    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    //    let myview: oneMusicInfoView = storyboard.instantiateViewController(withIdentifier: "musicInfoView") as! oneMusicInfoView
    //   myview.musicId = self.player
    //    self.present(myview, animated: true, completion: nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func musicInfoBtn(_ sender: Any) {
        UserDefaults.standard.set(musicId, forKey: "musicInfoSeek")
        UserDefaults.standard.setValue(info, forKey: "musicInfoSeek2")
        UserDefaults.standard.synchronize()
    }
    
}
