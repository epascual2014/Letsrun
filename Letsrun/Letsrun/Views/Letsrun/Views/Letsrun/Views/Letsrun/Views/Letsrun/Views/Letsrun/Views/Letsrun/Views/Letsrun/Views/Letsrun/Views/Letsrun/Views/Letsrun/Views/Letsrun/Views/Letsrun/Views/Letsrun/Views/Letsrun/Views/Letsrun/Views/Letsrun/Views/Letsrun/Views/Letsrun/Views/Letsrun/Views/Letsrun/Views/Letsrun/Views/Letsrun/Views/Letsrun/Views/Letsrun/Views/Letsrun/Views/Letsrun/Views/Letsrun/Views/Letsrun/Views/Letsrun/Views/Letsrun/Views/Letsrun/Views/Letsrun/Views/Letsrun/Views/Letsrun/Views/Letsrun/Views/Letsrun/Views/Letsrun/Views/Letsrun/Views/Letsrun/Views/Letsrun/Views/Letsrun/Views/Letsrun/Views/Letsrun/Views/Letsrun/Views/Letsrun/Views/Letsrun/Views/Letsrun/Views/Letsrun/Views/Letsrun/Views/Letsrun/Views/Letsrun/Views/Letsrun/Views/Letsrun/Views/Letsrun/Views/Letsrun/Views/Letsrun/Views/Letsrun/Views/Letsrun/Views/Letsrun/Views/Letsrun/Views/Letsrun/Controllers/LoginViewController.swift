//
//  LoginViewController.swift
//  Letsrun
//
//  Created by Edrick Pascual on 7/12/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    
    @IBOutlet weak var emailLoginTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var notAUserYetLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    
    @IBAction func loginTappedButton(sender: UIButton) {
        if emailLoginTextfield.isValidEntry() && passwordTextfield.isValidEntry() {
            if loginButton.titleLabel?.text == "REGISTER" {
                // Sign up "Register"
                let userCredentialInfo = ["email": emailLoginTextfield.text!, "password": passwordTextfield.text!]
                print(#function, userCredentialInfo)
                performSegueWithIdentifier("showUserInfoViewController", sender: userCredentialInfo)
            } else {
                // Sign in "Login"
                loginUser(emailLoginTextfield.text!, password:passwordTextfield.text!)
                
            }
        } else {
            // alert the user to enter a valid text
        }
     }

    @IBAction func registerTappedButton(sender: UIButton) {
        if loginButton.titleLabel?.text == "LOGIN" {
            loginButton.setTitle("REGISTER", forState: .Normal)
            registerButton.setTitle("LOGIN", forState: .Normal)
            notAUserYetLabel.text = "Ready to LOGIN?"
            
        } else {
            loginButton.setTitle("LOGIN", forState: .Normal)
            registerButton.setTitle("REGISTER", forState: .Normal)
            notAUserYetLabel.text = "Need to register?"
            
        }
        
    }
    
    func loginUser(email: String, password: String) {
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { user, error in
            if error != nil {
                print("incorrect")
            } else {
                print ("Success \(user!).uid")
                self.dismissViewControllerAnimated(true, completion: nil)
                self.performSegueWithIdentifier("presentTabController", sender: nil)
            }
        })
        print (#function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FIRAuth.auth()?.currentUser != nil {
            // Segue to main viewcontroller
            performSegueWithIdentifier("presentTabController", sender: nil)
        }

        GIDSignIn.sharedInstance().uiDelegate = self
        // Uncomment to automatically sign in the user.
        
        //GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign in button look/feel
        //
    }

    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on sign in user here
            //
        } else {
            print("\(error.localizedDescription)")
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showUserInfoViewController" {
            guard let  userInfoViewController = segue.destinationViewController as? UserInfoViewController, userCredentialInfo = sender as? [String: String] else { return }
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


