//
//  CircularButton.swift
//  Simon Says
//
//  Created by Michael Jajou on 11/7/18.
//  Copyright © 2018 Michael Jajou. All rights reserved.
//

import UIKit

class CircularButton: UIButton {

    
    override func awakeFromNib() {
        layer.cornerRadius = frame.size.width / 2
        layer.masksToBounds = true
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                alpha = 1.0
            } else {
                alpha = 0.5
            }
        }
    }

}
