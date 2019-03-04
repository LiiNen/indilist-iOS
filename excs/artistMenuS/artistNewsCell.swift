//
//  artistNewsCell.swift
//  excs
//
//  Created by user on 2019. 3. 4..
//  Copyright © 2019년 user. All rights reserved.
//

import UIKit

class artistNewsCell: UITableViewCell {

    var info : [String : Any]!
    
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

}
