//
//  CircleImage.swift
//  SocialMediaApp
//
//  Created by Kyle Nakamura on 12/7/16.
//  Copyright © 2016 Kyle Nakamura. All rights reserved.
//

import UIKit

class CircleImage: UIImageView {
    
    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width/2
        clipsToBounds = true
    }
}
