//
//  mycell9cell.swift
//  excs
//
//  Created by user on 2018. 12. 4..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

class mycell9cell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistGenreLabel: UILabel!
    @IBOutlet weak var rankingLabel: UILabel!
    
    var albumURL = String()
    var artistNUM = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
