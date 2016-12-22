//
//  FeedVC.swift
//  SocialMediaApp
//
//  Created by Kyle Nakamura on 12/5/16.
//  Copyright © 2016 Kyle Nakamura. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImage: CircleImage!
    @IBOutlet weak var captionField: CustomField!
    
    // Variables
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true    // Allow user to move picture around and crop
        imagePicker.delegate = self
        
        // Listen for changes in database
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            
            self.posts = []
            
            // Seperate the data from 'snapshot' into parsed data (individual objects printed seperately)
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })

    }
    
    // Table View functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
                return cell
            } else {
                cell.configureCell(post: post)
                return cell
            }
        } else {
            return PostCell()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImage.image = image  // Replaces the image on the "addImage" button with the user's image
            imageSelected = true
        } else {
            print("KYLE: A valid image was not selected.")
        }
        imagePicker.dismiss(animated: true, completion: nil)    // Hide the image picker once the user selects an image
    }
    
    @IBAction func postbuttonTapped(_ sender: Any) {
        // Guard: checks for these conditions, and if the conditions are false, it enters the brackets
        guard let caption = captionField.text, caption != "" else {
            print("KYLE: Caption must be enterred")
            return
        }
        // Print an error if the image is nil or if an image was not selected
        guard let img = addImage.image, imageSelected == true else {
            print("KYLE: An image must be selected")
            return
        }
        
        // Convert image to imageData and compress to 20% quality
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imgUid).put(imgData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("KYLE: Unable to upload image to Firebase storage")
                } else {
                    print("KYLE: Successfully uploaded image to Firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postToFirebase(imgUrl: url)
                    }
                }
            }
        }
    }
    
    func postToFirebase(imgUrl: String) {
        let post: Dictionary<String, AnyObject> = [
            "caption" : captionField.text as AnyObject,
            "imageUrl" : imgUrl as AnyObject,
            "likes" : 0 as AnyObject
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        self.captionField.text = ""
        self.addImage.image = UIImage(named: "add-image")
        imageSelected = false
        
        tableView.reloadData()  // Update visuals for the table view
    }
    
    @IBAction func addimageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func signoutTapped(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("Kyle: ID removed from Keychain\(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
}
