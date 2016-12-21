//
//  PostCell.swift
//  SocialMediaApp
//
//  Created by Kyle Nakamura on 12/7/16.
//  Copyright © 2016 Kyle Nakamura. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    
    // Variables
    var post: Post!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        self.caption.text = post.caption
        self.likesLabel.text = String(post.likes)
        
        // Retreive image from device cache OR from Firebase Storage
        // If image already cached
        if img != nil {
            self.postImg.image = img
        }
        // Else, download image from URL
        else {
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize: 2*1024*1024, completion: { (data, error) in
                if error != nil {
                    print("KYLE: Unable to download image from Firebase storage")
                } else {
                    print("KYLE: Image downloaded from Firebase storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
    }
}
