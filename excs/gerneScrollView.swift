//
//  gerneScrollView.swift
//  excs
//
//  Created by user on 2018. 12. 3..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

class gerneScrollView: UIScrollView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if (view is UIButton) {
            return true
        }
        
        return super.touchesShouldCancel(in: view)
        
    }

}
