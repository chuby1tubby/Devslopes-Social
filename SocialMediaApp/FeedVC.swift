//
//  FeedVC.swift
//  SocialMediaApp
//
//  Created by Kyle Nakamura on 12/5/16.
//  Copyright © 2016 Kyle Nakamura. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("Kyle: ID removed from Keychain\(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
}
