//
//  ShadowView.swift
//  SocialMediaApp
//
//  Created by Kyle Nakamura on 12/3/16.
//  Copyright © 2016 Kyle Nakamura. All rights reserved.
//

import UIKit

class ShadowView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(displayP3Red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1, height: 1)
        
        layer.cornerRadius = 2
    }

}
