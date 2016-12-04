//
//  RoundButton.swift
//  SocialMediaApp
//
//  Created by Kyle Nakamura on 12/3/16.
//  Copyright © 2016 Kyle Nakamura. All rights reserved.
//

import UIKit

class RoundButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(displayP3Red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1, height: 1)
        imageView?.contentMode = .scaleAspectFit            // Make a button's image scaleToFit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let thisWidth = self.frame.width
        if thisWidth.remainder(dividingBy: 2) == 0 {
            layer.cornerRadius = thisWidth/2
        } else {
            layer.cornerRadius = thisWidth/2 + 1
        }
    }

}
