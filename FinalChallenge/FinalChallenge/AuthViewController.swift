//
//  AuthViewController.swift
//  FinalChallenge
//
//  Created by Evandro Henrique Couto de Paula on 15/09/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

//
//  Copyright (c) 2016 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI

let kFirebaseTermsOfService = NSURL(string: "https://firebase.google.com/terms/")!

// Your Google app's client ID, which can be found in the GoogleService-Info.plist file
// and is stored in the `clientID` property of your FIRApp options.
// Firebase Google auth is built on top of Google sign-in, so you'll have to add a URL
// scheme to your project as outlined at the bottom of this reference:
// https://developers.google.com/identity/sign-in/ios/start-integrating
let kGoogleAppClientID = (FIRApp.defaultApp()?.options.clientID)!

// Your Facebook App ID, which can be found on developers.facebook.com.
let kFacebookAppID     = "your fb app ID here"

/// A view controller displaying a basic sign-in flow using FIRAuthUI.
class AuthViewController: UIViewController {
    // Before running this sample, make sure you've correctly configured
    // the appropriate authentication methods in Firebase console. For more
    // info, see the Auth README at ../../FirebaseAuthUI/README.md
    // and https://firebase.google.com/docs/auth/
    
    private var authStateDidChangeHandle: FIRAuthStateDidChangeListenerHandle?
    
    private(set) var auth: FIRAuth? = FIRAuth.auth()
    private(set) var authUI: FIRAuthUI? = FIRAuthUI.authUI()
    
    @IBOutlet private var signOutButton: UIButton!
    @IBOutlet private var startButton: UIButton!
    
    @IBOutlet private var signedInLabel: UILabel!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var uidLabel: UILabel!
    
    @IBOutlet var topConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // If you haven't set up your authentications correctly these buttons
        // will still appear in the UI, but they'll crash the app when tapped.
        let providers: [FIRAuthProviderUI] = [
            FIRGoogleAuthUI(clientID: kGoogleAppClientID)!,
            FIRFacebookAuthUI(appID: kFacebookAppID)!,
            ]
        self.authUI?.signInProviders = providers
        
        self.authUI?.termsOfServiceURL = kFirebaseTermsOfService as URL
        
        self.authStateDidChangeHandle =
            self.auth?.addStateDidChangeListener(self.updateUI(auth:user:))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let handle = self.authStateDidChangeHandle {
            self.auth?.removeStateDidChangeListener(handle)
        }
    }
    
    @IBAction func startPressed(sender: AnyObject) {
        let controller = self.authUI!.authViewController()
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func signOutPressed(sender: AnyObject) {
        do {
            try self.auth?.signOut()
        } catch let error {
            // Again, fatalError is not a graceful way to handle errors.
            // This error is most likely a network error, so retrying here
            // makes sense.
            fatalError("Could not sign out: \(error)")
        }
    }
    
    // Boilerplate
    func updateUI(auth: FIRAuth, user: FIRUser?) {
        if let user = user {
            self.signOutButton.isEnabled = true
            self.startButton.isEnabled = false
            
            self.signedInLabel.text = "Signed in"
            self.nameLabel.text = "Name: " + (user.displayName ?? "(null)")
            self.emailLabel.text = "Email: " + (user.email ?? "(null)")
            self.uidLabel.text = "UID: " + user.uid
        } else {
            self.signOutButton.isEnabled = false
            self.startButton.isEnabled = true
            
            self.signedInLabel.text = "Not signed in"
            self.nameLabel.text = "Name"
            self.emailLabel.text = "Email"
            self.uidLabel.text = "UID"
        }
    }
    
    override func viewWillLayoutSubviews() {
        self.topConstraint.constant = self.topLayoutGuide.length
    }
    
}
