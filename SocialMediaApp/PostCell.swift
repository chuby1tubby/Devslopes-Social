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
    @IBOutlet weak var likeImg: UIImageView!
    
    // Variables
    var post: Post!
    var likesRef: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Programatically adding a tap recognizer for the heart image in each Post Cell (must be done with code, not with storyboard)
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        
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
        
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "empty-heart")  // User hasn't liked the post
            } else {
                self.likeImg.image = UIImage(named: "filled-heart") // User has liked the post
            }
        })
        
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "filled-heart")  // User hasn't liked the post
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
            } else {
                self.likeImg.image = UIImage(named: "empty-heart") // User has liked the post
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        })
    }
}
