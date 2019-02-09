//
//  oneMusicCell.swift
//  excs
//
//  Created by user on 2018. 12. 2..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

class oneMusicCell: UITableViewCell {

    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var commentUser: UILabel!
    @IBOutlet weak var commentContent: UILabel!
    @IBOutlet weak var commentTime: UILabel!
    @IBOutlet weak var commentLikes : UILabel!
    var commentLike: Int!

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
