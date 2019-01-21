//
//  chartTableViewCell.swift
//  excs
//
//  Created by user on 2018. 11. 29..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

class chartTableViewCell: UITableViewCell {

    @IBOutlet weak var imageMusic: UIImageView!
    
    @IBOutlet weak var labelMusic: UILabel!
    @IBOutlet weak var labelArtist: UILabel!
    
    @IBOutlet weak var musicInfoBtn: UIButton!
    @IBOutlet weak var rankNum: UILabel!
    
    var info : [String:Any]!
    
    var musicId : String!
    
    
    @IBAction func musicInfoBtn(_ sender: Any) {
        UserDefaults.standard.set(musicId, forKey: "musicInfoSeek")
        UserDefaults.standard.setValue(info, forKey: "musicInfoSeek2")
        UserDefaults.standard.synchronize()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
