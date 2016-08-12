//
//  LoginViewController.swift
//  Letsrun
//
//  Created by Edrick Pascual on 7/12/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth
import SwiftKeychainWrapper


class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var emailLoginTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var notAUserYetLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    
    @IBAction func loginTappedButton(sender: UIButton) {
        guard let userEmail = emailLoginTextfield.text, userPassword = passwordTextfield.text else {
            print("Form not valid")
            return
        }
        
        if loginButton.titleLabel?.text == "REGISTER" {
            
            // Sign up "Register"
            let userCredentialInfo = ["email": userEmail, "password": userPassword]
            performSegueWithIdentifier("showUserInfoViewController", sender: userCredentialInfo)
            print("ED:---- \(userCredentialInfo)")
            
        } else {
            // Sign in "Login"
            loginWithEmail()
        }
    }
    
    // MARK: Login with email
    func loginWithEmail() {
        guard let userEmail = emailLoginTextfield.text, userPassword = passwordTextfield.text else {
            
            // Show user if field is incomplete.
            // ErrorHandling.customErrorMessage("Please enter an email and password")
            print("Form not valid")
            return
        }
        
        FIRAuth.auth()?.signInWithEmail(userEmail, password: userPassword, completion: { (user: FIRUser?, error) in
            if error != nil {
                print("ED: --- Unable to auth with FIR")
                return
            } else {
                if let user = user {
                    let userData = ["provider": user.providerID]
                    self.performSegueWithIdentifier("presentTabBarController", sender: nil)
                    self.completeSignIn(user.uid, userData: userData)
                }
            }
        })
    }
    
    // MARK: Complete Sign in Firebase
    func completeSignIn(uid: String, userData: [String:AnyObject]) {
        DataSource.dataSource.createFirebaseUser(uid, userData: userData)
        let keyChainResult = KeychainWrapper.setString(uid, forKey: KEY_UID)
        print("ED: keychainResult HERE: \(keyChainResult)")
        performSegueWithIdentifier("presentTabBarController", sender: nil)
    }
    
    @IBAction func registerTappedButton(sender: UIButton) {
        if loginButton.titleLabel?.text == "LOGIN" {
            loginButton.setTitle("REGISTER", forState: .Normal)
            registerButton.setTitle("LOGIN", forState: .Normal)
            notAUserYetLabel.text = "Login Instead?"
            
        } else {
            loginButton.setTitle("LOGIN", forState: .Normal)
            registerButton.setTitle("REGISTER", forState: .Normal)
            notAUserYetLabel.text = "Need to register?"
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    
        
    }
    
    // Firebase Google SignIn Authentication
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if let error = error {
            // self.showMessagePrompt(error.localizedDescription)
            print(error.localizedDescription)
            return
        }
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken, accessToken: authentication.accessToken)
        FIRAuth.auth()?.signInWithCredential(credential, completion: { (user, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
                print("ED: --> User loggin in with google")
                self.performSegueWithIdentifier("presentTabBarController", sender: nil)
        })
    }
    
    //MARK: GID Sign out
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        if let error = error {
            print("\(error.localizedDescription)")
            return
        }
        try! FIRAuth.auth()?.signOut()
    }
    
    
    // MARK: Prepare segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showUserInfoViewController" {
            guard let navigationController = segue.destinationViewController as? UINavigationController, userInfoViewController = navigationController.topViewController as? CreateUserViewController, userCredentialInfo = sender as? [String:String] else { return }
            
            
            //            guard let  userInfoViewController = segue.destinationViewController as? UserInfoViewController, userCredentialInfo = sender as? [String: String] else { return }
            print(#function, userCredentialInfo)
            userInfoViewController.userCredentialInfo =  userCredentialInfo
        }
    }
}

extension UITextField {
    
    // Implement email and password validation
    
    func isValidEntry() -> Bool {
        if self.text != nil && self.text != "" {
            return true
        } else {
            return false
        }
    }
}









