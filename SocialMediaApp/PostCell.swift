//
//  PostCell.swift
//  SocialMediaApp
//
//  Created by Kyle Nakamura on 12/7/16.
//  Copyright © 2016 Kyle Nakamura. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
