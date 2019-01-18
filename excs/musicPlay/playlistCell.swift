//
//  playlistCell.swift
//  excs
//
//  Created by user on 2018. 12. 1..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

class playlistCell: UITableViewCell {

    var artist : String!
    var title : String!
    var imageurl : String!
    var musicid : String!
    var like : Int!
    var gerne : String!
    var artistimage : String!
    var time : String!
    @IBOutlet weak var albumArt: UIImageView!
    @IBOutlet weak var musicTitle: UILabel!
    @IBOutlet weak var musicArtist: UILabel!
    
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
