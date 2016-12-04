//
//  SignInVC.swift
//  SocialMediaApp
//
//  Created by Kyle Nakamura on 12/2/16.
//  Copyright © 2016 Kyle Nakamura. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // This code is required for Facebook Auth (Use for any "sign in with facebook" button
    @IBAction func FBButtonTapped(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Kyle: unable to authenticate with Facebook.")
            } else if result?.isCancelled == true {
                print("Kyle: User cancelled Facebook Authentication.")
            } else {
                print("Kyle: Successfully authenticated with Facebook.")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    // This function is also required for Firebase Auth
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Kyle: Unable to authenticate with Firebase. - \(error!)")
            } else {
                print("Kyle: Successfully authenticated with Firebase.")
            }
        })
    }
}
